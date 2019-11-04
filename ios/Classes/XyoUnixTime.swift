//
//  XyoUnixTime.swift
//  xyo_ble
//
//  Created by Darren Sutherland on 6/26/19.
//

import Foundation
import sdk_core_swift
import sdk_objectmodel_swift

struct XyoUnixTime: XyoHeuristicGetter {
    func getHeuristic() -> XyoObjectStructure? {
        let time: Double = NSDate().timeIntervalSince1970
        let timeAsMilliseconds = UInt64(time * 1000)

        return XyoObjectStructure.newInstance(schema: XyoSchemas.UNIX_TIME, bytes: XyoBuffer().put(bits: timeAsMilliseconds))
    }
}

