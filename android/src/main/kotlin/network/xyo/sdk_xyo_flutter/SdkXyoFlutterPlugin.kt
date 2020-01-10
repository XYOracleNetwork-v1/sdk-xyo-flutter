package network.xyo.sdk_xyo_flutter

import io.flutter.plugin.common.PluginRegistry.Registrar
import network.xyo.sdk_xyo_flutter.channels.XyoNodeChannel
import network.xyo.ble.generic.scanner.XYSmartScanModern
import network.xyo.sdk_xyo_flutter.channels.XyoDeviceChannel

class SdkXyoFlutterPlugin {
  companion object {
    var node:XyoNodeChannel? = null
    var device:XyoDeviceChannel? = null

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val context = registrar.activeContext()
      val smartScan = XYSmartScanModern(context.applicationContext)


      node = XyoNodeChannel(context, registrar, "xyoNode")
      node?.initializeChannels()

      device = XyoDeviceChannel(context, smartScan, registrar, "xyoDevice")
      device?.initializeChannels()
    }

  }
}
