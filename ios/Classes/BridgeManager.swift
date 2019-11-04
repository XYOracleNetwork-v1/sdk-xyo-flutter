//
//  BridgeManager.swift
//  xyo_ble
//
//  Created by Darren Sutherland on 6/26/19.
//

import Foundation
import secp256k1
import sdk_core_swift
import sdk_bletcpbridge_swift
import sdk_objectmodel_swift

internal class BridgeManager {
  public static let instance = BridgeManager()
  private static let signerKey = Array("P_KEY_IOS_XYO".utf8)
  
  static let defaultDeviceBridgeName = NSLocalizedString("Mobile Device", comment: "Initial device name")
  
  let hasher = XyoSha256()
  let storage = CoreDataStorage()
  lazy var blockRepo = XyoStorageProviderOriginBlockRepository(storageProvider: self.storage, hasher: self.hasher)
  lazy var stateRepo = XyoStorageOriginStateRepository(storage: self.storage)
  lazy var queueRepo = XyoStorageBridgeQueueRepository(storage: self.storage)
  lazy var configuration = XyoRepositoryConfiguration(originState: self.stateRepo, originBlock: self.blockRepo)
  lazy var bridge = XyoBleToTcpBridge(hasher: self.hasher,
                                      repositoryConfiguration: configuration,
                                      queueRepository: self.queueRepo)
  
  private init() {}
  
  public func enableBridge(enabled: Bool) {
    self.bridge.enableBoundWitnesses(enable: enabled)
  }
  
  public func restoreAndInitBridge () {
    
    XyoHumanHeuristics.resolvers[XyoSchemas.RSSI.id] = RssiResolver()
    XyoHumanHeuristics.resolvers[XyoSchemas.INDEX.id] = IndexResolver()
    XyoHumanHeuristics.resolvers[XyoSchemas.UNIX_TIME.id] = TimeResolver()
    XyoHumanHeuristics.resolvers[XyoSchemas.GPS.id] = GpsResolver()
    
    bridge.bridgeInterval = 4
    bridge.tcpBridgeLimit = 80
    bridge.bleBridgeLimit = 10
    bridge.blocksToBridge.removeWeight = 2
    
    do {
      stateRepo.restoreState(signers: [getSignerFromStorage()])
      queueRepo.restoreQueue()
      
      bridge.addHeuristic(key: "TIME", getter: XyoUnixTime())
      bridge.addHeuristic(key: "GPS", getter: XyoGps())
      
      if try bridge.originState.getIndex().getValueCopy().getUInt32(offset: 0) == 0 {
        try bridge.selfSignOriginChain()
      }
      
    } catch {
      // move this into the core
      fatalError()
    }
    
  }
  
  var primaryPublicKeyAsString: String? {
    return self.getPrimaryPublicKey()?.getBuffer().toByteArray().toBase58String()
  }
  
  public func getPrimaryPublicKey () -> XyoObjectStructure? {
    return self.bridge.originState.getSigners().first?.getPublicKey()
  }
  
  public func setPaymentKey (key: [UInt8]) {
    let encodedKey = XyoObjectStructure.newInstance(schema: XyoSchemas.PAYMENT_KEY, bytes: XyoBuffer(data: key))
    
    self.bridge.originState.repo.setStaticHeuristics(heuristics: [encodedKey])
    self.stateRepo.commit()
  }
  
  public func getPaymentKey () -> [UInt8]? {
    do {
      let huerestics = self.stateRepo.getStaticHeuristics()
      
      for huerestic in huerestics {
        if try huerestic.getSchema().id == XyoSchemas.PAYMENT_KEY.id {
          return try huerestic.getValueCopy().toByteArray()
        }
      }
      
      return nil
    } catch {
      return nil
    }
  }
  
  private func getSignerFromStorage () -> XyoSigner {
    do {
      guard let signer = try storage.read(key: BridgeManager.signerKey) else {
        let key = XyoSecp256k1Signer()
        _ = savePrivateKey(key: key)
        return key
      }
      
      return XyoSecp256k1Signer(privateKeyNum: signer)
    } catch {
      let key = XyoSecp256k1Signer()
      _ = savePrivateKey(key: key)
      return key
    }
  }
  
  private func savePrivateKey (key: XyoSecp256k1Signer) -> Bool {
    do {
      try storage.write(key: BridgeManager.signerKey, value: (try key.getPrivateKey().getValueCopy().toByteArray()))
      return true
    } catch {
      return false
    }
  }
}

protocol XYOriginBlockListenerDelegate {
  func updated(blocks: [InteractionModel], lastBoundWitnessTime: String)
}

final public class XYOriginBlockListener {
  
  let boundWitnessHandler = BoundWitnessEventChannel()
  
  private let accessQueue = DispatchQueue(label: "com.xyonetwork.OriginBlockQueue", attributes: .concurrent)
  
  fileprivate lazy var delegates: [String: XYOriginBlockListenerDelegate] = [:]
  
  fileprivate var blocks: [InteractionModel] = [] {
    didSet {
      self.report()
    }
  }
  
  fileprivate lazy var lastBoundWitnessTime: String = ""
  
  func listen(key: String, delegate: XYOriginBlockListenerDelegate) {
    self.accessQueue.sync {
      self.process()
      self.delegates[key] = delegate
    }
  }
  
  func listen() {
    self.accessQueue.sync {
      self.process()
    }
  }
  
  func report() {
    self.boundWitnessHandler.sendMessage(blocks)
  }
  
  func startReporting() {
    BridgeManager.instance.bridge.addListener(key: "[DBG: \(#function)]: \(Unmanaged.passUnretained(self).toOpaque())", listener: self)
    listen()
  }
  
  public func clearListeners() {
    self.accessQueue.async(flags: .barrier) {
      self.delegates.removeAll()
    }
  }
  
  private func getLastBoundWitnessTime () -> String {
    guard let lastBoundWitnessTime = BridgeManager.instance.bridge.repositoryConfiguration.originState.lastBoundWitnessTime() else {
      return "Unknown"
    }
    
    let time = TimeInterval(Double(lastBoundWitnessTime))
    let date = Date(timeIntervalSince1970: time)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
    
    return dateFormatter.string(from: date)
  }
  
  private func process() {
    self.accessQueue.async(flags: .barrier) {
      do {
        var viewModels = [InteractionModel]()
        let hashes = try (BridgeManager.instance.bridge.repositoryConfiguration.originBlock as! XyoStorageProviderOriginBlockRepository)
          .getAllOriginBlockHashes().getNewIterator()
        
        while try hashes.hasNext() {
          let hash = try hashes.next()
          let hashString = hash.getBuffer().toByteArray()
          let date = Date() // todo, presist the date of a block withought reading its value
          viewModels.append(InteractionModel(hashString, date: date))
        }
        
        self.blocks = viewModels.reversed()
        self.lastBoundWitnessTime = self.getLastBoundWitnessTime()
      } catch {
        // todo handle error
      }
    }
  }
  
}

extension XYOriginBlockListener: XyoNodeListener {
  public func onBoundWitnessStart() {}
  public func onBoundWitnessEndFailure() {}
  public func onBoundWitnessDiscovered(boundWitness: XyoBoundWitness) {}
  public func onBoundWitnessEndSuccess(boundWitness: XyoBoundWitness) {
    self.process()
  }
}
