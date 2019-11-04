import Flutter
import XyBleSdk
import CoreBluetooth
import SwiftProtobuf

/// Makes a single gatt request
struct GattSingleRequest: GattRequestHandler {

    static func process(arguments: Any?, result: @escaping FlutterResult) {
        guard
            let operation = self.operation(arguments),
            let device = self.device(operation.deviceID)
            else {
                result(nil)
                return
        }

        var response: GattResponse?
        var bleResult: XYBluetoothResult?
        device.connection {
            bleResult = self.runCall(for: device, operation: operation)
        }.then {
            response = self.response(operation, response: bleResult)
            self.relayResponse(response, result: result)
        }.catch { error in
            response = self.response(operation, error: error)
            self.relayResponse(response, result: result)
        }.always {
            self.cleanup(for: device, operation: operation)
        }
    }

}
