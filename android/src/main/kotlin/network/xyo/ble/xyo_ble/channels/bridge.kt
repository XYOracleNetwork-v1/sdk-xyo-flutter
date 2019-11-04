package network.xyo.ble.xyo_ble.channels

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import network.xyo.ble.devices.xy.XY4BluetoothDevice
import network.xyo.ble.flutter.protobuf.BoundWitness
import network.xyo.ble.generic.gatt.server.XYBluetoothAdvertiser
import network.xyo.ble.generic.gatt.server.XYBluetoothGattServer
import network.xyo.ble.generic.scanner.XYSmartScan
import network.xyo.ble.xyo_ble.InteractionModel
import network.xyo.modbluetoothkotlin.advertiser.XyoBluetoothAdvertiser
import network.xyo.modbluetoothkotlin.client.*
import network.xyo.modbluetoothkotlin.server.XyoBluetoothServer
import network.xyo.sdkcorekotlin.boundWitness.XyoBoundWitness
import network.xyo.sdkcorekotlin.node.XyoNodeListener
import network.xyo.sdkobjectmodelkotlin.structure.XyoIterableStructure
import network.xyo.sdkobjectmodelkotlin.structure.XyoObjectStructure
import java.util.*
import kotlin.collections.ArrayList

@kotlin.ExperimentalUnsignedTypes
class XyoBridgeChannel(context: Context, val smartScan: XYSmartScan, registrar: PluginRegistry.Registrar, name: String): XyoNodeChannel(context, registrar, name) {

    private val server = XYBluetoothGattServer(context.applicationContext)
    private val serverHelper = XyoBluetoothServer(server)
    private val xyAdvertiser = XYBluetoothAdvertiser(context)
    private lateinit var advertiser: XyoBluetoothAdvertiser

    init {
        GlobalScope.launch {
            bridgeManager.restoreAndInitBridge().await()
            bridgeManager.bridge.addListener("bridge", onBoundWitness)
        }

        XyoSentinelX.enable(true)
        XyoBridgeX.enable(true)
        XyoIosAppX.enable(true)
        XyoAndroidAppX.enable(true)
        XyoBluetoothClient.enable(true)
        XY4BluetoothDevice.enable(true)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setArchivists" -> setArchivists(call, result)
            "getBlockCount" -> getBlockCount(call, result)
            "getLastBlock" -> getLastBlock(call, result)
            "selfSign" -> selfSign(call, result)
            "getBlocks" -> getBlocks(call, result)
            "initiateBoundWitness" -> initiateBoundWitness(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun createNewAdvertiser(): XyoBluetoothAdvertiser {
        return XyoBluetoothAdvertiser(
                Random().nextInt(Short.MAX_VALUE + 1).toUShort(),
                Random().nextInt(Short.MAX_VALUE + 1).toUShort(),
                xyAdvertiser)
    }

    override suspend fun onStart(): XyoNodeChannelStatus {
        smartScan.addListener("bridge", bridgeManager.bridge.scanCallback)
        serverHelper.listener = bridgeManager.bridge.serverCallback
        server.startServer()
        serverHelper.initServer()
        advertiser = createNewAdvertiser()
        advertiser.configureAdvertiser()
        advertiser.startAdvertiser()
        smartScan.start()
        status = XyoNodeChannelStatus.Started
        return status
    }

    override suspend fun onStop(): XyoNodeChannelStatus {
        smartScan.removeListener("bridge")
        serverHelper.listener = null
        server.stopServer()
        status = XyoNodeChannelStatus.Stopped
        return status
    }

    private fun setArchivists(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
        notImplemented(result)
    }

    private fun selfSign(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
        bridgeManager.bridge.selfSignOriginChain().await()

        //now that we have a new last block
        getLastBlock(call, result)
    }

    private fun initiateBoundWitness(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
        var didInitiate = false
        val deviceId = (call.arguments as? Map<String, Any?>)?.get("deviceId") as? String
        deviceId?.let {
            val device = smartScan.deviceFromId(it) as? XyoBluetoothClient
            device?.let {
                bridgeManager.bridge.tryBoundWitnessWithDevice(device)
                didInitiate = true
            }
        }
        if (didInitiate) {
            sendResult(result, true)
        } else {
            sendError(result, "Not Found", "Device not found for connection")
        }
    }

    private fun getBlockCount(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
        val hashes = bridgeManager.bridge.blockRepository.getAllOriginBlockHashes().await() ?: return@launch sendError(result, "FAILED")
        val models = hashesToBoundWitnesses(hashes)

        sendResult(result, models?.count())
    }

    private fun getLastBlockData() = GlobalScope.async {
        val hash = bridgeManager.bridge.originState.previousHash ?: return@async null
        val structure = XyoIterableStructure(hash.bytesCopy, 0)

        val hashArray = arrayOf(structure[0])
        val hashArrayIterator = hashArray.iterator()
        val boundWitnesses = hashesToBoundWitnesses(hashArrayIterator)
        return@async boundWitnesses?.first()
    }

    private fun getLastBlock(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
        val lastModel: BoundWitness.DeviceBoundWitness? = getLastBlockData().await()
        sendResult(result, lastModel?.toByteArray())
    }

    private fun getBlocksData() = GlobalScope.async {
        val hashes = bridgeManager.blockRepo.getAllOriginBlockHashes().await()
        val iterator = hashes?.iterator()
        return@async hashesToBoundWitnesses(iterator)
    }

    private fun getBlocks(call: MethodCall, result: MethodChannel.Result) = GlobalScope.launch {
        val blocks = getBlocksData().await()
        val builder = BoundWitness.DeviceBoundWitnessList.newBuilder()
        builder.addAllBoundWitnesses(blocks?.toList())
        sendResult(result, builder.build().toByteArray())
    }

    private fun hashesToBoundWitnesses(hashes: Iterator<XyoObjectStructure>?): ArrayList<BoundWitness.DeviceBoundWitness>? {
        if (hashes == null) return null;
        val models = ArrayList<BoundWitness.DeviceBoundWitness>()

        for (hash in hashes) {
            val model = InteractionModel(bridgeManager.bridge.blockRepository, hash.bytesCopy, Date(), true)
            models.add(model.toBuffer())
        }

        return models
    }

    private fun notifyNewBoundWitness() {
        GlobalScope.launch {
            val boundWitness = getLastBlockData().await()

            if (boundWitness != null) {
                events.send(boundWitness.toByteArray())
            }
        }
    }

    private val onBoundWitness = object : XyoNodeListener() {
        override fun onBoundWitnessEndSuccess(boundWitness: XyoBoundWitness) {
            notifyNewBoundWitness()
        }
    }
}