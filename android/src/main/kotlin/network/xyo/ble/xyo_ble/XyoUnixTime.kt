package network.xyo.ble.xyo_ble

import network.xyo.sdkobjectmodelkotlin.structure.XyoObjectStructure
import network.xyo.sdkcorekotlin.heuristics.XyoHeuristicGetter
import network.xyo.sdkcorekotlin.schemas.XyoSchemas
import java.nio.ByteBuffer
import java.util.*

class XyoUnixTime: XyoHeuristicGetter {
    override fun getHeuristic(): XyoObjectStructure? {
        val time: Long = Date().time

        return XyoObjectStructure.newInstance(XyoSchemas.UNIX_TIME, ByteBuffer.allocate(8).putLong(time).array())
    }
}