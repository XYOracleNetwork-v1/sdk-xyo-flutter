//
//  XyoScannerWrapper.swift
//  Pods
//
//  Created by Kevin Weiler on 11/13/19.
//

import Flutter
import XyBleSdk
import CoreBluetooth
import sdk_xyobleinterface_swift
import sdk_core_swift

extension XYBluetoothDevice {
    var toBuffer: BluetoothDevice {
        return BluetoothDevice.with {
            $0.id = self.id
            $0.family = self.family.toBuffer
            $0.connected = self.connected
            $0.rssi = Int64(self.rssi)
            if let beacon = self.iBeacon?.toBuffer {
                $0.beacon = beacon
            }
        }
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
internal class XyoScannerWrapper: NSObject, FlutterStreamHandler {

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

  fileprivate let smartScan = XYSmartScan.instance

  let deviceDetected = XyoScannerWrapper()
  let deviceExited = XyoScannerWrapper()

  init(with registrar: FlutterPluginRegistrar) {
    let entered = FlutterEventChannel(name: "xyo_device_detected_channel", binaryMessenger: registrar.messenger())
    entered.setStreamHandler(deviceDetected)
    
    let exited = FlutterEventChannel(name: "xyo_device_exited_channel", binaryMessenger: registrar.messenger())
    exited.setStreamHandler(deviceExited)
    
    smartScan.setDelegate(self, key: "xyo_smart_scan_wrapper")
    XyoBluetoothDeviceCreator.enable(enable: true)
    XyoBluetoothDevice.family.enable(enable: true)
    XyoSentinelXDeviceCreator().enable(enable: true)
    smartScan.start(mode: XYSmartScanMode.foreground)
  }
  
  deinit {
    smartScan.removeDelegate(for: "xyo_smart_scan_wrapper")
  }
}



extension SmartScanWrapper: XYSmartScanDelegate {

  func smartScan(status: XYSmartScanStatus) {}
  func smartScan(location: XYLocationCoordinate2D) {}
  func smartScan(detected devices: [XYBluetoothDevice], family: XYDeviceFamily) {}
  func smartScan(entered device: XYBluetoothDevice) {}
  func smartScan(exiting device: XYBluetoothDevice) {}
  
  func smartScan(detected device: XYBluetoothDevice, rssi: Int, family: XYDeviceFamily) {
    self.deviceDetected.sendMessage(device)
  }

  func smartScan(exited device: XYBluetoothDevice) {
    self.deviceExited.sendMessage(device)
  }

}
