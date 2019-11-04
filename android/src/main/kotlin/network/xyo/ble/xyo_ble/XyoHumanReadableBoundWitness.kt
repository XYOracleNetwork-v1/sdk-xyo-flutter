package network.xyo.ble.xyo_ble

import android.annotation.SuppressLint
import network.xyo.sdkcorekotlin.boundWitness.XyoBoundWitness
import network.xyo.sdkcorekotlin.boundWitness.XyoBoundWitnessUtil
import network.xyo.sdkcorekotlin.schemas.XyoSchemas
import network.xyo.sdkobjectmodelkotlin.exceptions.XyoObjectException
import network.xyo.sdkobjectmodelkotlin.structure.XyoIterableStructure
import network.xyo.sdkobjectmodelkotlin.structure.XyoObjectStructure
import java.nio.ByteBuffer
import java.util.*

@ExperimentalUnsignedTypes
object HumanReadableBoundWitness {
    @SuppressLint("UseSparseArrays") //SparseArrays cannot use Byte as key
    private val heuristicResolvers = HashMap<Byte, HeuristicResolver>()
    private const val HUMAN_NAME_INDEX_ID = 0x62.toByte()

    interface HeuristicResolver {
        fun getKey(partyIndex: Int): String
        fun getStringValue(item: XyoObjectStructure, partyIndex: Int): String
    }

    init {
        heuristicResolvers[XyoSchemas.INDEX.id] = IndexResolver
        heuristicResolvers[XyoSchemas.RSSI.id] = RssiResolver
        heuristicResolvers[XyoSchemas.GPS.id] = LocationResolver
        heuristicResolvers[XyoSchemas.UNIX_TIME.id] = TimeResolver
    }

    // todo find way to localise strings with flutter
    fun getHumanBoundWitnessName(boundWitness: XyoBoundWitness, publicKey: ByteArray?): String {
        if (boundWitness.numberOfParties == 1) {
            if (getIndexForParty(boundWitness, 0) == 0) {
                return "First block!"
            }
            return "Self signed block"
        }

        if (publicKey != null) {
            val partyNumber = XyoBoundWitnessUtil.getPartyNumberFromPublicKey(boundWitness, XyoObjectStructure.wrap(publicKey))
                    ?: 0
            val numberOfBlocksBridged = getNumberOfBridgeBlocks(boundWitness, partyNumber) ?: 0

            if (numberOfBlocksBridged > 0) {
                return if (numberOfBlocksBridged == 1) {
                    return "Sent 1 block"
                } else {
                    String.format("Sent %n blocks", numberOfBlocksBridged)
                }
            }

            val numberOfBlocksReceived = getNumberOfBridgeBlocks(boundWitness, if (partyNumber == 0) {
                1
            } else {
                0
            }) ?: 0

            if (numberOfBlocksReceived > 0) {
                return if (numberOfBlocksReceived == 1) {
                    return "Found 1 block"
                } else {
                    String.format("Found %n blocks", numberOfBlocksReceived)
                }
            }
        }

        return "Regular interaction"
    }

    private fun getIndexForParty(boundWitness: XyoBoundWitness, partyIndex: Int): Int? {
        val fetter = boundWitness.getFetterOfParty(partyIndex) ?: return null
        val index = fetter[XyoSchemas.INDEX.id].firstOrNull() ?: return null

        when (index.valueCopy.size) {
            1 -> return ByteBuffer.wrap(index.valueCopy)[0].toUByte().toInt()
            2 -> return ByteBuffer.wrap(index.valueCopy).short.toUShort().toInt()
            4 -> return ByteBuffer.wrap(index.valueCopy).int.toUInt().toInt()
        }

        throw XyoObjectException("Not a valid index!")
    }

    private fun getNumberOfBridgeBlocks(boundWitness: XyoBoundWitness, partyIndex: Int): Int? {
        val fetter = boundWitness.getFetterOfParty(partyIndex) ?: return null
        val hashSet = fetter[XyoSchemas.BRIDGE_HASH_SET.id].firstOrNull() as? XyoIterableStructure
                ?: return null

        return hashSet.count
    }

    fun getAllPrimaryPublicKeys(boundWitness: XyoBoundWitness): Array<ByteArray?> {
        val returnPublicKeys = ArrayList<ByteArray?>()
        val numberOfParties = boundWitness.numberOfParties ?: return arrayOf()

        for (i in 0 until numberOfParties) {
            val fetterOfParty = boundWitness.getFetterOfParty(i) ?: return arrayOf()
            val keySet = fetterOfParty[XyoSchemas.KEY_SET.id].firstOrNull()

            if (keySet is XyoIterableStructure && keySet.count > 0) {
                returnPublicKeys.add(keySet[0].bytesCopy)
            } else {
                returnPublicKeys.add(null)
            }
        }

        return returnPublicKeys.toTypedArray()
    }

    fun getAllReadableNames(boundWitness: XyoBoundWitness): Array<String?> {
        val returnNames = ArrayList<String?>()
        val numberOfParties = boundWitness.numberOfParties ?: return arrayOf()

        for (i in 0 until numberOfParties) {
            val fetterOfParty = boundWitness.getFetterOfParty(i) ?: return arrayOf()
            val humanNameBytes = fetterOfParty[HUMAN_NAME_INDEX_ID].firstOrNull()?.valueCopy

            if (humanNameBytes != null) {
                returnNames.add(String(humanNameBytes))
            } else {
                returnNames.add(null)
            }
        }

        return returnNames.toTypedArray()
    }

    fun getAllHumanHuerestics(boundWitness: XyoBoundWitness): LinkedHashMap<String, String> {
        val returnPairs = LinkedHashMap<String, String>()
        val numberOfParties = boundWitness.numberOfParties ?: return linkedMapOf()

        for (i in 0 until numberOfParties) {
            val fetterOfParty = boundWitness.getFetterOfParty(i) ?: return linkedMapOf()

            for (item in fetterOfParty.iterator) {
                val resolver = heuristicResolvers[item.schema.id]


                if (resolver != null) {
                    try {
                        returnPairs[resolver.getKey(i)] = resolver.getStringValue(item, i)
                    } catch (e: XyoObjectException) {
                        // do not show anything if there is a byte pacing error
                    }

                }

            }
        }

        return returnPairs
    }

    object IndexResolver : HeuristicResolver {
        override fun getKey(partyIndex: Int): String {
            return "Index $partyIndex"
        }

        override fun getStringValue(item: XyoObjectStructure, partyIndex: Int): String {
            val valueOfIndex = item.valueCopy
            when (valueOfIndex.size) {
                1 -> return ByteBuffer.wrap(item.valueCopy)[0].toUByte().toString()
                2 -> return ByteBuffer.wrap(item.valueCopy).short.toUShort().toString()
                4 -> return ByteBuffer.wrap(item.valueCopy).int.toUInt().toString()
                8 -> return ByteBuffer.wrap(item.valueCopy).long.toULong().toString()
            }

            throw XyoObjectException("Not a valid index!")
        }
    }

    object RssiResolver : HeuristicResolver {
        override fun getKey(partyIndex: Int): String {
            return "RSSI $partyIndex"
        }

        override fun getStringValue(item: XyoObjectStructure, partyIndex: Int): String {
            if (item.valueCopy.isEmpty()) {
                throw XyoObjectException("Invalid RSSI!")
            }

            return item.valueCopy[0].toString()
        }
    }

    object LocationResolver : HeuristicResolver {

        override fun getKey(partyIndex: Int): String {
            return "LAT/LNG $partyIndex"
        }

        override fun getStringValue(item: XyoObjectStructure, partyIndex: Int): String {
            if (item is XyoIterableStructure) {
                val lat = item[XyoSchemas.LAT.id].firstOrNull()?.valueCopy ?: return "Invalid LAT"
                val lng = item[XyoSchemas.LNG.id].firstOrNull()?.valueCopy ?: return "Invalid LNG"

                if (lat.size != 8 || lng.size != 8) {
                    return "Invalid"
                }


                val numLat = ByteBuffer.wrap(lat).double
                val numLng = ByteBuffer.wrap(lng).double


                return String.format("%.3f, %.3f", numLat, numLng)
            }

            return "Invalid GPS"
        }
    }

    object TimeResolver : HeuristicResolver {
        override fun getKey(partyIndex: Int): String {
            return "Time $partyIndex"
        }

        override fun getStringValue(item: XyoObjectStructure, partyIndex: Int): String {
            val value = item.valueCopy

            if (value.size != 8) {
                return "Invalid"
            }

            val unixTime = ByteBuffer.wrap(value).long
            return unixTime.toString()
        }
    }

}