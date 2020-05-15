//
//  XyoDeviceChannel.swift
//  Pods
//
//  Created by Kevin Weiler on 11/13/19.
//

import Flutter
import XyBleSdk
import CoreBluetooth
import sdk_core_swift
import sdk_xyo_swift

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

// Wraps the smart scan/central calls, handles the delegate methods and reports updates to the event channel
internal class XyoDeviceChannel: NSObject, FlutterPlugin  {
  static func register(with registrar: FlutterPluginRegistrar) {
    //we do nothing here since this is only so that the addMethodCallDelegate will be ok with it
  }

  fileprivate let smartScan = XYSmartScan.instance
  let deviceDetected = XyoNodeStreamHandler()
  let deviceExited = XyoNodeStreamHandler()
  let statusChanged = XyoNodeStreamHandler()

  init(registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "xyoDevice", binaryMessenger: registrar.messenger())

    let entered = FlutterEventChannel(name: "xyoDeviceOnDetect", binaryMessenger: registrar.messenger())
    entered.setStreamHandler(deviceDetected)
    
    let exited = FlutterEventChannel(name: "xyoDeviceOnExit", binaryMessenger: registrar.messenger())
    exited.setStreamHandler(deviceExited)

    let onStatusChanged = FlutterEventChannel(name: "xyoOnStatusChanged", binaryMessenger: registrar.messenger())
    onStatusChanged.setStreamHandler(statusChanged)
    
    XyoBluetoothDeviceCreator.enable(enable: true)
    XyoBluetoothDevice.family.enable(enable: true)
    XyoSentinelXDeviceCreator().enable(enable: true)
    
    super.init()
    registrar.addMethodCallDelegate(self, channel: channel)
    smartScan.setDelegate(self, key: "xyo_smart_scan_wrapper")
  }
  
  deinit {
    smartScan.removeDelegate(for: "xyo_smart_scan_wrapper")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "setDeviceListening") {
      if (call.arguments as! Bool == true) {
        smartScan.start(mode: XYSmartScanMode.foreground)
      } else {
        smartScan.stop()
      }
    }

  }

}

extension XyoDeviceChannel: XYSmartScanDelegate {

  func smartScan(status: XYSmartScanStatus) {

    if let sink = statusChanged.eventSink {
      sink(status)
    }
  }

  func smartScan(location: XYLocationCoordinate2D) {}
  func smartScan(detected devices: [XYBluetoothDevice], family: XYDeviceFamily) {}
  func smartScan(entered device: XYBluetoothDevice) {}
  func smartScan(exiting device: XYBluetoothDevice) {}
  
  func smartScan(detected device: XYBluetoothDevice, rssi: Int, family: XYDeviceFamily) {
    if let sink = deviceDetected.eventSink {
      try? sink(device.toBuffer.serializedData())
    }
  }

  func smartScan(exited device: XYBluetoothDevice) {
    if let sink = deviceExited.eventSink {
      try? sink(device.toBuffer.serializedData())
    }
    
  }

}
