package network.xyo.ble.xyo_ble.channels

import android.content.Context
import io.flutter.plugin.common.*
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import network.xyo.ble.devices.apple.XYIBeaconBluetoothDevice
import network.xyo.ble.devices.xy.XY4BluetoothDevice
import network.xyo.ble.flutter.protobuf.Device
import network.xyo.ble.generic.devices.XYBluetoothDevice
import network.xyo.ble.generic.scanner.XYSmartScan
import network.xyo.ble.xyo_ble.GattGroupRequest
import network.xyo.ble.xyo_ble.GattSingleRequest
import network.xyo.modbluetoothkotlin.client.XyoBluetoothClient
import network.xyo.modbluetoothkotlin.client.XyoSentinelX
import network.xyo.modbluetoothkotlin.client.XyoBridgeX
import network.xyo.modbluetoothkotlin.client.XyoAndroidAppX
import network.xyo.modbluetoothkotlin.client.XyoIosAppX

@kotlin.ExperimentalUnsignedTypes
class XyoDeviceChannel(context: Context, val smartScan: XYSmartScan, registrar: PluginRegistry.Registrar, name: String): XyoBaseChannel(registrar, name) {

  private val listener = object: XYSmartScan.Listener() {
    override fun statusChanged(status: XYSmartScan.Status) {
      onStatus.send(status.name)
      super.statusChanged(status)
    }

    override fun connectionStateChanged(device: XYBluetoothDevice, newState: Int) {
      onConnection.send(buildDevice(device).toByteArray())
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
        family.setName("XY4+")
      }
      if (device is XyoSentinelX) {
        family.setName("SenX")
      }
      if (device is XyoBridgeX) {
        family.setName("BridgeX")
      }
      if (device is XyoAndroidAppX) {
        family.setName("AndroidAppX")
      }
      if (device is XyoIosAppX) {
        family.setName("IosAppX")
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
  private val onStatus = EventStreamHandler()
  private val onConnection = EventStreamHandler()

  private val onEnterChannel = EventChannel(registrar.messenger(), "${name}OnEnter")
  private val onExitChannel = EventChannel(registrar.messenger(), "${name}OnExit")
  private val onDetectChannel = EventChannel(registrar.messenger(), "${name}OnDetect")
  private val onStatusChannel = EventChannel(registrar.messenger(), "${name}OnStatus")
  private val onConnectionChannel = EventChannel(registrar.messenger(), "${name}OnConnection")

  init {
    XyoBluetoothClient.enable(true)
    XyoSentinelX.enable(true)
    XY4BluetoothDevice.enable(true)
    smartScan.addListener("device", listener)
    GlobalScope.launch {
      smartScan.start()
    }
  }

  override fun initializeChannels() {
    super.initializeChannels()
    onEnterChannel.setStreamHandler(onEnter)
    onExitChannel.setStreamHandler(onExit)
    onDetectChannel.setStreamHandler(onDetect)
    onStatusChannel.setStreamHandler(onStatus)
    onConnectionChannel.setStreamHandler(onConnection)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "start" -> start(call, result)
      "stop" -> stop(call, result)
      "gattSingle" -> gattSingle(call, result)
      "gattGroup" -> gattGroup(call, result)
      "gattList" -> gattList(call, result)
      "getPublicKey" -> getPublicKey(call, result)
      else -> super.onMethodCall(call, result)
    }
  }

  private fun start(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    sendResult(result, true)
  }

  private fun stop(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    sendResult(result, true)
  }

  private fun gattSingle(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    sendResult(result,GattSingleRequest.process(smartScan, call.arguments, result).await())
  }

  private fun gattGroup(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    sendResult(result,GattGroupRequest.process(smartScan, call.arguments, result))
  }

  private fun gattList(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    sendResult(result,GattGroupRequest.process(smartScan, call.arguments, result))
  }

  private fun argsAsDict(arguments: Any?): Map<String, Any?>? {
    return arguments as? Map<String, Any?>
  }

  private fun getPublicKey(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val args = this@XyoDeviceChannel.argsAsDict(call.arguments)
    val deviceId = args?.get("deviceId") as String?
    var publicKey = ""
    if (deviceId != null) {
      val device = smartScan.devices[args?.get("deviceId")]
      if (device is XyoSentinelX) {
        publicKey = device.getPublicKey().toString()
      }
      publicKey = deviceId
    }
    sendResult(result, publicKey)
  }

}