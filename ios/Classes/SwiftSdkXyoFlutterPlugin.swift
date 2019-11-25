import Flutter
import sdk_xyo_swift

public class SwiftSdkXyoFlutterPlugin: NSObject, FlutterPlugin {
  static var instance: SwiftSdkXyoFlutterPlugin?
  
  let nodeChannel : XyoNodeChannel;
  let deviceChannel : XyoDeviceChannel;

  init(with registrar: FlutterPluginRegistrar) {
    deviceChannel = XyoDeviceChannel(registrar: registrar)
    nodeChannel = XyoNodeChannel(registrar: registrar)

    super.init()
  }
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    instance = SwiftSdkXyoFlutterPlugin(with: registrar)
  }
}
