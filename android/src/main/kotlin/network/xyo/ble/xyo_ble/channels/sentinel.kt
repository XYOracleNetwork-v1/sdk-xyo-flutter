package network.xyo.ble.xyo_ble.channels

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import network.xyo.ble.devices.apple.XYIBeaconBluetoothDevice
import network.xyo.ble.devices.xy.XY4BluetoothDevice
import network.xyo.ble.generic.devices.XYBluetoothDevice
import network.xyo.ble.generic.scanner.XYSmartScan
import network.xyo.modbluetoothkotlin.client.*

@kotlin.ExperimentalUnsignedTypes
class XyoSentinelChannel(context: Context, val smartScan: XYSmartScan, registrar: PluginRegistry.Registrar, name: String): XyoNodeChannel(context, registrar, name) {

  init {
    XYIBeaconBluetoothDevice.enable(true)
    XyoBluetoothClient.enable(true)
    XyoSentinelX.enable(true)
    XyoBridgeX.enable(true)
    XyoIosAppX.enable(true)
    XyoAndroidAppX.enable(true)
    XY4BluetoothDevice.enable(true)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      else -> super.onMethodCall(call, result)
    }
  }

  fun updateStatus(status: XYSmartScan.Status? = null) {
    val newStatus = status ?: smartScan.status
    this@XyoSentinelChannel.status = when (newStatus) {
      XYSmartScan.Status.Enabled ->
        if (smartScan.started())
          XyoNodeChannelStatus.Started
        else
          XyoNodeChannelStatus.Stopped
      XYSmartScan.Status.BluetoothDisabled ->
        XyoNodeChannelStatus.Unavailable
      XYSmartScan.Status.LocationDisabled ->
        XyoNodeChannelStatus.Unavailable
      XYSmartScan.Status.BluetoothUnavailable ->
        XyoNodeChannelStatus.Unavailable
      else ->
        XyoNodeChannelStatus.Stopped
    }
  }

  override suspend fun onStart(): XyoNodeChannelStatus {
    smartScan.addListener("sentinel", object: XYSmartScan.Listener() {
      override fun statusChanged(status: XYSmartScan.Status) {
        Log.i("sentinel", "statusChanged: $status")
        super.statusChanged(status)
        updateStatus(status)
      }

      override fun detected(device: XYBluetoothDevice) {
        Log.i("sentinel", "detected")
        super.detected(device)
      }
    })
    smartScan.start()
    updateStatus()
    return status
  }

  override suspend fun onStop(): XyoNodeChannelStatus {
    smartScan.stop()
    updateStatus()
    smartScan.removeListener("sentinel")
    return status
  }
}