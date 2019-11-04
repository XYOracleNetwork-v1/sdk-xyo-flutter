import network.xyo.sdkcorekotlin.boundWitness.XyoBoundWitness
import network.xyo.sdkcorekotlin.boundWitness.XyoBoundWitnessUtil
import network.xyo.sdkcorekotlin.schemas.XyoSchemas
import network.xyo.sdkobjectmodelkotlin.structure.XyoIterableStructure
import network.xyo.sdkobjectmodelkotlin.structure.XyoObjectStructure
import unsigned.shl

@kotlin.ExperimentalUnsignedTypes
class XyoHumanName {
    companion object {
        fun getHumanName (boundWitness: XyoBoundWitness, publicKey: XyoObjectStructure?): String {
            try {
                val numberOfParties = boundWitness.numberOfParties ?: return "Invalid"

                if (numberOfParties == 1) {
                    return handleSinglePartyBlock(boundWitness, publicKey)
                }

                return handleMultiPartyBlock(boundWitness, publicKey)
            } catch(ex: Exception) {
                return "Invalid"
            }
        }

        private fun handleSinglePartyBlock (boundWitness: XyoBoundWitness, publicKey: XyoObjectStructure?): String
        {
            val indexOfParty = getIndexForParty(boundWitness, 0)

            if (indexOfParty == 0U) {
                return "Genesis Block!"
            }

            return "Self signed block"
        }

        private fun handleMultiPartyBlock (boundWitness: XyoBoundWitness, publicKey: XyoObjectStructure?): String {
            val safePublicKey = publicKey ?: return "Regular Interaction"

            val indexOfSelf = XyoBoundWitnessUtil.getPartyNumberFromPublicKey(boundWitness, safePublicKey)
                    ?: return "Regular Interaction"

            val numberOfBlocksSent = getNumberOfBridgeBlocksForParty(boundWitness, indexOfSelf)
            if (numberOfBlocksSent == null) {
                val inverse = getInverse(indexOfSelf)
                val numberOfBlocksReceived = getNumberOfBridgeBlocksForParty(boundWitness, inverse) ?: return "Regular Interaction"
                return "Received $numberOfBlocksReceived blocks"
            }

            return "Sent $numberOfBlocksSent blocks"
        }

        private fun getInverse (index: Int): Int
        {
            if (index == 0) {
                return 1
            }

            return 0
        }

        private fun getIndexForParty (boundWitness: XyoBoundWitness, fetterIndex: Int): UInt
        {
            val fetter = boundWitness.getFetterOfParty(fetterIndex) ?: throw Error()

            val index = fetter.get(XyoSchemas.INDEX.id).first()

            val valueOfIndex = index.valueCopy.toUByteArray()

            when (valueOfIndex.size) {
                1 -> return valueOfIndex[0].toUInt()
                2 -> return index.valueCopy[0].toUInt() * 256U + index.valueCopy[1].toUInt()
                4 -> return index.valueCopy[0].toUInt() * 16777216U + index.valueCopy[1].toUInt() * 65536U + index.valueCopy[2].toUInt() * 256U + index.valueCopy[3].toUInt()
                else ->
                    // wrong index size if here
                    throw Error()
            }
        }

        private fun getNumberOfBridgeBlocksForParty (boundWitness: XyoBoundWitness, index: Int): UInt?
        {
            val fetter = boundWitness.getFetterOfParty(index) ?: throw Error()

            val hashSet = fetter.get(XyoSchemas.BRIDGE_HASH_SET.id).first() as? XyoIterableStructure ?: return null

            return hashSet.count.toUInt()
        }
    }
}
