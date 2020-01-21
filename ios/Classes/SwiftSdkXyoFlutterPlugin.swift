import Flutter
import sdk_xyo_swift

public class SwiftSdkXyoFlutterPlugin: NSObject, FlutterPlugin {
  static var instance: SwiftSdkXyoFlutterPlugin?
  
  let client : XyoBleClientChannel;
  let server : XyoBleServerChannel;
  let deviceChannel : XyoDeviceChannel;

  init(with registrar: FlutterPluginRegistrar) {
    deviceChannel = XyoDeviceChannel(registrar: registrar)
    client = XyoBleClientChannel(registrar: registrar)
    server = XyoBleServerChannel(registrar: registrar)

    super.init()
  }
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    instance = SwiftSdkXyoFlutterPlugin(with: registrar)
  }
}
