package network.xyo.sdk_xyo_flutter

//import network.xyo.sdk_xyo_flutter.XYBluetoothDevice
import android.util.Log
import network.xyo.sdk.*

import io.flutter.plugin.common.EventChannel
//import network.xyo.ble.devices.XYFinderBluetoothDevice
//import network.xyo.ble.devices.XYIBeaconBluetoothDevice

import network.xyo.sdk_xyo_flutter.protobuf.Device
import network.xyo.ble.xyo_ble.ui

class SmartScanEventHandler : EventChannel.StreamHandler {

    var eventSink: EventChannel.EventSink? = null

    override fun onListen(args: Any?, events: EventChannel.EventSink?) {
        this.eventSink = events
    }

    override fun onCancel(args: Any?) {
        this.eventSink = null
    }

//    fun sendMessage(device: XYBluetoothDevice) {
//        val family = Device.Family.newBuilder()
//        val range = Device.Range.newBuilder()
//        val beacon = Device.IBeacon.newBuilder()
//        val deviceData = Device.BluetoothDevice.newBuilder()
//
//        deviceData.setConnected(device.connected)
//        deviceData.setRssi((device.rssi ?: -999).toLong())
//
//        if (device is XYIBeaconBluetoothDevice) {
//            deviceData.setId(device.id)
//            family.setUuid(device.uuid.toString())
//            beacon.setUuid(device.uuid.toString())
//            beacon.setMajor((device.major.toString().toLong()))
//            beacon.setMajor((device.minor.toString().toLong()))
//        }
//
//        if (device is XYFinderBluetoothDevice) {
//            family.setName(device.name)
//        }
//
//        deviceData.setFamily(family)
//        deviceData.setRange(range)
//        deviceData.setBeacon(beacon)
//
//
//        ui {
//            this@SmartScanEventHandler.eventSink?.success(
//                    deviceData.build().toByteArray()
//            )
//        }
//    }
}