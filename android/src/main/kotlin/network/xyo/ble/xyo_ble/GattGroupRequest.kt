package network.xyo.ble.xyo_ble

import io.flutter.plugin.common.MethodChannel
import network.xyo.ble.flutter.protobuf.Gatt
import network.xyo.ble.generic.gatt.peripheral.XYBluetoothResult
import network.xyo.ble.generic.scanner.XYSmartScan

@kotlin.ExperimentalUnsignedTypes
class GattGroupRequest: GattRequestHandler() {

    companion object {
        suspend fun process(smartScan: XYSmartScan, arguments: Any?, result: MethodChannel.Result): Boolean {
                val operations = operations(arguments) ?: return false
                val responses = execute(smartScan, operations) ?: return false
                val responseListBuilder = Gatt.GattResponseList.newBuilder()
                for (response: Gatt.GattResponse in responses) {
                    responseListBuilder.addResponses(response)
                }
                relayResponse(responseListBuilder.build(), result)
                return true
        }

        suspend fun execute(smartScan: XYSmartScan, operations: Gatt.GattOperationList): MutableList<Gatt.GattResponse>? {
            val responses = mutableListOf<Gatt.GattResponse>()
            for (operation in operations.operationsList) {
                val device = smartScan.devices[operation.deviceId] ?: return null
                device.connection {
                    val result = runCall(device, operation)
                    responses.add(response(operation, result))
                    return@connection XYBluetoothResult(true)
                }
            }
            return responses
        }
    }

}
