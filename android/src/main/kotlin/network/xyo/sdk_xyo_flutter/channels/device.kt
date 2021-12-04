package network.xyo.sdk_xyo_flutter.channels

import android.content.Context
import io.flutter.plugin.common.*
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import network.xyo.sdk_xyo_flutter.protobuf.Device
import android.util.Log

import network.xyo.ble.generic.scanner.XYSmartScan
import network.xyo.ble.devices.apple.XYIBeaconBluetoothDevice
import network.xyo.ble.generic.devices.XYBluetoothDevice
import network.xyo.ble.devices.xy.XY4BluetoothDevice
import network.xyo.ble.generic.scanner.XYSmartScanListener
import network.xyo.ble.generic.scanner.XYSmartScanStatus


@ExperimentalUnsignedTypes
class XyoDeviceChannel(context: Context, val smartScan: XYSmartScan, registrar: PluginRegistry.Registrar, name: String): XyoBaseChannel(registrar, name) {

  private val listener = object: XYSmartScanListener() {
    override fun statusChanged(status: XYSmartScanStatus) {
      Log.i(TAG, "statusChanged$status")

      val result = when (status) {
        XYSmartScanStatus.Enabled -> "Enabled"
        XYSmartScanStatus.None -> "None"
        XYSmartScanStatus.BluetoothDisabled -> "BluetoothDisabled"
        XYSmartScanStatus.BluetoothUnavailable -> "BluetoothUnavailable"
        XYSmartScanStatus.LocationDisabled -> "LocationDisabled"
      }

      onStatusChanged.send(result)

      super.statusChanged(status)
    }

    override fun connectionStateChanged(device: XYBluetoothDevice, newState: Int) {
      Log.i(TAG, "connectionStateChanged" + newState)

      super.connectionStateChanged(device, newState)
    }

    fun buildDevice(device: XYBluetoothDevice): Device.BluetoothDevice {
      Log.i(TAG, "buildDevice" + device)

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
      Log.i(TAG, "detected" + device)

      onDetect.send(buildDevice(device).toByteArray())
      super.detected(device)
    }

    override fun entered(device: XYBluetoothDevice) {
      Log.i(TAG, "entered" + device)

      onEnter.send(buildDevice(device).toByteArray())
      super.entered(device)
    }

    override fun exited(device: XYBluetoothDevice) {
      Log.i(TAG, "exited" + device)

      onExit.send(buildDevice(device).toByteArray())
      super.exited(device)
    }
  }

  private val onEnter = EventStreamHandler()
  private val onExit = EventStreamHandler()
  private val onDetect = EventStreamHandler()
  private val onStatusChanged = EventStreamHandler()

  private val onEnterChannel = EventChannel(registrar.messenger(), "${name}OnEnter")
  private val onExitChannel = EventChannel(registrar.messenger(), "${name}OnExit")
  private val onDetectChannel = EventChannel(registrar.messenger(), "${name}OnDetect")
  private val onStatusChangedChannel = EventChannel(registrar.messenger(), "${name}OnStatusChanged")

  init {
    Log.i(TAG, "init smartScan with listener" + listener)

    smartScan.addListener("device", listener)
  }

  override fun initializeChannels() {

    super.initializeChannels()
    onEnterChannel.setStreamHandler(onEnter)
    onExitChannel.setStreamHandler(onExit)
    onDetectChannel.setStreamHandler(onDetect)
    onStatusChangedChannel.setStreamHandler(onStatusChanged)
    Log.i(TAG, "initializeChannels")

  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    Log.i(TAG, "onMethodCall [" + call.method + "]")

    when (call.method) {
      "setDeviceListening" -> setListening(call, result)
      else -> super.onMethodCall(call, result)
    }
  }

  private fun setListening(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    Log.i(TAG, "setDeviceListening " + call.arguments)

    if (call.arguments as Boolean == true) {
      smartScan.start()
    } else {
      smartScan.stop()
    }
    sendResult(result, true)
  }

  companion object {
    val TAG = "XyoDeviceChannel"
  }

}