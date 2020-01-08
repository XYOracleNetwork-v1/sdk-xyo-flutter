package network.xyo.sdk_xyo_flutter.channels

import android.content.Context
import io.flutter.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import network.xyo.sdk.XyoBleNetwork
import network.xyo.sdk.XyoNode
import network.xyo.sdk.XyoNodeBuilder

//import network.xyo.

@kotlin.ExperimentalUnsignedTypes
open class XyoNodeChannel(context: Context, registrar: PluginRegistry.Registrar, name: String): XyoBaseChannel(registrar, name) {
  var node: XyoNode? = null
  var context: Context = context

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    Log.i(TAG, "onMethodCall [" + call.method + "]")
    when (call.method) {
      "build" -> build(call, result)
      "getPublicKey" -> getPublicKey(call, result)
      "setBridging" -> setBridging(call, result)
      "getBridging" -> getBridging(call, result)
      "setScanning" -> setScanning(call, result)
      "getScanning" -> getScanning(call, result)
      "setPayloadData" -> setPayloadData(call, result)
      "setAcceptBridging" -> setAcceptBridging(call, result)
      "setAutoBoundWitnessing" -> setAutoBoundWitnessing(call, result)
      "setListening" -> setListening(call, result)
      else -> super.onMethodCall(call, result)
    }
  }


  private fun build(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val builder = XyoNodeBuilder()
    node = builder.build(context)
    sendResult(result, "success")

  }

  private fun setBridging(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    if (node != null) {
     val node = node

      val args = call.arguments as List<Boolean>
      val isClient = args[0]
      val setBridging = args[1]

      (node!!.networks["ble"] as? XyoBleNetwork)?.let { network ->
        if (isClient) {
          network.client.autoBridge = setBridging
        } else {
          network.server.autoBridge = setBridging
        }
      }
      sendResult(result, true)
    } else {
      sendResult(result, false)
    }
  }

  private fun getBridging(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val args = call.arguments as List<Boolean>
    val isClient = args[0]
    (node.networks["ble"] as? XyoBleNetwork)?.let { network ->
      if (isClient) {
        sendResult(result, network.client.autoBridge)
      } else {
        sendResult(result, network.server.autoBridge)
      }
    }
    sendResult(result, true)
  }

  private fun setListening(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {

    if (node != null) {
      val node = node

      val args = call.arguments as Boolean
      val on = args
      (node!!.networks["ble"] as? XyoBleNetwork)?.let { network ->
        network.server.listen = on
      }
      sendResult(result, true)
    } else {
      sendResult(result, false)
    }
  }

   private fun setAcceptBridging(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    if (node != null) {
      val node = node

      val args = call.arguments as List<Boolean>
      val isClient = args[0]
      val on = args[1]
      (node!!.networks["ble"] as? XyoBleNetwork)?.let { network -> 
        if (isClient) {
          network.client.acceptBridging = on
        } else {
          network.server.acceptBridging = on
        }
      }
      sendResult(result, true)
    } else {
      sendResult(result, false)
    }
  }

 private fun setAutoBoundWitnessing(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {

    if (node != null) {
      val node = node

      val args = call.arguments as Boolean
      val on = args
      (node!!.networks["ble"] as? XyoBleNetwork)?.let { network ->
        network.client.autoBoundWitness = on
      }
      sendResult(result, true)
    } else {
      sendResult(result, false)
    }
  }
  private fun setScanning(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val args = call.arguments as Boolean
    val on = args
    if (node != null) {
      val node = node

      (node!!.networks["ble"] as? XyoBleNetwork)?.let { network ->
        network.client.scan = on
      }
      sendResult(result, true)
    }
    else {
      sendResult(result, false)
    }
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
    if (node != null) {
      val node = node

      (node!!.networks["ble"] as? XyoBleNetwork)?.let { network ->
        if (isClient) {
          sendResult(result, network.client.publicKey)
        } else {
          sendResult(result, network.server.publicKey)
        }
      }
    } else {
      sendResult(result, false)
    }   
  }

  companion object {
    val TAG = "XyoNodeChannel"
  }

}