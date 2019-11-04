package network.xyo.ble.xyo_ble

import kotlinx.coroutines.runBlocking
import network.xyo.ble.flutter.protobuf.BoundWitness
import network.xyo.sdkcorekotlin.boundWitness.XyoBoundWitness
import network.xyo.sdkcorekotlin.repositories.XyoOriginBlockRepository
import network.xyo.sdkcorekotlin.schemas.XyoSchemas
import network.xyo.sdkobjectmodelkotlin.structure.XyoIterableStructure
import network.xyo.sdkobjectmodelkotlin.toHexString
import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.LinkedHashMap

@kotlin.ExperimentalUnsignedTypes
class InteractionModel {
    private var byteHash = ByteArray(0)
    private var boundWitness: XyoBoundWitness? = null

    /// this should never change
    var hash: String = this.byteHash.toBase58String()

    /// this shpuld never change
    var date: Date

    /// this should never change
    var linked: Boolean

    constructor(blockRepo: XyoOriginBlockRepository, hash: ByteArray, date: Date, linked: Boolean = true) {
        this.byteHash = hash
        this.date = date
        this.linked = linked

        runBlocking {
            boundWitness = blockRepo.getOriginBlockByBlockHash(hash).await()
        }
    }

    constructor(block: XyoBoundWitness?, hash: ByteArray, date: Date, linked: Boolean = true) {
        this.byteHash = hash
        this.date = date
        this.linked = linked
        this.boundWitness = block
    }


    fun getHuerestics(): LinkedHashMap<String, String> {
        val bw = this.boundWitness
        if (bw != null) {
            return HumanReadableBoundWitness.getAllHumanHuerestics(bw)
        }

        return LinkedHashMap()
    }

    fun getBytes(): String { 
        val bw = this.boundWitness

        if (bw != null) {
            return bw.bytesCopy.toHexString()
        }

        return "Bound witness has been offloaded"
    }

    fun getHumanName(publicKey: ByteArray?): String {
        val bw = this.boundWitness

        if (bw != null) {
            return HumanReadableBoundWitness.getHumanBoundWitnessName(bw, publicKey)
        }

        return "Bound witness has been offloaded"
    }

    fun parties(): Array<String> {
        val publicKeys = ArrayList<String>()
        val bw = this.boundWitness
        if (bw != null) {
            for (byteKey in getPrimaryPublicKeysFromBoundWitness(bw)) {
                publicKeys.add(byteKey.toBase58String())
            }
        }

        return publicKeys.toTypedArray()
    }

    private fun getPrimaryPublicKeysFromBoundWitness (boundWitness: XyoBoundWitness): Array<ByteArray> {
        val publicKeys = ArrayList<ByteArray>()

        val numberOfParties = boundWitness.numberOfParties ?: 0

        if (numberOfParties < 1) {
            return arrayOf()
        }


        for (i in 0 until numberOfParties) {
            val key = getPublicKeyFromPartyIndex(boundWitness, i)

            if (key != null) {
                publicKeys.add(key)

            }
        }

        return publicKeys.toTypedArray()
    }

    private fun getPublicKeyFromPartyIndex (boundWitness: XyoBoundWitness, i: Int): ByteArray? {
        val fetterOfParty = boundWitness.getFetterOfParty(i) ?: return null
        val publicKeySet = fetterOfParty[XyoSchemas.KEY_SET.id].firstOrNull() as? XyoIterableStructure ?: return null


        if (publicKeySet.count < 1) {
            return null
        }

        return publicKeySet[0].bytesCopy
    }

    fun toBuffer(): BoundWitness.DeviceBoundWitness {
        val bytes: String = boundWitness?.bytesCopy?.toHexString() ?: String()
        val byteHash: String = hash
        val humanName: String = getHumanName(null)
        val huerestics: Map<String, String> = getHuerestics().toMap()
        val parties: Array<String> = parties()
        val linked = this.linked // not sure what this is
        //val unknownFields: ByteArray = byteArrayOf() // not sure what this is

        val builder = BoundWitness.DeviceBoundWitness.newBuilder()
        builder.bytes = bytes
        builder.byteHash = byteHash
        builder.humanName = humanName
        builder.linked = linked
        builder.addAllParties(parties.toList())
        builder.putAllHuerestics(huerestics)


        return builder.build()
    }
}
