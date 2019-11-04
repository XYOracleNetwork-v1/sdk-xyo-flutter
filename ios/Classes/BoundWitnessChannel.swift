//
//  BoundWitnessChannel.swift
//  xyo_ble
//
//  Created by Darren Sutherland on 6/26/19.
//

import Foundation
import secp256k1
import sdk_core_swift
import sdk_bletcpbridge_swift
import sdk_objectmodel_swift

internal class BoundWitnessEventChannel: NSObject, FlutterStreamHandler {

    var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    private func buildMessage(_ boundWitnessList: DeviceBoundWitnessList) -> Data? {
        do {
            return try boundWitnessList.serializedData()
        } catch {
            return nil
        }
    }

    func sendMessage(_ boundWitnesses: [InteractionModel]) {
        let boundWitnessList = DeviceBoundWitnessList.with {
            $0.boundWitnesses = boundWitnesses.map { witness in witness.toBuffer }
        }

        self.eventSink?(self.buildMessage(boundWitnessList))
    }

}
