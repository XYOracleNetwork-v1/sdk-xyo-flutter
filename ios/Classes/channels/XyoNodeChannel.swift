//
//  XyoNodeChannel.swift
//  sdk-xyo-flutter
//

import Flutter
import sdk_xyo_swift
import sdk_core_swift


internal class XyoNodeInstance {
  static let instance  = XyoNodeInstance()
  
  var blockRepository: XyoOriginBlockRepository
  var hasher: XyoHasher
  var node : XyoNode;
  
  private init() {
    let builder = XyoNodeBuilder();
    try! node = builder.build()
    blockRepository = builder.blockRepository!
    hasher = builder.hashingProvider!
  }

}
enum MethodRegistry: String {
    case
    build,
    setPollingInterval,
    setPayloadData,
    setBridging,
    setListening,
    setScanning,
    getPublicKey
}

internal class XyoBleClientChannel : XyoNodeChannel {
  var name = "xyoClient"
  init(registrar: FlutterPluginRegistrar) {
    super.init(registrar: registrar, name:name)
  }
  
  override func getPublicKey() -> String? {
    return XyoNodeInstance.instance.node.networks["ble"]?.client?.publicKey()
  }
  override func setBridging( on: Bool) {
    XyoNodeInstance.instance.node.networks["ble"]?.client?.autoBridge = on
  }
  override func setHeuristicString(payload: String) {
    XyoNodeInstance.instance.node.networks["ble"]?.client?.stringHeuristic = payload
  }
  override func setupDelegates() -> Bool {
    let networks = XyoNodeInstance.instance.node.networks
     _delegateRetention.removeAll()
    let cli = XyoNodeEventChannel(channelPrefix: name, with: _registrar, with: XyoNodeInstance.instance.hasher)
    networks["ble"]?.client?.delegate = cli
    _delegateRetention.append(contentsOf: [cli])
    return true
   }
}

internal class XyoBleServerChannel : XyoNodeChannel {
  var name = "xyoServer"
  init(registrar: FlutterPluginRegistrar) {
    super.init(registrar: registrar, name:name)
  }
  
  override func getPublicKey() -> String? {
    return XyoNodeInstance.instance.node.networks["ble"]?.server?.publicKey()
  }
  override func setBridging( on: Bool) {
    if (XyoNodeInstance.instance.node.networks["ble"]?.server?.autoBridge != on) {
      XyoNodeInstance.instance.node.networks["ble"]?.server?.autoBridge = on
    }
  }
  override func setHeuristicString(payload: String) {
    if (XyoNodeInstance.instance.node.networks["ble"]?.server?.stringHeuristic != payload) {
        XyoNodeInstance.instance.node.networks["ble"]?.server?.stringHeuristic = payload
    }
  }
  override func setupDelegates() -> Bool {
    let networks = XyoNodeInstance.instance.node.networks
    
     _delegateRetention.removeAll()
    let serv = XyoNodeEventChannel(channelPrefix: name, with: _registrar, with: XyoNodeInstance.instance.hasher)
    networks["ble"]?.server?.delegate = serv
    _delegateRetention.append(contentsOf: [serv])
    return true
   }
}


class XyoNodeChannel: NSObject, FlutterPlugin {
  static func register(with registrar: FlutterPluginRegistrar) {
      //we do nothing here since this is only so that the addMethodCallDelegate will be ok with it
  }
  
  var _registrar: FlutterPluginRegistrar
  var _builder: XyoNodeBuilder? = XyoNodeBuilder()
  var _delegateRetention = [BoundWitnessDelegate]()
  
  public var payloadString: [UInt8]?
  
  init(registrar: FlutterPluginRegistrar, name: String) {
    _registrar = registrar
    let channel = FlutterMethodChannel(name:name, binaryMessenger: registrar.messenger())
    super.init()
    registrar.addMethodCallDelegate(self, channel: channel)
  }

  func setupDelegates() -> Bool {
    // Override
    return false
  }
  func getPublicKey() -> String? {
    // Override
    return nil
  }

  deinit {
    _delegateRetention.removeAll()
  }
  
  func build() -> String? {
    if (setupDelegates()) {
      return "success"
    }
    return nil
  }
  
  func setScanning(on: Bool) {
    if (XyoNodeInstance.instance.node.networks["ble"]?.client?.scan != on) {
      XyoNodeInstance.instance.node.networks["ble"]?.client?.scan = on
    }
  }
  func setListening(on: Bool) {
    if (XyoNodeInstance.instance.node.networks["ble"]?.server?.listen != on) {
      XyoNodeInstance.instance.node.networks["ble"]?.server?.listen = on
    }
  }

  func setBridging( on: Bool) {
    // Override
  }
  
  func setHeuristicString(payload: String) {
    //Override
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
        result(self.getPublicKey())
        break
    case .setBridging:
      let bridging = arguments as! Bool
      self.setBridging(on: bridging)
      result(true)
      break
    case .setScanning:
      self.setScanning(on: arguments as! Bool)
      result(true)
      break
    case .setPayloadData:
      let payload = arguments as! String
      self.setHeuristicString(payload: payload)
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



