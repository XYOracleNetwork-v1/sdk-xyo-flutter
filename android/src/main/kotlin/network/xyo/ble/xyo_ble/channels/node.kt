package network.xyo.ble.xyo_ble.channels

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import network.xyo.ble.generic.scanner.XYSmartScan
import network.xyo.ble.xyo_ble.BridgeManager

enum class XyoNodeChannelStatus {
  None,
  Started,
  Stopped,
  Unavailable
}

@kotlin.ExperimentalUnsignedTypes
open class XyoNodeChannel(context: Context, registrar: PluginRegistry.Registrar, name: String): XyoBaseChannel(registrar, name) {

  protected val bridgeManager = BridgeManager(context)
  protected var status = XyoNodeChannelStatus.None

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "start" -> GlobalScope.launch { start(result) }
      "stop" -> GlobalScope.launch { stop(result) }
      "getPublicKey" -> getPublicKey(result)
      "getStatus" -> getStatus(result)
      else -> super.onMethodCall(call, result)
    }
  }

  //this should return the new running state
  open suspend fun onStart(): XyoNodeChannelStatus {
    return status
  }

  //this should return the new running state
  open suspend fun onStop(): XyoNodeChannelStatus {
    return status
  }

  private fun getStatus(result: MethodChannel.Result) {
    sendResult(result, status.name)
  }

  private suspend fun start(result: MethodChannel.Result) {
    status = onStart()
    sendResult(result, status.name)
  }

  private suspend fun stop(result: MethodChannel.Result) {
    status = onStop()
    sendResult(result, status.name)
  }

  private fun getPublicKey(result: MethodChannel.Result) {
    sendResult(result, bridgeManager.getPrimaryPublicKeyAsString())
  }
}