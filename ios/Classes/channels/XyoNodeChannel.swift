//
//  XyoNodeChannel.swift
//  sdk-xyo-flutter
//

import Flutter
import sdk_xyo_swift
import sdk_core_swift
import sdk_objectmodel_swift

internal class XyoNodeChannel: NSObject, FlutterPlugin {
  static func register(with registrar: FlutterPluginRegistrar) {
      //we do nothing here since this is only so that the addMethodCallDelegate will be ok with it
  }
  
  var _registrar: FlutterPluginRegistrar
  var _xyoNode : XyoNode?
  var _blockRepository: XyoOriginBlockRepository?
  var _hasher: XyoHasher?
  var _builder: XyoNodeBuilder? = XyoNodeBuilder()
  var _delegateRetention = [BoundWitnessDelegate]()
  
  public var payloadString: [UInt8]?
  
  init(registrar: FlutterPluginRegistrar) {
    _registrar = registrar
    let channel = FlutterMethodChannel(name:"xyoNode", binaryMessenger: registrar.messenger())
    super.init()
    registrar.addMethodCallDelegate(self, channel: channel)
  }

  func setupDelegates() {
    guard let networks = _xyoNode?.networks else {
      print("No node or no networks")
      return
    }
    _delegateRetention.removeAll()

    for (key, _) in networks {
      let clientName = "xyoNode" + key + "Client"
      let serverName = "xyoNode" + key + "Server"
      let cli = XyoNodeEventChannel(channelPrefix: clientName, with: _registrar, with: _hasher!)
      let ser = XyoNodeEventChannel(channelPrefix: serverName, with: _registrar, with: _hasher!)
      networks[key]?.client?.delegate = cli
      networks[key]?.server?.delegate = ser
      _delegateRetention.append(contentsOf: [cli, ser])
    }

  }
  deinit {
    _delegateRetention.removeAll()
  }
  
  func build() -> String {
    do {
      _xyoNode = try _builder?.build()
      _blockRepository = _builder?.blockRepository
      _hasher = _builder?.hashingProvider
      setupDelegates()
      _builder = nil
    }
    catch {
      print("Caught Error Building Xyo Node\(error)")
    }
    return("Built")
  }
  
  func setListening(on: Bool) {
    let ble = _xyoNode?.networks["ble"] as? XyoBleNetwork
    ble?.server?.listen = on

  }

  func setScanning(on: Bool) {
    let ble = _xyoNode?.networks["ble"] as? XyoBleNetwork
    ble?.client?.scan = on

  }
  
  func setBridging(isClient: Bool, on: Bool) {
    let tcp = _xyoNode?.networks["tcpip"] as? XyoTcpipNetwork
    if isClient {
      tcp?.client?.autoBridge = on
    } else {
      tcp?.server?.autoBridge = on
    }
  }
  
  func setHeuristicString(isClient: Bool, payload: String) {
    let ble = _xyoNode?.networks["ble"] as? XyoBleNetwork
    if isClient {
      ble?.client?.stringHeuristic = payload
    } else {
      ble?.server?.stringHeuristic = payload
    }
  }
  
  var client : XyoClient? {
    get {
      if let ble = _xyoNode?.networks["ble"] as? XyoBleNetwork {
        return ble.client
      }
      return nil
    }
  }
  
  var server : XyoServer? {
    get {
      if let ble = _xyoNode?.networks["ble"] as? XyoBleNetwork {
        return ble.server
      }
      return nil
    }
  }
  
  func getOriginBlock(fromHash: [UInt8]) -> XyoBoundWitness? {
    guard let repo = _blockRepository else {
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
  enum MethodRegistry: String {
      case
      build,
      setPollingInterval,
      setPayloadData,
      setBridging,
      setListening,
      setScanning,
      setArchivists,
      getPublicKey
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let method = MethodRegistry(rawValue: call.method) else {
      result(nil)
      return
    }
    let arguments = call.arguments;
    switch method {
      case .build:
        result(self.build())
        break
    case .getPublicKey:
      let isClient = arguments as! Bool
      result(self.getPublicKey(isClient: isClient))
      break
    case .setBridging:
      let args = arguments as! [Any]

      self.setBridging(isClient: args[0] as! Bool,on: args[1] as! Bool)
      result(true)
      break
    case .setScanning:
      self.setScanning(on: arguments as! Bool)
      result(true)
      break
    case .setPayloadData:
      let args = arguments as! [Any]
      let isClient = args[0] as! Bool
      let payload = args[1] as! String
      self.setHeuristicString(isClient: isClient, payload: payload)
      break

    case .setListening:
      self.setListening(on: arguments as! Bool)
      result(true)
      break
      default:
        break
    }
  }
}



