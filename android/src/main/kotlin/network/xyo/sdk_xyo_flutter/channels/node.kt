package network.xyo.sdk_xyo_flutter.channels

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import network.xyo.sdk.XyoBleNetwork
import network.xyo.sdk.XyoNode
import network.xyo.sdk.XyoNodeBuilder

//import network.xyo.

open class XyoNodeChannel(context: Context, registrar: PluginRegistry.Registrar, name: String): XyoBaseChannel(registrar, name) {
  lateinit var node: XyoNode
  var context: Context = context

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
    node = builder.build(context)
    sendResult(result, true)
  }

  private fun setBridging(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val args = call.arguments as List<Boolean>
    val isClient = args[0]
    val setBridging = args[1]
    (node.networks["ble"] as? XyoBleNetwork)?.let { network ->
      if (isClient) {
        network.client.autoBridge = setBridging
      } else {
        network.server.autoBridge = setBridging
      }
    }
    sendResult(result, true)
  }
  private fun setListening(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val args = call.arguments as Boolean
    val on = args
    (node.networks["ble"] as? XyoBleNetwork)?.let { network ->
      network.server.listen = on
    }
    sendResult(result, true)
  }

  private fun setScanning(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val args = call.arguments as Boolean
    val on = args
    (node.networks["ble"] as? XyoBleNetwork)?.let { network ->
      network.client.scan = on
    }
    sendResult(result, true)
  }

  private fun setPayloadData(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val args = call.arguments  as List<Any>
    val isClient = args[0]
    val payload = args[1]
    //
    sendResult(result, true)
  }

  private fun getPublicKey(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val args = call.arguments as Boolean
    val isClient = args
    (node.networks["ble"] as? XyoBleNetwork)?.let { network ->
      if (isClient) {
        sendResult(result, network.client.publicKey)
      } else {
        sendResult(result, network.server.publicKey)
      }
    }
  }

}