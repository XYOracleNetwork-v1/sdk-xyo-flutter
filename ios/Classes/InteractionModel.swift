//
//  InteractionModel.swift
//  xyo_ble
//
//  Created by Darren Sutherland on 6/27/19.
//

import Foundation
import secp256k1
import sdk_core_swift
import sdk_bletcpbridge_swift
import sdk_objectmodel_swift

class InteractionModel {
    private var byteHash: [UInt8]
    private var boundWitness: XyoBoundWitness?

    /// this should never change
    fileprivate(set) lazy var hash: String = self.byteHash.toBase58String()

    /// this shpuld never change
    let date: Date

    /// this should never change
    let linked: Bool

    var huerestics : [String: String] {
        guard let bw = self.boundWitness else {
            return [:]
        }

        return XyoHumanHeuristics.getHumanHeuristics(boundWitness: bw)
    }

    var bytes: String {
        guard let bw = self.boundWitness else {
            return NSLocalizedString("Bound witness has been offloaded", comment: "bw offloaded interactions view model")
        }

        return bw.getBuffer().toByteArray().toHexString()
    }

    var humanName: String {
        guard let bw = self.boundWitness else {
            return NSLocalizedString("Bound witness has been offloaded", comment: "bw offloaded interactions view model")
        }

        return XyoHumanName.getHumanName(boundWitmess: bw, publicKey: BridgeManager.instance.getPrimaryPublicKey())
    }

    var parties: [String] {
        var publicKeys = [String]()
        guard let bw = self.boundWitness else {
            return publicKeys
        }

        for byteKey in getPrimaryPublicKeysFromBoundWitness(boundWitness: bw) {
            publicKeys.append(byteKey?.toBase58String() ?? NSLocalizedString("No public key", comment: "no public key interactions view model"))
        }

        return publicKeys
    }

    private func getPrimaryPublicKeysFromBoundWitness (boundWitness: XyoBoundWitness) -> [[UInt8]?] {
        var publicKeys = [[UInt8]?]()

        do {
            let numberOfParties = try boundWitness.getNumberOfParties() ?? 0

            if numberOfParties < 1 {
                return []
            }

            for i in 0...numberOfParties - 1 {
                publicKeys.append(try getPublicKeyFromPartyIndex(boundWitness: boundWitness, i: i))
            }

        } catch {
            return []
        }

        return publicKeys
    }

    private func getPublicKeyFromPartyIndex (boundWitness: XyoBoundWitness, i: Int) throws -> [UInt8]? {
        guard let fetterOfParty = try boundWitness.getFetterOfParty(partyIndex: i) else {
            return nil
        }

        guard let publicKeySet = try fetterOfParty.get(id: XyoSchemas.KEY_SET.id).first as? XyoIterableStructure else {
            return nil
        }

        if try publicKeySet.getCount() < 1 {
            return nil
        }

        return try publicKeySet.get(index: 0).getBuffer().toByteArray()
    }

    init(_ hash: [UInt8], date: Date, linked: Bool = true) {
        self.byteHash = hash
        self.date = date
        self.linked = linked
        do {
            boundWitness = try BridgeManager.instance.blockRepo.getOriginBlock(originBlockHash: self.byteHash)
        } catch {}
    }

    var toBuffer: DeviceBoundWitness {
        return DeviceBoundWitness.with {
            $0.bytes = self.bytes
            $0.byteHash = self.byteHash.toHexString()
            $0.linked = self.linked
            $0.huerestics = self.huerestics
            $0.parties = self.parties
            $0.humanName = self.humanName
        }
    }

}
