//
//  BluetoothManager.swift
//  xyo_ble
//
//  Created by Darren Sutherland on 6/26/19.
//

import XyBleSdk
import sdk_xyobleinterface_swift
import sdk_core_swift

class XYBluetoothManager {

//    static let defaultArchivist =
//        XYMyAttachedArchivistsQuery.QueryModel(
//            id: "XYO",
//            name: "XYO",
//            dns: "alpha-peers.xyo.network",
//            port: 11001)

    fileprivate static let server = XyoBluetoothServer()
    static let scanner: XYSmartScan = XYSmartScan.instance

    // Called once the user has logged in
    class func setup() {
        // Clear archivists if new user logs in
        BridgeManager.instance.bridge.archivists.removeAll()
//
//        // TOOD update adding archivists
//        let dns = "alpha-peers.xyo.network"
//        let port = 11001
//
//        BridgeManager.instance.bridge.archivists["\(dns):\(port)"] = XyoTcpPeer(ip: dns, port: UInt32(port))
//
//        // Add archivists
////        XYQueryCache.sharedInstance().myAttachedArchivists.queryData.queryModels.forEach { data in
////            if let dns = data.dns, let port = data.boundWitnessServerPort {
////                XYBridgeManager.instance.bridge.archivists["\(dns):\(port)"] = XyoTcpPeer(ip: dns, port: UInt32(port))
////            }
////        }
    }

    class func start() {
        // Enable devices for scanning
        //XyoBluetoothDevice.family.enable(enable: true)
        XyoBluetoothDeviceCreator.enable(enable: true)
      XY4BluetoothDevice.family.enable(enable: true)
      XY4BluetoothDeviceCreator.enable(enable: true)
        XyoSentinelXDeviceCreator().enable(enable: true)
      XyoBridgeXDeviceCreator().enable(enable: true)
      XyoAndroidXDeviceCreator().enable(enable: true)
      XyoIosXDeviceCreator().enable(enable: true)

        self.scanner.setDelegate(BridgeManager.instance.bridge, key: "BRIDGE_PRIMARY")

        self.scanner.start(mode: .foreground)
        self.server.start(listener: BridgeManager.instance.bridge)
    }

    class func stop() {
        self.scanner.stop()
        self.server.stop()
    }

    class func enableBoundWitnesses(_ enable: Bool) {
        BridgeManager.instance.bridge.enableBoundWitnesses(enable: enable)
    }

    static var subscribeKey: UUID?
    class func listenForXy4(_ handler: @escaping (XYBluetoothDevice) -> Void) {
        XY4BluetoothDevice.family.enable(enable: true)
        XY4BluetoothDeviceCreator.enable(enable: true)
        XYLocation.instance.startRanging(for: XY4BluetoothDevice.family)

        self.subscribeKey = XYFinderDeviceEventManager.subscribe(to: [.buttonPressed]) { event in
            handler(event.device)
        }
    }

    class func stopSubscribingForXy4() {
        XYFinderDeviceEventManager.unsubscribe(to: [.buttonPressed], referenceKey: self.subscribeKey)
    }

    class func stopListeningForXy4() {
        self.stopSubscribingForXy4()
        if let device = XYBluetoothDeviceFactory.build(from: XY4BluetoothDevice.family) {
            XYLocation.instance.stopRanging(for: device)
            XY4BluetoothDevice.family.enable(enable: false)
            XY4BluetoothDeviceCreator.enable(enable: false)
        }
    }

}

// MARK:
extension XYBluetoothManager {

    class func addArchivists(archivists: Any) {
        guard
            let map = archivists as? Dictionary<String, Any>,
            let list = map["archivists"] as? Array<Dictionary<String, Any>>
            else { return }

        for archivist in list {
            guard
                let dns = archivist["dns"] as? String,
                let port = archivist["port"] as? Int
                else { continue }

            BridgeManager.instance.bridge.archivists["\(dns):\(port)"] = XyoTcpPeer(ip: dns, port: UInt32(port))
        }
    }

}
