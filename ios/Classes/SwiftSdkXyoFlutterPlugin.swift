import Flutter
import sdk_xyo_swift



public class SwiftSdkXyoFlutterPlugin: NSObject, FlutterPlugin {
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
  static var scanner : SmartScanWrapper?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "xyo_node_methods", binaryMessenger: registrar.messenger())
    let instance = SwiftSdkXyoFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let boundWitnessChannel = FlutterEventChannel(name: "xyo_bw_success_channel", binaryMessenger: registrar.messenger())
    boundWitnessChannel.setStreamHandler(XyoNodeWrapper.instance)
    
    scanner = SmartScanWrapper(with: registrar)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let method = MethodRegistry(rawValue: call.method) else {
      result(nil)
      return
    }
    let arguments = call.arguments;
    switch method {
      case .build:
        result(XyoNodeWrapper.instance.build())
        break
    case .getPublicKey:
      let isClient = arguments as! Bool
      result(XyoNodeWrapper.instance.getPublicKey(isClient: isClient))
      break
    case .setBridging:
      let args = arguments as! [Any]

      XyoNodeWrapper.instance.setBridging(isClient: args[0] as! Bool,on: args[1] as! Bool)
      result(true)
      break
    case .setScanning:
      XyoNodeWrapper.instance.setScanning(on: arguments as! Bool)
      result(true)
      break
    case .setPayloadData:
      let args = arguments as! [Any]
      let isClient = args[0] as! Bool
      let payload = args[1] as! String
      XyoNodeWrapper.instance.setHeuristicString(isClient: isClient, payload: payload)
      break

    case .setListening:
      XyoNodeWrapper.instance.setListening(on: arguments as! Bool)
      result(true)
      break
      default:
        break
    }
  }


 
}
