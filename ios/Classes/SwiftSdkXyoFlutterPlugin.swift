import Flutter
import UIKit

public class SwiftSdkXyoFlutterPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  enum MethodRegistry: String {
        case
        build,
        setPollingInterval,
        setPayloadData,
        setBridging,
        setListening,
        setScanning,
        setArchivists,
        getDevicePublicKey
    }
  
  var _eventSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "sdk_xyo_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftSdkXyoFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let method = MethodRegistry(rawValue: call.method) else {
      result(nil)
      return
    }
    switch method {
      case .build:
        result(NodeBuilderManager.instance.build())
        break;
      default:
        break;
    }
  }


  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
      _eventSink = events
      return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
      _eventSink = nil
      return nil
  }
}
