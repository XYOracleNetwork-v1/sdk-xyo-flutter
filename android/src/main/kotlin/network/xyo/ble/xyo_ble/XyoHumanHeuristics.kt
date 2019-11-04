package network.xyo.ble.xyo_ble

import android.util.SparseArray
import network.xyo.sdkcorekotlin.boundWitness.XyoBoundWitness
import network.xyo.sdkcorekotlin.schemas.XyoSchemas
import network.xyo.sdkobjectmodelkotlin.structure.XyoIterableStructure
import network.xyo.sdkobjectmodelkotlin.structure.XyoObjectStructure
import java.nio.ByteBuffer
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.HashMap

interface XyoHumanHeuristicResolver {
    fun getHumanKey (partyIndex: Int): String
    fun getHumanName (obj: XyoObjectStructure, partyIndex: Int): String?
}

@kotlin.ExperimentalUnsignedTypes
class XyoHumanHeuristics {
    fun getHumanHeuristics(boundWitness: XyoBoundWitness): Map<String, String> {
        try {
            val returnArray = HashMap<String, String>()
            val numberOfParties = boundWitness.numberOfParties ?: return emptyMap()

                if (numberOfParties == 0) {
                    return emptyMap()
                }

                for (i in 0 until numberOfParties) {
                    val it = boundWitness.getFetterOfParty(i)?.iterator ?: return emptyMap()

                    while (it.hasNext()) {
                        val payloadItem = it.next()
                        val item = handleSinglePayloadItem(payloadItem, i) ?: return emptyMap()
                        return mapOf(Pair(item.first, item.second))
                    }
                }

                return returnArray
            } catch(ex: Exception) {
                return emptyMap()
            }
        }

    companion object {
        val resolvers = SparseArray<XyoHumanHeuristicResolver>()
        private fun handleSinglePayloadItem (item: XyoObjectStructure, index: Int): Pair<String, String>? {
            val idOfPayloadItem = item.schema.id.toInt()
            val resolver: XyoHumanHeuristicResolver = resolvers[idOfPayloadItem] ?: return null

            val value = resolver.getHumanName(item, index) ?: return null

            val key = resolver.getHumanKey(index)

            return Pair(key, value)
        }
    }
}

class RssiResolver: XyoHumanHeuristicResolver {
    override fun getHumanKey(partyIndex: Int): String {
        return "RSSI $partyIndex"
    }

    override fun getHumanName (obj: XyoObjectStructure, partyIndex: Int): String? {
        val objectValue = obj.valueCopy

        if (objectValue.isNotEmpty()) {
            return "${objectValue[0].toInt()}"
        }

        return null
    }
}

class TimeResolver: XyoHumanHeuristicResolver {
    override fun getHumanKey(partyIndex: Int): String {
        return "Time $partyIndex"
    }

    override fun getHumanName (obj: XyoObjectStructure, partyIndex: Int): String? {
        val objectValue = obj.valueCopy

        if (objectValue.size != 8) {
            return null
        }

        val mills = ByteBuffer.wrap(objectValue).getLong(0)

        return SimpleDateFormat("MM-dd-yyyy HH:mm").format(Date(mills))
    }
}

class GpsResolver: XyoHumanHeuristicResolver {
    override fun getHumanKey(partyIndex: Int): String {
        return "GPS $partyIndex"
    }

    override fun getHumanName (obj: XyoObjectStructure, partyIndex: Int): String? {
        val gps = obj as? XyoIterableStructure ?: return null

        val lat = gps.get(XyoSchemas.LAT.id).first().valueCopy
        val lng = gps.get(XyoSchemas.LNG.id).first().valueCopy

        if (lng.size != 8 || lat.size != 8) {
            return null
        }

        val latNumData = Double.fromBits(ByteBuffer.wrap(lat).getLong(0))
        val lngNumData = Double.fromBits(ByteBuffer.wrap(lng).getLong(0))

        return "$latNumData, $lngNumData"

    }
}

