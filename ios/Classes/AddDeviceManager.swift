//
//  OtaManager.swift
//  xyo_ble
//
//  Created by Darren Sutherland on 7/12/19.
//

import sdk_xyobleinterface_swift
import sdk_core_swift
import sdk_objectmodel_swift
import XyBleSdk

internal class AddDeviceEventChannel: NSObject, FlutterStreamHandler {

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

final class AddDeviceListener {

    fileprivate var xy4Device: XYFinderDevice?
    fileprivate var xyoDevice: XyoSentinelXDevice?

    // The default password for any unclaimed device
    static let defaultPassword: [UInt8] = [0, 0, 0, 0]

    let addDeviceHandler = AddDeviceEventChannel()

    func startListening() {
        // No listening for XY4 since we aren't doing the firmware upgrade at this time
//        XYBluetoothManager.listenForXy4 { [weak self] device in
//            self?.xy4Device = device as? XYFinderDevice
//            if let xy4Device = self?.xy4Device {
//                self?.addDeviceHandler.sendMessage(xy4Device)
//            }
//        }

        // Trigger the Sentinel flow if a button is pressed
        XyoSentinelXManager.addListener(key: "XYAddOwnershipViewCoordinator") { [weak self] device, _ in

            if device.id == "xy:ibeacon:d684352e-df36-484e-bc98-2d5398c5593e.54849.44291" ||
                device.id == "xy:ibeacon:d684352e-df36-484e-bc98-2d5398c5593e.51201.59139" ||
                device.id == "xy:ibeacon:d684352e-df36-484e-bc98-2d5398c5593e.34177.48642" ||
                device.id == "xy:ibeacon:d684352e-df36-484e-bc98-2d5398c5593e.29889.48387" ||
                device.id == "xy:ibeacon:d684352e-df36-484e-bc98-2d5398c5593e.34753.17667"  ||
                device.id == "xy:ibeacon:d684352e-df36-484e-bc98-2d5398c5593e.60993.10754" ||
                device.id == "xy:ibeacon:d684352e-df36-484e-bc98-2d5398c5593e.15681.10755" ||
                device.id == "xy:ibeacon:d684352e-df36-484e-bc98-2d5398c5593e.38913.33795" ||
                device.id == "xy:ibeacon:d684352e-df36-484e-bc98-2d5398c5593e.39745.49411" ||
                device.id == "xy:ibeacon:d684352e-df36-484e-bc98-2d5398c5593e.34177.48643" ||
                device.id == "xy:ibeacon:d684352e-df36-484e-bc98-2d5398c5593e.4737.28419" { return }

            self?.xyoDevice = device
            self?.addDeviceHandler.sendMessage(device)
        }
    }

    func doneListening() {
        // Stop listening for XY4 and Sentinel button presses and enable bound witnesses
        XYBluetoothManager.stopListeningForXy4()
        XyoSentinelXManager.removeListener(key: "XYAddOwnershipViewCoordinator")

        // Disconnect to the devices if they were connected to
        if let xyoDevice = self.xyoDevice {
            xyoDevice.cancelButtonPressTimer()
            xyoDevice.disconnect()
        }

        if let xy4Device = self.xy4Device {
            xy4Device.disconnect()
        }
    }


}
