import Flutter
import XyBleSdk
import CoreBluetooth
import SwiftProtobuf
import sdk_xyobleinterface_swift

protocol GattDefinedOperation {
    static func process(for device: XYBluetoothDevice, operation: DefinedOperation) -> XYBluetoothResult
}

struct GattDefinedOperationHandler: GattDefinedOperation {

    // Run the operations
    static func process(for device: XYBluetoothDevice, operation: DefinedOperation) -> XYBluetoothResult {
        if let xyDevice = self.deviceAsFinder(device) {
            switch operation {
            case .song:
                _ = xyDevice.unlock()
                return xyDevice.find(.findIt)
            case .stopSong:
                _ = xyDevice.unlock()
                return xyDevice.find(.off)
            case .stayAwake:
                _ = xyDevice.unlock()
                return xyDevice.stayAwake()
            case .goToSleep:
                _ = xyDevice.unlock
                return xyDevice.fallAsleep()
            case .lock:
                _ = xyDevice.unlock()
                return xyDevice.lock()
            case .unlock:
                return xyDevice.unlock()
            default:
                return XYBluetoothResult(error: .serviceNotFound)
            }
        } else if let xySentinelX = self.deviceAsSentinelX(device) {
            switch operation {
            case .publicKey:
                guard let key = xySentinelX.getPublicKey() else {
                    return XYBluetoothResult(error: .dataNotPresent)
                }
                // Convert from Base58 and then re-encode to utf8 for Dart
                return XYBluetoothResult(data: Data(bytes: Array(key.toBase58String().utf8)))
            default:
                return XYBluetoothResult(error: .serviceNotFound)
            }
        }


        return XYBluetoothResult(error: .actionNotSupported)
    }

    // Try to cast the device to an xy finder device
    private static func deviceAsFinder(_ device: XYBluetoothDevice) -> XYFinderDeviceBase? {
        if device.family.uuid == XY4BluetoothDevice.family.uuid {
            return device as? XY4BluetoothDevice
        }

        return nil
    }

    // Try to cast the device to a sentinel X device
    private static func deviceAsSentinelX(_ device: XYBluetoothDevice) -> XyoSentinelXDevice? {
        if device.family.uuid == XyoBluetoothDevice.family.uuid {
            return device as? XyoSentinelXDevice
        }

        return nil
    }

}
