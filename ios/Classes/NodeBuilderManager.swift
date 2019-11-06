//
//  NodeBuilderManager.swift
//  sdk-xyo-flutter
//
import sdk_xyo_swift
import sdk_core_swift

internal class NodeBuilderManager {
  var xyoNode : XyoNode?
  var builder: XyoNodeBuilder? = XyoNodeBuilder()
  public static let instance = NodeBuilderManager()

  init() {
    builder?.setBoundWitnessDelegate(self)
  }

  func build() -> String {
    do {
      xyoNode = try builder?.build()
      builder = nil
    }
    catch {
      print("Caught Error Building Xyo Node\(error)")
    }
    return("Built")
  }
  
  func setListening(on: Bool) {
    let ble = xyoNode?.networks["ble"] as? XyoBleNetwork
    ble?.server?.listen = on
    // stop server listening if listening on
    if on && ble?.client?.scan == true {
      ble?.client?.scan = false
    }
  }

  func setScanning(on: Bool) {
    let ble = xyoNode?.networks["ble"] as? XyoBleNetwork
    ble?.client?.scan = on
    // stop server listening if you want to start scanning as client
    if on && ble?.server?.listen == true {
      ble?.server?.listen = false
    }
  }
  
  func setBridging(on: Bool) {
    let ble = xyoNode?.networks["ble"] as? XyoBleNetwork

    let tcp = xyoNode?.networks["tcpip"] as? XyoTcpipNetwork

    if ble?.client?.scan == true {
      tcp?.client?.autoBridge = on
    } else {
      tcp?.server?.autoBridge = on
    }
  }
}


extension NodeBuilderManager : BoundWitnessDelegate {
  func boundWitness(started withDeviceId: String) {
    print("Started BW with \(withDeviceId)")
  }
  
  func boundWitness(completed withDeviceId: String, withBoundWitness: XyoBoundWitness?) {
    print("Completed BW with \(withDeviceId)")
    
  }
  
  func boundWitness(failed withDeviceId: String?, withError: XyoError) {
    print("Errored BW with \(String(describing: withDeviceId)) \(String(describing: withError))")
  }
  
  func getPayloadData() -> [UInt8]? {
    //TODO 
    return nil
  }
}
