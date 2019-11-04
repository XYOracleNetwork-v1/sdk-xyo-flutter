import Flutter
import XyBleSdk
import CoreBluetooth
import sdk_xyobleinterface_swift
import sdk_core_swift

extension XYBluetoothDevice {
  
  func getNameFromType() -> String {
    var name = self.name
    if (self is XyoSentinelXDevice) {
      name = "SenX"
    } else if (self is XyoBridgeXDevice) {
      name = "BridgeX"
    } else if (self is XyoIosXDevice) {
      name = "IosAppX"
    } else if (self is XyoAndroidXDevice) {
      name = "AndroidAppX"
    }
    return name
  }

    var toBuffer: BluetoothDevice {
        var result = BluetoothDevice.with {
            $0.id = self.id
            $0.name = getNameFromType()
            $0.family = self.family.toBuffer
            $0.connected = self.connected
            $0.rssi = Int64(self.rssi)
            if let beacon = self.iBeacon?.toBuffer {
                $0.beacon = beacon
            }
        }
      result.family.name = result.name
      return result
    }

}

extension XYDeviceFamily {

    var toBuffer: Family {
        return Family.with {
            $0.id = self.id
            $0.name = self.familyName
            $0.prefix = self.prefix
            $0.uuid = self.uuid.uuidString
        }
    }
}

extension XYIBeaconDefinition {

    var toBuffer: IBeacon {
        return IBeacon.with {
            $0.uuid = self.uuid.uuidString
            $0.major = Int64(self.major ?? 0)
            $0.minor = Int64(self.minor ?? 0)
        }
    }

}

// Wraps up the event listener and the event sink, used by the wrapper below
internal class ScannerEventChannel: NSObject, FlutterStreamHandler {

    var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    private func buildMessage(_ device: XYBluetoothDevice) -> Data? {
        do {
            return try device.toBuffer.serializedData()
        } catch {
            return nil
        }
    }

    func sendMessage(_ device: XYBluetoothDevice) {
        self.eventSink?(self.buildMessage(device))
    }
}

// Wraps the smart scan/central calls, handles the delegate methods and reports updates to the event channel
internal class SmartScanWrapper {

    fileprivate(set) var xyFinderFamilyFilter: [XYDeviceFamily]

    fileprivate let smartScan = XYSmartScan.instance

    let scannerHandler = ScannerEventChannel()

    init() {

        // Setup devices to listen for (SentinelX)
        XyoBluetoothDeviceCreator.enable(enable: true)
        XyoBluetoothDevice.family.enable(enable: true)

        XyoSentinelXDeviceCreator().enable(enable: true)

        self.xyFinderFamilyFilter = XYDeviceFamily.allFamlies()

        self.setup()
    }

    func setup() {
        self.smartScan.setDelegate(self, key: "SmartScanWrapper")
      self.smartScan.start(mode: XYSmartScanMode.foreground)
    }

}

extension SmartScanWrapper: XYSmartScanDelegate {

    func smartScan(status: XYSmartScanStatus) {}
    func smartScan(location: XYLocationCoordinate2D) {}

    func smartScan(detected device: XYBluetoothDevice, rssi: Int, family: XYDeviceFamily) {
        self.scannerHandler.sendMessage(device)
    }

    func smartScan(detected devices: [XYBluetoothDevice], family: XYDeviceFamily) {}
    func smartScan(entered device: XYBluetoothDevice) {}
    func smartScan(exiting device: XYBluetoothDevice) {}
    func smartScan(exited device: XYBluetoothDevice) {}

}
