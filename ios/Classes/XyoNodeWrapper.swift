//
//  XyoNodeWrapper.swift
//  sdk-xyo-flutter
//
import sdk_xyo_swift
import sdk_core_swift
import sdk_objectmodel_swift

internal class XyoNodeWrapper: NSObject {
  public static let instance = XyoNodeWrapper()

  var xyoNode : XyoNode?
  var blockRepository: XyoOriginBlockRepository?
  var hasher: XyoHasher?
  var builder: XyoNodeBuilder? = XyoNodeBuilder()
  var _completedBWSink: FlutterEventSink?
  public var payloadString: [UInt8]?
  
  override init() {
    super.init()
    builder?.setBoundWitnessDelegate(self)
  }

  func build() -> String {
    do {
      xyoNode = try builder?.build()
      blockRepository = builder?.blockRepository
      hasher = builder?.hashingProvider
      builder = nil
    }
    catch {
      print("Caught Error Building Xyo Node\(error)")
    }
    return("Built")
  }
  
  func setListening(on: Bool) {
    let ble = xyoNode?.networks["ble"] as? XyoBleNetwork
    ble?.server?.listen = on

  }

  func setScanning(on: Bool) {
    let ble = xyoNode?.networks["ble"] as? XyoBleNetwork
    ble?.client?.scan = on

  }
  
  func setBridging(isClient: Bool, on: Bool) {
    let tcp = xyoNode?.networks["tcpip"] as? XyoTcpipNetwork
    if isClient {
      tcp?.client?.autoBridge = on
    } else {
      tcp?.server?.autoBridge = on
    }
  }
  
  func setHeuristicString(isClient: Bool, payload: String) {
    let ble = xyoNode?.networks["ble"] as? XyoBleNetwork
    if isClient {
      ble?.client?.stringHeuristic = payload
    } else {
      ble?.server?.stringHeuristic = payload
    }
  }
  
  var client : XyoClient? {
    get {
      if let ble = xyoNode?.networks["ble"] as? XyoBleNetwork {
        return ble.client
      }
      return nil
    }
  }
  
  var server : XyoServer? {
    get {
      if let ble = xyoNode?.networks["ble"] as? XyoBleNetwork {
        return ble.server
      }
      return nil
    }
  }
  
  func getOriginBlock(fromHash: [UInt8]) -> XyoBoundWitness? {
    guard let repo = blockRepository else {
      return nil
    }
    
    return try! repo.getOriginBlock(originBlockHash:fromHash)
  }
  
  func getPublicKey(isClient : Bool) -> String? {
    if let target = isClient ? client : server {
      if let pKey = target.publicKey() {
        return pKey
      }
    }
    return nil
  }
}


extension XyoNodeWrapper : FlutterStreamHandler {
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
       _completedBWSink = events
       return nil
   }

   public func onCancel(withArguments arguments: Any?) -> FlutterError? {
       _completedBWSink = nil
       return nil
   }
}

extension XyoNodeWrapper : BoundWitnessDelegate {
  private func hashToBoundWitnesses(hash: XyoObjectStructure) -> DeviceBoundWitness {
    let model = InteractionModel(hash.getBuffer().toByteArray(), date: Date(), linked: true)
    return model.toBuffer
  }
  
  func boundWitness(started withDeviceId: String) {
    print("Started BW with \(withDeviceId)")
  }
  
  func boundWitness(completed withDeviceId: String, withBoundWitness: XyoBoundWitness?) {
    print("Completed BW with \(withDeviceId)")
    
    if let bw = withBoundWitness {
      do {
        if try bw.getNewIterator().hasNext() {
          if let her = hasher, let sink = _completedBWSink {
            let hash = try bw.getHash(hasher: her)
            let boundWitness = hashToBoundWitnesses(hash: hash)
            try sink(boundWitness.serializedData())
          }
        }
      } catch {
        print("Error thrown \(error)")
      }
    }
  }
  
  func boundWitness(failed withDeviceId: String?, withError: XyoError) {
    print("Errored BW with \(String(describing: withDeviceId)) \(String(describing: withError))")
  }
  

}
