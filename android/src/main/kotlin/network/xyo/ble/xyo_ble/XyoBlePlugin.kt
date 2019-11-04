package network.xyo.ble.xyo_ble

import io.flutter.plugin.common.PluginRegistry.Registrar
import network.xyo.ble.generic.scanner.XYSmartScan
import network.xyo.ble.generic.scanner.XYSmartScanModern
import network.xyo.ble.xyo_ble.channels.*

@kotlin.ExperimentalUnsignedTypes
class XyoBlePlugin: XYSmartScan.Listener() {
  companion object {

    var sentinel:XyoSentinelChannel? = null
    var bridge:XyoBridgeChannel? = null
    var device:XyoDeviceChannel? = null

    @JvmStatic fun registerWith(registrar: Registrar) {
      val context = registrar.activeContext()
      val smartScan = XYSmartScanModern(context.applicationContext)
      sentinel = XyoSentinelChannel(context, smartScan, registrar, "network.xyo/sentinel")
      bridge = XyoBridgeChannel(context, smartScan, registrar, "network.xyo/bridge")
      device = XyoDeviceChannel(context, smartScan, registrar, "network.xyo/device")

      sentinel?.initializeChannels()
      bridge?.initializeChannels()
      device?.initializeChannels()

    }
  }
}