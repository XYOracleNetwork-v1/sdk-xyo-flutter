//
//  XyoHumanHeuristics.swift
//  xyo_ble
//
//  Created by Darren Sutherland on 6/26/19.
//

import Foundation
import sdk_core_swift
import sdk_objectmodel_swift

protocol XyoHumanHeuristicResolver {
    func getHumanKey (partyIndex: Int) -> String
    func getHumanName (object: XyoObjectStructure, partyIndex: Int) throws -> String?
}

struct XyoHumanHeuristics {
    static var resolvers: [UInt8: XyoHumanHeuristicResolver] = [:]

    static func getHumanHeuristics(boundWitness: XyoBoundWitness) -> [String: String] {
        do {
            var returnArray: [String: String] = [:]
            guard let numberOfParties = try boundWitness.getNumberOfParties() else {
                return [:]
            }

            if numberOfParties == 0 {
                return [:]
            }

            for i in 0...numberOfParties - 1 {
                guard let it = try boundWitness.getFetterOfParty(partyIndex: i)?.getNewIterator() else {
                    return [:]
                }

                while try it.hasNext() {
                    let payloadItem = try it.next()
                    let pays = try XyoHumanHeuristics.handleSinglePayloadItem(item: payloadItem, index: i)
                    if pays != nil {
                        returnArray[pays.unsafelyUnwrapped.0] = pays.unsafelyUnwrapped.1
                    }
                }
            }

            return returnArray
        } catch {
            return [:]
        }
    }

    private static func handleSinglePayloadItem (item: XyoObjectStructure, index: Int) throws -> (String, String)? {
        let idOfPayloadItem = try item.getSchema().id
        guard let resolver = resolvers[idOfPayloadItem] else {
            return nil
        }

        guard let value = try resolver.getHumanName(object: item, partyIndex: index) else {
            return nil
        }

        let key = resolver.getHumanKey(partyIndex: index)

        return (key, value)
    }
}

struct RssiResolver: XyoHumanHeuristicResolver {
    func getHumanKey(partyIndex: Int) -> String {
        return String(format: NSLocalizedString("RSSI %d", comment: "rssi value"), partyIndex)
    }

    func getHumanName (object: XyoObjectStructure, partyIndex: Int) throws -> String? {
        let objectValue = try object.getValueCopy()

        if objectValue.getSize() > 0 {
            let rssi = Int8(bitPattern: (objectValue.getUInt8(offset: 0)))

            return String(rssi)
        }

        return nil
    }
}

struct IndexResolver: XyoHumanHeuristicResolver {
  func getHumanKey(partyIndex: Int) -> String {
    return String(format: NSLocalizedString("Index %d", comment: "index value"), partyIndex)
  }
  
  func getHumanName (object: XyoObjectStructure, partyIndex: Int) throws -> String? {
    let objectValue = try object.getValueCopy()
    
    if objectValue.getSize() > 0 {
      let index = Int32(bitPattern: (objectValue.getUInt32(offset: 0)))
      
      return String(index)
    }
    
    return nil
  }
}

struct TimeResolver: XyoHumanHeuristicResolver {
    func getHumanKey(partyIndex: Int) -> String {
        return String(format: NSLocalizedString("Time %d", comment: "time value"), partyIndex)
    }

    func getHumanName (object: XyoObjectStructure, partyIndex: Int) throws -> String? {
        let objectValue = try object.getValueCopy()

        if objectValue.getSize() != 8 {
            return nil
        }

        let mills = objectValue.getUInt64(offset: 0)

        return String(Int64.init(mills))
    }
}

struct GpsResolver: XyoHumanHeuristicResolver {
    func getHumanKey(partyIndex: Int) -> String {
        return String(format: NSLocalizedString("GPS %d", comment: "gps value"), partyIndex)
    }

    func getHumanName (object: XyoObjectStructure, partyIndex: Int) throws -> String? {
        guard let gps = object as? XyoIterableStructure else {
            return nil
        }

        guard let lat = try gps.get(id: XyoSchemas.LAT.id).first?.getValueCopy() else {
            return nil
        }

        guard let lng = try gps.get(id: XyoSchemas.LNG.id).first?.getValueCopy() else {
            return nil
        }

        if lng.getSize() != 8 || lat.getSize() != 8 {
            return nil
        }

        let latNumData = Double(bitPattern: lat.getUInt64(offset: 0))
        let lngNumData = Double(bitPattern: lng.getUInt64(offset: 0))

        return "\(latNumData), \(lngNumData)"

    }
}

