package network.xyo.ble.xyo_ble.channels

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import network.xyo.*
//import network.xyo.

open class XyoNodeChannel(context: Context, registrar: PluginRegistry.Registrar, name: String): XyoBaseChannel(registrar, name) {
  lateinit var node: XyoNode

  protected var status = STATUS_STOPPED

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "build" -> build(call, result)
      "getPublicKey" -> getPublicKey(call, result)
      "setBridging" -> setBridging(call, result)
      "setScanning" -> setScanning(call, result)
      "setPayloadData" -> setPayloadData(call, result)
      "setListening" -> setListening(call, result)
      else -> super.onMethodCall(call, result)
    }
  }


  private fun build(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val builder = XyoNodeBuilder()
    node = builder.build(this)
  }

  private fun setBridging(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val args = call.arguments as Any
    val isClient = args[0]
    val setBridging = args[1]
    (node.networks["ble"] as? XyoBleNetwork)?.let { network ->
      if (isClient) {
        network.client.autoBridge = setBridging
      } else {
        network.server.autoBridge = setBridging
      }
    }
    sendResult(result, status)
  }
  private fun setListening(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val args = call.arguments as Any
    val on = args
    (node.networks["ble"] as? XyoBleNetwork)?.let { network ->
      network.server.listening = on
    }
    sendResult(result, status)
  }

  private fun setScanning(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    status = onStartAsync().await()
    sendResult(result, status)
  }

  private fun setPayloadData(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    status = onStopAsync().await()
    sendResult(result, status)
  }

  private fun getPublicKey(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    sendResult(result, XyoSdk.getPrimaryPublicKeyAsString())
  }

  companion object {
    const val STATUS_STARTED = "started"
    const val STATUS_STOPPED = "stopped"
  }
}