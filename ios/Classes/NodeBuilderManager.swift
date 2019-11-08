//
//  NodeBuilderManager.swift
//  sdk-xyo-flutter
//
import sdk_xyo_swift
import sdk_core_swift
import sdk_objectmodel_swift

internal class NodeBuilderManager: NSObject {
  var xyoNode : XyoNode?
  var blockRepository: XyoOriginBlockRepository?
  var hasher: XyoHasher?
  var builder: XyoNodeBuilder? = XyoNodeBuilder()
  public static let instance = NodeBuilderManager()
  var _eventSink: FlutterEventSink?
  public var payloadData: [UInt8]?
  
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
    // stop server listening if listening on
    if on && ble?.client?.scan == true {
      ble?.client?.scan = false
    }
  }

  func setScanning(on: Bool) {
    let ble = xyoNode?.networks["ble"] as? XyoBleNetwork
    ble?.client?.scan = on
    // stop server listening if you want to start scanning as client
    if on && ble?.server?.listen == true {
      ble?.server?.listen = false
    }
  }
  
  func setBridging(on: Bool) {
    let ble = xyoNode?.networks["ble"] as? XyoBleNetwork

    let tcp = xyoNode?.networks["tcpip"] as? XyoTcpipNetwork

    if ble?.client?.scan == true {
      tcp?.client?.autoBridge = on
    } else {
      tcp?.server?.autoBridge = on
    }
  }
  
  func getClient() -> XyoClient? {
    if let ble = xyoNode?.networks["ble"] as? XyoBleNetwork {
      return ble.client
    }
    return nil
  }
  func getOriginBlock(fromHash: [UInt8]) -> XyoBoundWitness? {
    guard let repo = blockRepository else {
      return nil
    }
    
    return try! repo.getOriginBlock(originBlockHash:fromHash)
  }
  
  func getPublicKey() -> String? {
    if let client = getClient() {
      if let pKey = client.publicKey() {
        return pKey
      }
    }
    return nil
  }
}


extension NodeBuilderManager : FlutterStreamHandler {
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
       _eventSink = events
       return nil
   }

   public func onCancel(withArguments arguments: Any?) -> FlutterError? {
       _eventSink = nil
       return nil
   }
  
//  private func buildMessage(_ boundWitnessList: DeviceBoundWitnessList) -> Data? {
//      do {
//          return try boundWitnessList.serializedData()
//      } catch {
//          return nil
//      }
//  }
//
//  func sendMessage(_ boundWitnesses: [InteractionModel]) {
//      let boundWitnessList = DeviceBoundWitnessList.with {
//          $0.boundWitnesses = boundWitnesses.map { witness in witness.toBuffer }
//      }
//
//      _eventSink?(self.buildMessage(boundWitnessList))
//  }
}

extension NodeBuilderManager : BoundWitnessDelegate {
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
//      if let bw = withBoundWitness.toBuffer() {
//
//      }
      do {
        if try bw.getNewIterator().hasNext() {
          let boundWitness = hashToBoundWitnesses(hash: try! bw.getHash(hasher: hasher!))
          try! _eventSink?(boundWitness.serializedData())

        }
      } catch {
        print("Error thrown")
      }
      
      
    }

  }
  
  func boundWitness(failed withDeviceId: String?, withError: XyoError) {
    print("Errored BW with \(String(describing: withDeviceId)) \(String(describing: withError))")
  }
  
  func getPayloadData() -> [UInt8]? {
    //TODO 
    return payloadData
  }
}
