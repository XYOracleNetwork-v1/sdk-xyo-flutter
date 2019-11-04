package network.xyo.ble.xyo_ble

import io.flutter.plugin.common.EventChannel
import network.xyo.ble.flutter.protobuf.BoundWitness

data class DeviceBoundWitness(
  val bytes: String = String(),
  val byteHash: String = String(),
  val humanName: String = String(),
  val huerestics: Map<String, String> = emptyMap(),
  val parties: Array<String> = emptyArray(),
  val linked: Boolean = false,
  val unknownFields: ByteArray = byteArrayOf(0)
)

data class DeviceBoundWitnessList (
    val boundWitnesses: List<DeviceBoundWitness> = listOf(),
    val unknownFields: ByteArray = ByteArray(0)
)

class BoundWitnessStreamHandler : EventChannel.StreamHandler {

    private var eventSink: EventChannel.EventSink? = null

  override fun onListen(args: Any?, eventSink: EventChannel.EventSink?) {
    this.eventSink = eventSink
  }

  override fun onCancel(args: Any?) {
      this.eventSink = null
  }

  fun sendMessage(boundWitnesses: Array<BoundWitness.DeviceBoundWitness>) {
      val builder = BoundWitness.DeviceBoundWitnessList.newBuilder()

      builder.addAllBoundWitnesses(boundWitnesses.toList())

      ui {
          eventSink?.success(builder.build().toByteArray())
      }
  }
}