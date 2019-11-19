package network.xyo.sdk_xyo_flutter

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.common.EventChannel

import network.xyo.ble.xyo_ble.ui

class EventStreamHandler: EventChannel.StreamHandler {
  private var eventSink: EventChannel.EventSink? = null

  override fun onListen(args: Any?, eventSink: EventChannel.EventSink?) {
    this.eventSink = eventSink
  }

  override fun onCancel(args: Any?) {
    this.eventSink = null
  }

  fun send(event: Any) {
    ui {
      eventSink?.success(event)
    }
  }
}

class SdkXyoFlutterPlugin: MethodCallHandler {
  companion object {
    private val onDetect = EventStreamHandler()
    private val onBoundWitnessSuccess = EventStreamHandler()

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "xyo_node_methods")
      channel.setMethodCallHandler(SdkXyoFlutterPlugin())

      val deviewChannel = EventChannel(registrar.messenger(), "xyo_device_detected_channel")

      deviewChannel.setStreamHandler(onDetect)

      val boundWitnessChannel = EventChannel(registrar.messenger(), "xyo_bw_success_channel")

      boundWitnessChannel.setStreamHandler(onBoundWitnessSuccess)
    }

  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "build") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "getPublicKey") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    }
    else {
      result.notImplemented()
    }
  }
}
