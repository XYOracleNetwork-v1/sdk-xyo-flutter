package network.xyo.ble.xyo_ble

import android.content.Context
import android.util.Log
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import network.xyo.modbluetoothkotlin.node.XyoBleNode
import network.xyo.sdkcorekotlin.boundWitness.XyoBoundWitness
import network.xyo.sdkcorekotlin.crypto.signing.XyoSigner
import network.xyo.sdkcorekotlin.crypto.signing.ecdsa.secp256k.XyoSha256WithSecp256K
import network.xyo.sdkcorekotlin.hashing.XyoBasicHashBase
import network.xyo.sdkcorekotlin.heuristics.XyoUnixTime
import network.xyo.sdkcorekotlin.network.XyoNetworkHandler
import network.xyo.sdkcorekotlin.network.XyoProcedureCatalog
import network.xyo.sdkcorekotlin.network.XyoProcedureCatalogFlags
import network.xyo.sdkcorekotlin.network.tcp.XyoTcpPipe
import network.xyo.sdkcorekotlin.node.XyoNodeListener
import network.xyo.sdkcorekotlin.persist.repositories.XyoStorageOriginBlockRepository
import network.xyo.sdkcorekotlin.persist.repositories.XyoStorageOriginStateRepository
import network.xyo.sdkcorekotlin.persist.repositories.XyoStorageBridgeQueueRepository
import network.xyo.sdkcorekotlin.schemas.XyoSchemas
import network.xyo.sdkobjectmodelkotlin.structure.XyoObjectStructure
import java.io.IOException
import java.net.Socket
import java.nio.ByteBuffer

@kotlin.ExperimentalUnsignedTypes
class BridgeManager (context: Context) {

    companion object {
        private val SIGNER_KEY = "SIGNER_KEY".toByteArray()
        var BRIDGE_INTERVAL = 3
    }

    private val boundWitnessCatalogueForCollection = object : XyoProcedureCatalog {
        val canDoByte = XyoProcedureCatalogFlags.BOUND_WITNESS or XyoProcedureCatalogFlags.GIVE_ORIGIN_CHAIN or XyoProcedureCatalogFlags.TAKE_ORIGIN_CHAIN

        override fun canDo(byteArray: ByteArray): Boolean {
            if (byteArray.isEmpty()) {
                return false
            }

            return byteArray.last().toInt() and canDoByte != 0
        }

        override fun choose(byteArray: ByteArray): ByteArray {

            return sharedChoose(byteArray)
        }

        override fun getEncodedCanDo(): ByteArray {

            return byteArrayOf(0x00, 0x00, 0x00, canDoByte.toByte())
        }
    }

    var archivists = ArrayList<Archivist>()
    var hasher = XyoBasicHashBase.createHashType(XyoSchemas.SHA_256, "SHA-256")
    var storage = XyoSnappyDbStorageProvider(context)
    var blockRepo = XyoStorageOriginBlockRepository(this.storage, this.hasher)
    var stateRepo = XyoStorageOriginStateRepository(this.storage)
    var queueRepo = XyoStorageBridgeQueueRepository(this.storage)
    var bridge = XyoBleNode(boundWitnessCatalogueForCollection, blockRepo, stateRepo, queueRepo, hasher)

    private fun sharedChoose(byteArray: ByteArray): ByteArray {
        if (byteArray.isEmpty()) {
            return byteArrayOf(XyoProcedureCatalogFlags.BOUND_WITNESS.toByte())
        }

        val intrestedIn = byteArray.last().toInt()

        if (intrestedIn and XyoProcedureCatalogFlags.GIVE_ORIGIN_CHAIN != 0) {
            return byteArrayOf(XyoProcedureCatalogFlags.TAKE_ORIGIN_CHAIN.toByte())
        }


        if (intrestedIn and XyoProcedureCatalogFlags.TAKE_ORIGIN_CHAIN != 0) {
            return byteArrayOf(XyoProcedureCatalogFlags.GIVE_ORIGIN_CHAIN.toByte())
        }


        return byteArrayOf(XyoProcedureCatalogFlags.BOUND_WITNESS.toByte())
    }

    private val boundWitnessCatalogueForSending = object : XyoProcedureCatalog {
        val canDo = XyoProcedureCatalogFlags.GIVE_ORIGIN_CHAIN or XyoProcedureCatalogFlags.TAKE_ORIGIN_CHAIN

        override fun canDo(byteArray: ByteArray): Boolean {
            if (byteArray.isEmpty()) {
                return false
            }

            return byteArray.last().toInt() and canDo != 0
        }

        override fun choose(byteArray: ByteArray): ByteArray {
            return sharedChoose(byteArray)
        }

        override fun getEncodedCanDo(): ByteArray {
            return byteArrayOf(0x00, 0x00, 0x00, canDo.toByte())
        }
    }

    fun getPaymentKey(): XyoObjectStructure? {
        for (static in bridge.originState.statics) {
            if (static.schema.id == XyoSchemas.PAYMENT_KEY.id) {
                return static
            }
        }

        return null
    }

    fun setPaymentKeyAsync(key: ByteArray): Deferred<Unit> = GlobalScope.async {
        val encodedKey = XyoObjectStructure.newInstance(XyoSchemas.PAYMENT_KEY, key)
        stateRepo.setStaticHeuristics(arrayOf(encodedKey))
    }

    private fun getSignerAsync(): Deferred<XyoSigner> = GlobalScope.async {
        val signerNow = storage.read(SIGNER_KEY).await()

        if (signerNow == null) {
            val newSigner = XyoSha256WithSecp256K.newInstance()

            storage.write(SIGNER_KEY, newSigner.privateKey.bytesCopy).await()

            return@async newSigner
        }

        return@async XyoSha256WithSecp256K.newInstance(signerNow)
    }

    suspend fun bridge() {
        if (archivists.isEmpty()) {
            Log.v("Bridge", "No archivists, skipping bridging!")
        }

        try {
            for (archivist in archivists) {
                println("Trying to bridge to ${archivist.ip}:${archivist.port}  --- 0")

                val socket = Socket(archivist.ip, archivist.port) //boundWitnessServerPort
                val pipe = XyoTcpPipe(socket, null)
                val handler = XyoNetworkHandler(pipe)

                val bw = bridge.boundWitness(handler, boundWitnessCatalogueForSending).await()

                pipe.close().await()
                if (bw != null) {
                    return
                }
            }
        } catch (e: IOException) {
            // skip over archivist if there is an io exception
        }
    }


    fun getPrimaryPublicKey(): ByteArray? {
        if (bridge.originState.signers.isEmpty()) {
            return null
        }

        return bridge.originState.signers.first().publicKey.bytesCopy
    }

    fun getPrimaryPublicKeyAsString(): String? {
        return getPrimaryPublicKey()?.toBase58String()
    }

    fun restoreAndInitBridge () = GlobalScope.async {
        bridge.originBlocksToBridge.removeWeight = 2
        bridge.originBlocksToBridge.sendLimit = 38
        bridge.addHeuristic("TIME", XyoUnixTime.getter)

        val currentSigner = getSignerAsync().await()

        stateRepo.restore(arrayListOf(currentSigner)).await()
        queueRepo.restore().await()

        if (ByteBuffer.wrap((bridge.originState.index.valueCopy)).int == 0) {
            bridge.selfSignOriginChain().await()
        }

        bridge.addListener(this.toString() + "BRIDGE", bridgeListener)
    }

    private val bridgeListener = object : XyoNodeListener() {
        override fun onBoundWitnessEndSuccess(boundWitness: XyoBoundWitness) {
            if (ByteBuffer.wrap((bridge.originState.index.valueCopy)).int % BRIDGE_INTERVAL == 0) {
                GlobalScope.launch {
                    bridge()
                }
            }
        }
    }
}
