package network.xyo.ble.xyo_ble

import network.xyo.ble.devices.xy.XYFinderBluetoothDevice
import network.xyo.ble.flutter.protobuf.Gatt
import network.xyo.ble.generic.devices.XYBluetoothDevice
import network.xyo.ble.generic.gatt.peripheral.XYBluetoothResult
import network.xyo.modbluetoothkotlin.client.XyoSentinelX

class GattDefinedOperationHandler {

    companion object {
        // Run the operations
        @kotlin.ExperimentalUnsignedTypes
        suspend fun process(device: XYBluetoothDevice, operation: Gatt.DefinedOperation): XYBluetoothResult<Any>? {
                val finder = device as? XYFinderBluetoothDevice
                val sentinelX = device as? XyoSentinelX
                var result: XYBluetoothResult<Any>? = null
                device.connection {
                    when (operation) {
                        Gatt.DefinedOperation.SONG -> {
                            finder?.unlock()
                            finder?.find()?.let {
                                result = XYBluetoothResult(it.value, it.error)
                            }
                        }
                        Gatt.DefinedOperation.STOP_SONG -> {
                            finder?.unlock()
                            finder?.stopFind()?.let {
                                result = XYBluetoothResult(it.value, it.error)
                            }
                        }
                        Gatt.DefinedOperation.STAY_AWAKE -> {
                            finder?.unlock()
                            finder?.stayAwake()?.let {
                                result = XYBluetoothResult(it.value, it.error)
                            }
                        }
                        Gatt.DefinedOperation.GO_TO_SLEEP -> {
                            finder?.unlock()
                            finder?.fallAsleep()?.let {
                                result = XYBluetoothResult(it.value, it.error)
                            }
                        }
                        Gatt.DefinedOperation.LOCK -> {
                            finder?.lock()?.let {
                                result = XYBluetoothResult(it.value, it.error)
                            }
                        }
                        Gatt.DefinedOperation.UNLOCK -> {
                            finder?.lock()?.let {
                                result = XYBluetoothResult(it.value, it.error)
                            }
                        }
                        Gatt.DefinedOperation.PUBLIC_KEY -> {
                            val key = sentinelX?.getPublicKey()
                            val value = key?.value
                            if (value != null) {
                                result = XYBluetoothResult(value.toBase58String())
                            } else {
                                result = XYBluetoothResult(false)
                            }
                        }
                        else -> {
                            result = XYBluetoothResult(false)
                        }
                    }
                    return@connection XYBluetoothResult(true)
                }
                return result
        }
    }
}
