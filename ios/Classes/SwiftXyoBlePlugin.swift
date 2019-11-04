import Flutter
import UIKit
import XyBleSdk

// Top level plugin class, registers the various methods and events
public class SwiftXyoBlePlugin: NSObject, FlutterPlugin {

    // Each method we support on the method channel
    enum MethodRegistry: String {
        case
        gattSingle,
        gattGroup,
        gattList,
        startBoundWitness,
        stopBoundWitness,
        addDeviceStartListening,
        addDeviceStopListening,
        setArchivists,
        getDevicePublicKey
    }

    fileprivate static let scannerWrapper = SmartScanWrapper()
    fileprivate static let boundWitnesses = XYOriginBlockListener()
    fileprivate static let addDevice = AddDeviceListener()
  
  fileprivate static var sentinel:XyoSentinelChannel?
  fileprivate static var bridge:XyoBridgeChannel?
  fileprivate static var device:XyoDeviceChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
      sentinel = XyoSentinelChannel(registrar: registrar, name: "network.xyo/sentinel")
      bridge = XyoBridgeChannel(registrar: registrar, name: "network.xyo/bridge")
      device = XyoDeviceChannel(registrar: registrar, name: "network.xyo/device")
      
      /*
      // Scanner event channel for getting devices, uses the smart scan wrapper
        let scannerChannel = FlutterEventChannel(name: "network.xyo/smartscan", binaryMessenger: registrar.messenger())
        scannerChannel.setStreamHandler(self.scannerWrapper.scannerHandler)

        // Bound Witness channel
        let boundWitnessChannel = FlutterEventChannel(name: "network.xyo/boundwitness", binaryMessenger: registrar.messenger())
        boundWitnessChannel.setStreamHandler(self.boundWitnesses.boundWitnessHandler)

        // Add Device Channel
        let addDeviceChannel = FlutterEventChannel(name: "network.xyo/add_device", binaryMessenger: registrar.messenger())
        addDeviceChannel.setStreamHandler(self.addDevice.addDeviceHandler)

        // Set up the method channel listener
        let gattChannel = FlutterMethodChannel(name: "network.xyo/sdk", binaryMessenger: registrar.messenger())
        let gattInstance = SwiftXyoBlePlugin()
        registrar.addMethodCallDelegate(gattInstance, channel: gattChannel)*/

        // Setup the bluetooth manager
        //XYBluetoothManager.setup()
    }

    // Main control of any method requests on this channel, farmed out to sub methods
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = MethodRegistry(rawValue: call.method) else {
            result(nil)
            return
        }

        switch method {
        case .gattSingle:
            GattSingleRequest.process(arguments: call.arguments, result: result)
        case .gattGroup:
            GattGroupRequest.process(arguments: call.arguments, result: result)
        case .gattList:
            GattListRequest.process(arguments: call.arguments, result: result)
        case .startBoundWitness:
            XYBluetoothManager.start()
            SwiftXyoBlePlugin.boundWitnesses.startReporting()
            result(true)
        case .stopBoundWitness:
            XYBluetoothManager.stop()
            result(true)
        case .addDeviceStartListening:
            SwiftXyoBlePlugin.addDevice.startListening()
            result(true)
        case .addDeviceStopListening:
            SwiftXyoBlePlugin.addDevice.doneListening()
            result(true)
        case .setArchivists:
            XYBluetoothManager.addArchivists(archivists: call.arguments)
            result(true)
        case .getDevicePublicKey:
            result(BridgeManager.instance.primaryPublicKeyAsString)
        }
    }

}
