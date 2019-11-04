import Flutter
import XyBleSdk
import CoreBluetooth
import SwiftProtobuf
import Promises

/// Handles groups of calls that may belong to different devices
struct GattListRequest: GattRequestHandler {

    static func process(arguments: Any?, result: @escaping FlutterResult) {
        guard
            let operations = self.operations(arguments)
            else {
                result(nil)
                return
        }

        Promises.any(
            // Group the operations list into operation lists per device and run them asynchronously
            Dictionary(grouping: operations.operations) { operation in operation.deviceID }
                .map { id, ops in
                    GattOperationList.with {
                        $0.deviceID = id
                        $0.operations = ops
                    }
                }
                .map {
                    GattGroupRequest.execute(self.device($0.deviceID), operations: $0)
                }
        ).then { responses in
            // Assemble and return
            self.relayResponse(GattResponseList.with { $0.responses = responses.compactMap { $0.value }.flatMap { $0 } }, result: result)
        }.catch { error in
            // do something
        }.always {
            // disconnect all devices marked as so
        }
    }

}
