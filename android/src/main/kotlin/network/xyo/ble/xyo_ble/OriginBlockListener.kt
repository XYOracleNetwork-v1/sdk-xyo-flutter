package network.xyo.ble.xyo_ble

import network.xyo.sdkcorekotlin.boundWitness.XyoBoundWitness
import java.time.LocalDateTime
import java.util.*

/*@kotlin.ExperimentalUnsignedTypes
interface XYOriginBlockListenerDelegate {
    fun updated(blocks: Array<InteractionModel>, lastBoundWitnessTime: String)
}

class XYOriginBlockListener {

    val boundWitnessHandler = BoundWitnessStreamHandler()

    private var delegates = emptyMap<String, XYOriginBlockListenerDelegate>()

    private var blocks = mutableListOf<InteractionModel>()

    private var lastBoundWitnessTime: String = ""

    fun listen(key: String, delegate: XYOriginBlockListenerDelegate) {
        synchronized(this) {
            process()
            delegates[key] = delegate
        }
    }

    fun listen() {
        synchronized(this) {
            process()
        }
    }

    fun report() {
        boundWitnessHandler.sendMessage(blocks)
    }

    fun startReporting() {
        BridgeManager.instance.bridge.addListener(key: "[DBG: \(#function)]: \(Unmanaged.passUnretained(self).toOpaque())", listener: self)
        listen()
    }

    fun clearListeners() {
        synchronized(this) {
            delegates.removeAll()
        }
    }

    fun getLastBoundWitnessTime(): String {
        val lastBoundWitnessTime = BridgeManager.instance.bridge.repositoryConfiguration.originState.lastBoundWitnessTime() else {
            return "Unknown"
        }

        val date = Date(lastBoundWitnessTime.toLong as Long)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"

        return dateFormatter.string(from: date)
    }

    private fun process() {
        self.accessQueue.async(flags: .barrier) {
            do {
                var viewModels = [InteractionModel]()
                let hashes = try (BridgeManager.instance.bridge.repositoryConfiguration.originBlock as! XyoStrageProviderOriginBlockRepository)
                        .getAllOriginBlockHashes().getNewIterator()

                    while try hashes.hasNext() {
                        let hash = try hashes.next()
                        let hashString = hash.getBuffer().toByteArray()
                        let date = Date() // todo, presist the date of a block withought reading its value
                        viewModels.append(InteractionModel(hashString, date: date))
                    }

                        self.blocks = viewModels.reversed()
                        self.lastBoundWitnessTime = self.getLastBoundWitnessTime()
                    } catch {
                    // todo handle error
                }
            }
    }

    fun onBoundWitnessStart() {}
    fun onBoundWitnessEndFailure() {}
    fun onBoundWitnessDiscovered(boundWitness: XyoBoundWitness) {}
    fun onBoundWitnessEndSuccess(boundWitness: XyoBoundWitness) {
        process()
    }

}*/