package network.xyo.ble.xyo_ble.channels

import io.flutter.plugin.common.*
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import network.xyo.ble.xyo_ble.ui
import java.io.PrintWriter
import java.io.StringWriter

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

open class XyoBaseChannel(registrar: PluginRegistry.Registrar, name: String): MethodChannel.MethodCallHandler {

    protected val events = EventStreamHandler()
    private val methodChannel = MethodChannel(registrar.messenger(), name)
    private val eventChannel = EventChannel(registrar.messenger(), "${name}Events")

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            else -> notImplemented(result)
        }
    }

    open fun initializeChannels() {
        methodChannel.setMethodCallHandler(this)
        eventChannel.setStreamHandler(events)
    }

    protected fun sendResult(result: MethodChannel.Result, value:Any?) {
        ui {
            try {
                result.success(value)
            } catch(ex: Exception) {
                val sw = StringWriter()
                ex.printStackTrace(PrintWriter(sw))
                result.error("sendResult", ex.message, sw.toString())
            }
        }
    }

    protected fun sendError(result: MethodChannel.Result, code: String, description: String? = null, value:Any? = null) {
        ui {
            result.error(code, description, value)
        }
    }

    protected fun notImplemented(result: MethodChannel.Result) = GlobalScope.launch {
        ui {
            result.notImplemented()
        }
    }
}