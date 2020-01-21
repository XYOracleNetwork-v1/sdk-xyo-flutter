package network.xyo.sdk_xyo_flutter

import io.flutter.plugin.common.PluginRegistry.Registrar
import network.xyo.sdk_xyo_flutter.channels.XyoClientChannel
import network.xyo.sdk_xyo_flutter.channels.XyoServerChannel
import network.xyo.ble.generic.scanner.XYSmartScanModern
import network.xyo.sdk_xyo_flutter.channels.XyoDeviceChannel
import android.util.Log

class SdkXyoFlutterPlugin {
  companion object {
    var client:XyoClientChannel? = null
    var server:XyoServerChannel? = null
    var device:XyoDeviceChannel? = null
    val TAG = "SdkXyoFlutterPlugin"

    @JvmStatic
    fun registerWith(registrar: Registrar) {

      val context = registrar.activeContext()
      val smartScan = XYSmartScanModern(context.applicationContext)

      device = XyoDeviceChannel(context, smartScan, registrar, "xyoDevice")
      device?.initializeChannels()

      client = XyoClientChannel(context, registrar)
      client?.initializeChannels()

      server = XyoServerChannel(context, registrar)
      server?.initializeChannels()


    }

  }

}
