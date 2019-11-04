import Flutter
import XyBleSdk
import CoreBluetooth
import SwiftProtobuf
import Promises

/// Handles a set of calls for one device in one connection
struct GattGroupRequest: GattRequestHandler {

    static func process(arguments: Any?, result: @escaping FlutterResult) {
        guard
            let operations = self.operations(arguments),
            let device = self.device(operations.deviceID)
            else {
                result(nil)
                return
        }

        self.execute(device, operations: operations).then { responses in
            self.relayResponse(GattResponseList.with { $0.responses = responses }, result: result)
        }.catch { error in
            // do something
        }
    }

    static func execute(_ device: XYBluetoothDevice?, operations: GattOperationList) -> Promise<[GattResponse]> {
        guard let device = device else {
            return Promise([])
        }

        let operationPromise = Promise<[GattResponse]>.pending()

        var responses = [GattResponse]()
        var results = [XYBluetoothResult]()

        device.connection {
            results = operations.operations.map { self.runCall(for: device, operation: $0) }
        }.then {
            // Assemble the responses
            for (index, operation) in operations.operations.enumerated() {
                guard let bleResult = results[safe: index] else {
                    // do something
                    continue
                }
                if bleResult.hasError {
                    responses.append(self.response(operation, error: bleResult.error!))
                } else {
                    responses.append(self.response(operation, response: bleResult))
                }
            }

            operationPromise.fulfill(responses)

        }.catch { error in
            // Do something here
            operationPromise.reject(error)
        }.always {
            self.cleanup(for: device, operations: operations)
        }

        return operationPromise
    }

}
