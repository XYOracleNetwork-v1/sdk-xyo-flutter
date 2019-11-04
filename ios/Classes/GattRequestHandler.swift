import Flutter
import XyBleSdk
import CoreBluetooth
import SwiftProtobuf

/// Deserialization Errors
enum GattError: Error {
    case
    unableToDeserialize,
    unableToCreateDevice

    var localizedDescription: String {
        switch self {
        case .unableToDeserialize: return "unableToDeserialize"
        case .unableToCreateDevice: return "unableToCreateDevice"
        }
    }
}

/// Arguments for the plugin
public enum Argument: String {
    case
    request
}

/// Defines the request handler for gatt requests
protocol GattRequestHandler {
    static func process(arguments: Any?, result: @escaping FlutterResult)
}

/// Helper functions
internal extension GattRequestHandler {

    static func argsAsDict(_ arguments: Any?) -> Dictionary<String, Any?>? {
        return arguments as? Dictionary<String, Any?>
    }

    // Used to unpack a list of operations that may be across various devices or a group for one
    static func operations(_ arguments: Any?) -> GattOperationList? {
        guard
            let args = self.argsAsDict(arguments),
            let data = args[Argument.request.rawValue] as? FlutterStandardTypedData
            else { return nil }

        do {
            return try GattOperationList(serializedData: data.data)
        } catch {
            return nil
        }
    }

    // Used to unpack a single gatt request
    static func operation(_ arguments: Any?) -> GattOperation? {
        guard
            let args = self.argsAsDict(arguments),
            let data = args[Argument.request.rawValue] as? FlutterStandardTypedData
            else { return nil }

        do {
            return try GattOperation(serializedData: data.data)
        } catch {
            return nil
        }
    }

    static func device(_ id: String) -> XYBluetoothDevice? {
        return XYBluetoothDeviceFactory.build(from: id)
    }

    static func service(_ gattCall: GattCall) -> XYServiceCharacteristic? {
        return XYServiceRegistry.from(gattCall: gattCall)
    }

    // Build a success response that has data
    static func response(_ request: GattOperation, response: XYBluetoothResult?) -> GattResponse {
        return GattResponse.with {
            $0.deviceID = request.deviceID
            $0.gattCall = request.gattCall

            if let error = response?.error {
                $0.error = error.localizedDescription
            }

            if let data = response?.data {
                $0.response = data
            }
        }
    }

    // Used when the request fails in the catch
    static func response(_ request: GattOperation, error: Error) -> GattResponse {
        return GattResponse.with {
            $0.deviceID = request.deviceID
            $0.gattCall = request.gattCall
            $0.error = error.localizedDescription
        }
    }

    // Make the gatt call
    static func runCall(for device: XYBluetoothDevice, operation: GattOperation) -> XYBluetoothResult {
        var bleResult: XYBluetoothResult

        if let selectedOp = operation.operation {
            switch selectedOp {
            case .definedOperation(let defined):
                // A defined operation handles all the proper write messages and calls
                bleResult = GattDefinedOperationHandler.process(for: device, operation: defined)
            case .gattCall(let call):
                // Choose either write or read based on the request
                if let service = self.service(call) {
                    bleResult = operation.hasWriteRequest ?
                        device.set(service, value: XYBluetoothResult(data: operation.writeRequest.request), withResponse: operation.writeRequest.requiresResponse) :
                        device.get(service)
                } else {
                    bleResult = XYBluetoothResult(error: .serviceNotFound)
                }
            }
        } else {
            bleResult = XYBluetoothResult(error: .actionNotSupported)
        }

        return bleResult
    }

    static func relayResponse(_ response: GattResponse?, result: @escaping FlutterResult) {
        do {
            result(try response?.serializedData())
        } catch {
            // do something
        }
    }

    static func relayResponse(_ responses: GattResponseList?, result: @escaping FlutterResult) {
        do {
            result(try responses?.serializedData())
        } catch {
            // do something
        }
    }

    static func cleanup(for device: XYBluetoothDevice, operation: GattOperation) {
        if operation.disconnectOnCompletion {
            device.disconnect()
        }
    }

    static func cleanup(for device: XYBluetoothDevice, operations: GattOperationList) {
        if operations.disconnectOnCompletion {
            device.disconnect()
        }
    }
}
