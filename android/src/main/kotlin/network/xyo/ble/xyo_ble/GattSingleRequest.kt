package network.xyo.ble.xyo_ble

import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async
import network.xyo.ble.flutter.protobuf.Gatt
import network.xyo.ble.generic.gatt.peripheral.XYBluetoothResult
import network.xyo.ble.generic.scanner.XYSmartScan

@kotlin.ExperimentalUnsignedTypes
class GattSingleRequest: GattRequestHandler() {

    companion object {
        fun process(smartScan: XYSmartScan, arguments: Any?, result: MethodChannel.Result): Deferred<Boolean> {
            return GlobalScope.async {
                val operation = operation(arguments) ?: return@async false
                val device = smartScan.devices[operation.deviceId] ?: return@async false

                val response: Gatt.GattResponse?
                var bleResult: XYBluetoothResult<Any>?= null
                device.connection {
                    bleResult = runCall(device, operation)
                    return@connection XYBluetoothResult(true)
                }
                response = response(operation, bleResult)
                relayResponse(response, result)
                cleanup(device, operation)
                return@async true
            }
        }
    }
}
