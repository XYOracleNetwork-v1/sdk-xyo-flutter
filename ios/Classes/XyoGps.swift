//
//  XyoGps.swift
//  xyo_ble
//
//  Created by Darren Sutherland on 6/26/19.
//

import Foundation
import sdk_core_swift
import sdk_objectmodel_swift
import CoreLocation

struct XyoGps: XyoHeuristicGetter {
    let locManager = CLLocationManager()

    init() {
        locManager.requestWhenInUseAuthorization()
        locManager.distanceFilter = kCLDistanceFilterNone
        locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locManager.startUpdatingLocation()
    }

    func getHeuristic() -> XyoObjectStructure? {
        guard let lat: Double = locManager.location?.coordinate.latitude else {
            return nil
        }

        guard let lng: Double = locManager.location?.coordinate.longitude else {
            return nil
        }

        let encodedLat = XyoObjectStructure.newInstance(schema: XyoSchemas.LAT, bytes: XyoBuffer(data: anyToBytes(lat)))
        let encodedLng = XyoObjectStructure.newInstance(schema: XyoSchemas.LNG, bytes: XyoBuffer(data: anyToBytes(lng)))

        return XyoIterableStructure.createUntypedIterableObject(schema: XyoSchemas.GPS, values: [encodedLat, encodedLng])
    }

    func anyToBytes<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafeBytes(of: &value) { Array($0) }.reversed()
    }
}
