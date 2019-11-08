import Flutter
import UIKit
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
  

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "sdk_xyo_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftSdkXyoFlutterPlugin()
    let boundWitnessChannel = FlutterEventChannel(name: "sdk_xyo_flutter_events", binaryMessenger: registrar.messenger())
    boundWitnessChannel.setStreamHandler(NodeBuilderManager.instance)

    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let method = MethodRegistry(rawValue: call.method) else {
      result(nil)
      return
    }
    let arguments = call.arguments;
    switch method {
      case .build:
        result(NodeBuilderManager.instance.build())
        break
    case .getPublicKey:
        result(NodeBuilderManager.instance.getPublicKey())
        break
    case .setBridging:
        NodeBuilderManager.instance.setBridging(on: arguments as! Bool)
        result(true)
        break
    case .setScanning:
        NodeBuilderManager.instance.setScanning(on: arguments as! Bool)
        result(true)
      break
    case .setPayloadData:
      let args = arguments as! String
      NodeBuilderManager.instance.payloadData = [UInt8](args.utf8)
      break
      //    case .getPayloadData:
//    let data = NodeBuilderManager.instance.getPayloadData(data: arguments as! String)
//    result(data)
//      break
    case .setListening:
        NodeBuilderManager.instance.setListening(on: arguments as! Bool)
        result(true)
      break
      default:
        break
    }
  }


 
}
