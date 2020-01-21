package network.xyo.sdk_xyo_flutter.channels

import android.content.Context
//import io.flutter.Log
import io.flutter.plugin.common.*
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import network.xyo.sdk.*
import network.xyo.sdk_xyo_flutter.protobuf.BoundWitness
import network.xyo.sdkcorekotlin.boundWitness.XyoBoundWitness
import android.util.Log
import network.xyo.sdk_xyo_flutter.InteractionModel
import io.flutter.plugin.common.EventChannel
import java.util.*


open class XyoClientChannel(context: Context, registrar: PluginRegistry.Registrar) :XyoNodeChannel(context, registrar, "xyoClient") {
  val listener = object : XyoBoundWitnessTarget.Listener() {
    override fun boundWitnessCompleted(source: Any?, target: XyoBoundWitnessTarget, boundWitness: XyoBoundWitness?, error:String?) {
      Log.i(TAG, "Bound Witness Completed")
      var model = InteractionModel(boundWitness, null, Date())
      streamHandleEnd.send(model.toBuffer().toByteArray())
    }

    override fun boundWitnessStarted(source: Any?, target: XyoBoundWitnessTarget) {
//      super.boundWitnessStarted()

      Log.i(TAG, "Bound Witness Started" + target)
      // streamHandleEnd.send(buildDevice(device).toByteArray())

    }
  }
  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    Log.i(TAG, "onMethodCall [" + call.method + "]")
    when (call.method) {
      "build" -> build(call, result)
      "setScanning" -> setScanning(call, result)
      "getScanning" -> getScanning(call, result)
      else -> super.onMethodCall(call, result)
    }
  }
  private fun build(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    if (listener == null) {
            Log.i(TAG, "listener is null")

      sendResult(result, null)
    } else {
              Log.i(TAG, "listener is ready")

      listener!!.let {
              Log.i(TAG, "listener let is done")

        val node = XyoNodeWrapper.getInstance(context)?.node
        if (node != null) {
          (XyoNodeWrapper.getInstance(context)?.node!!.networks["ble"] as? XyoBleNetwork)?.let { network ->
            network.client.listeners[nodeName] = it
          }
          Log.i(TAG, "Sending success from listeneer")

          sendResult(result, "success")
        } else {
          sendResult(result, null)
        }
      }
    }    
  }

  private fun getScanning(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val args = call.arguments as List<Boolean>
    val node = XyoNodeWrapper.getInstance(context)?.node
    if (node != null) {
      (node!!.networks["ble"] as? XyoBleNetwork)?.let { network ->
        sendResult(result, network.client.scan)
      }
    } else {
      sendResult(result, false)
    }
  }
  private fun setScanning(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val on = call.arguments as Boolean
    val node = XyoNodeWrapper.getInstance(context)?.node
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
  companion object {
    val TAG = "XyoClientChannel"
  }
}

open class XyoServerChannel(context: Context, registrar: PluginRegistry.Registrar): XyoNodeChannel(context, registrar, "xyoServer") {
  val listener = object : XyoBoundWitnessTarget.Listener() {
    override fun boundWitnessCompleted(source: Any?, target: XyoBoundWitnessTarget, boundWitness: XyoBoundWitness?, error:String?) {
      Log.i(TAG, "Bound Witness Completed")
      var model = InteractionModel(boundWitness, null, Date())
      streamHandleEnd.send(model.toBuffer().toByteArray())
      }

    override fun boundWitnessStarted(source: Any?, target: XyoBoundWitnessTarget) {

      Log.i(TAG, "Bound Witness Started" + target)
      // streamHandleEnd.send(buildDevice(device).toByteArray())

    }
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    Log.i(TAG, "onMethodCall [" + call.method + "]")
    when (call.method) {
      "build" -> build(call, result)
      "setListening" -> setListening(call, result)
      "getListening" -> getListening(call, result)
      else -> super.onMethodCall(call, result)
    }
  }

  private fun build(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
     if (listener == null) {
            Log.i(TAG, "listener is null")

      sendResult(result, null)
    } else {
              Log.i(TAG, "listener is ready")

      listener!!.let {
              Log.i(TAG, "listener let is done")

        val node = XyoNodeWrapper.getInstance(context)?.node
        if (node != null) {
          (XyoNodeWrapper.getInstance(context)?.node!!.networks["ble"] as? XyoBleNetwork)?.let { network ->
            network.server.listeners[nodeName] = it
          }
          Log.i(TAG, "Sending success from listeneer")

          sendResult(result, "success")
        } else {
          sendResult(result, null)
        }
      }
    } 
  }
  private fun setListening(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val node = XyoNodeWrapper.getInstance(context)?.node
    if (node != null) {
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
  private fun getListening(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val node = XyoNodeWrapper.getInstance(context)?.node
    if (node != null) {
      (node!!.networks["ble"] as? XyoBleNetwork)?.let { network ->
        sendResult(result, network.server.listen)
      }
    } else {
      sendResult(result, false)
    }
  }
  companion object {
    val TAG = "XyoServerChannel"
  }
}

open class XyoNodeWrapper private constructor() {
  
  // var _hasher: XyoHasher? = null
  var node: XyoNode? = null


  private fun buildNode(context: Context) = GlobalScope.launch {
    val builder = XyoNodeBuilder()
    node = builder.build(context)
  }

  companion object {
    @Volatile private var instance: XyoNodeWrapper ?= null
    fun getInstance(context: Context): XyoNodeWrapper {
      if (instance == null) {
        synchronized(this) {
          instance = XyoNodeWrapper()
          instance!!.buildNode(context)
        }
      }
      return instance!!
    }
  }
}

@kotlin.ExperimentalUnsignedTypes
open class XyoNodeChannel(context: Context, registrar: PluginRegistry.Registrar, name: String): XyoBaseChannel(registrar, name) {
  var context: Context = context
  val streamHandleStart = EventStreamHandler()
  val streamHandleEnd = EventStreamHandler()
  private val channelStarted = EventChannel(registrar.messenger(), "${name}Started")
  private val channelEnded = EventChannel(registrar.messenger(), "${name}Ended")

  override fun initializeChannels() {
        super.initializeChannels()
    channelStarted.setStreamHandler(streamHandleStart)
    channelEnded.setStreamHandler(streamHandleEnd)
  }


  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    Log.i(TAG, "onMethodCall [" + call.method + "]")
    when (call.method) {
      "getPublicKey" -> getPublicKey(call, result)
      "setBridging" -> setBridging(call, result)
      "getBridging" -> getBridging(call, result)
      "setPayloadData" -> setPayloadData(call, result)
      "setAcceptBridging" -> setAcceptBridging(call, result)
      "setAutoBoundWitnessing" -> setAutoBoundWitnessing(call, result)
      else -> super.onMethodCall(call, result)
    }
  }

  private fun setBridging(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val node = XyoNodeWrapper.getInstance(context)?.node
    if (node != null) {
      val isClient = nodeName == "xyoClient"
      val setBridging = call.arguments as Boolean
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
    val node = XyoNodeWrapper.getInstance(context)?.node
    if (node != null) {
      (node!!.networks["ble"] as? XyoBleNetwork)?.let { network ->
        if (nodeName == "xyoClient") {
          sendResult(result, network.client.autoBridge)
        } else {
          sendResult(result, network.server.autoBridge)
        }
      }
    } else {
      sendResult(result, false)
    }

  }


   private fun setAcceptBridging(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val node = XyoNodeWrapper.getInstance(context)?.node
    if (node != null) {
      val on = call.arguments as Boolean
      (node!!.networks["ble"] as? XyoBleNetwork)?.let { network -> 
        if (nodeName == "xyoClient") {
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
    val node = XyoNodeWrapper.getInstance(context)?.node
    if (node != null) {
  
      val on = call.arguments as Boolean
      (node!!.networks["ble"] as? XyoBleNetwork)?.let { network ->
        network.client.autoBoundWitness = on
      }
      sendResult(result, true)
    } else {
      sendResult(result, false)
    }
  }


  private fun setPayloadData(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val node = XyoNodeWrapper.getInstance(context)?.node
    if (node != null) {
      val payload = call.arguments as String
      sendResult(result, true)
    } else {
      sendResult(result, false)
    }
  }

  private fun getPublicKey(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
    val node = XyoNodeWrapper.getInstance(context)?.node
    if (node != null) {
      (node!!.networks["ble"] as? XyoBleNetwork)?.let { network ->
        if (nodeName == "xyoClient") {
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