package network.xyo.ble.xyo_ble.channels

import android.content.Context
import io.flutter.plugin.common.*
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import network.xyo.sdk_xyo_flutter.protobuf.Device

import network.xyo.ble.generic.scanner.XYSmartScan
import network.xyo.ble.devices.apple.XYIBeaconBluetoothDevice
import network.xyo.ble.generic.devices.XYBluetoothDevice
import network.xyo.ble.devices.xy.XY4BluetoothDevice


class XyoDeviceChannel(context: Context, val smartScan: XYSmartScan, registrar: PluginRegistry.Registrar, name: String): XyoBaseChannel(registrar, name) {

  private val listener = object: XYSmartScan.Listener() {
    override fun statusChanged(status: XYSmartScan.Status) {
      super.statusChanged(status)
    }

    override fun connectionStateChanged(device: XYBluetoothDevice, newState: Int) {
      super.connectionStateChanged(device, newState)
    }

    fun buildDevice(device: XYBluetoothDevice): Device.BluetoothDevice {
      val builder = Device.BluetoothDevice.newBuilder()

      builder.setId(device.id)
      builder.setConnected(device.connected)
      val family = Device.Family.newBuilder().setId(device.id).setName(device.name)
      if (device is XYIBeaconBluetoothDevice) {
        family.setUuid(device.uuid.toString())
      }
      if (device is XY4BluetoothDevice) {
        family.setPrefix("xy")
      }
      builder.setFamily(family)
      builder.setConnected(device.connected)
      builder.setRssi(device.rssi?.toLong() ?: -999L)
      return builder.build()
    }

    override fun detected(device: XYBluetoothDevice) {
      onDetect.send(buildDevice(device).toByteArray())
      super.detected(device)
    }

    override fun entered(device: XYBluetoothDevice) {
      onEnter.send(buildDevice(device).toByteArray())
      super.entered(device)
    }

    override fun exited(device: XYBluetoothDevice) {
      onExit.send(buildDevice(device).toByteArray())
      super.exited(device)
    }
  }

  private val onEnter = EventStreamHandler()
  private val onExit = EventStreamHandler()
  private val onDetect = EventStreamHandler()

  private val onEnterChannel = EventChannel(registrar.messenger(), "${name}OnEnter")
  private val onExitChannel = EventChannel(registrar.messenger(), "${name}OnExit")
  private val onDetectChannel = EventChannel(registrar.messenger(), "${name}OnDetect")

  init {

    smartScan.addListener("device", listener)
  }

  override fun initializeChannels() {
    super.initializeChannels()
    onEnterChannel.setStreamHandler(onEnter)
    onExitChannel.setStreamHandler(onExit)
    onDetectChannel.setStreamHandler(onDetect)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "start" -> start(call, result)
      "stop" -> stop(call, result)
      else -> super.onMethodCall(call, result)
    }
  }

  private fun start(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    sendResult(result, true)
  }

  private fun stop(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    sendResult(result, true)
  }


}