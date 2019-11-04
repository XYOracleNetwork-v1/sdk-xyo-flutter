import sdk_core_swift
import sdk_bletcpbridge_swift
import sdk_objectmodel_swift
import sdk_xyobleinterface_swift
import XyBleSdk

class XyoBridgeChannel: XyoNodeChannel {
    
  override
  init(registrar: FlutterPluginRegistrar, name: String) {
    super.init(registrar: registrar, name: name)
    BridgeManager.instance.restoreAndInitBridge()
    BridgeManager.instance.bridge.addListener(key: "BridgeChannel", listener: self)
    XYBluetoothManager.setup()
  }

  override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    do {
      switch (call.method) {
      case "setArchivists":
        setArchivists(call, result: result)
        break
      case "getBlockCount":
        try getBlockCount(call, result: result)
        break
      case "getLastBlock":
        getLastBlock(call, result: result)
        break
      case "getBlocks":
        getBlocks(call, result: result)
        break
      case "selfSign":
        selfSign(call, result: result)
        break
      case "initiateBoundWitness":
        initiateBoundWitness(call, result: result)
        break
      default:
        super.handle(call, result: result)
      }
    } catch {
        result(FlutterError(code: "Error", message: "Unexpected Error", details:"\(error)"))
    }
  }

  override func onStart() -> String {
    XYBluetoothManager.start()
    status = XyoNodeChannel.STATUS_STARTED
    return status
  }

  override func onStop() -> String {
    XYBluetoothManager.stop()
    status = XyoNodeChannel.STATUS_STOPPED
    return status
  }

  private func setArchivists(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(FlutterMethodNotImplemented)
  }

  private func selfSign(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    do {
        try BridgeManager.instance.bridge.selfSignOriginChain()
    } catch {
        result(FlutterError(code: "Exception", message: "Excception", details:""))
    }

    //now that we have a new last block
    getLastBlock(call, result:result)
  }
  
  private func findDevice(_ deviceId: String) -> XyoBluetoothDevice? {
    var foundDevice: XyoBluetoothDevice?
    XYBluetoothDeviceFactory.devices.forEach { device in
      if (device.id == deviceId) {
        foundDevice = device as? XyoBluetoothDevice
      }
    }
    return foundDevice
  }
  
  private func initiateBoundWitness(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    guard
      let arguments = call.arguments as? Dictionary<String, Any>,
      let deviceId = arguments["deviceId"] as? String
    else {
      result(FlutterError(code: "Exception", message: "Excception", details:"DeviceId Invalid Type"))
      return
    }
    
    guard
      let device = findDevice(deviceId)
    else {
        result(FlutterError(code: "Exception", message: "Excception", details:"Device not Found"))
        return
    }
    
    BridgeManager.instance.bridge.collect(bleDevice: device)
    result(true)
  }

  private func getBlockCount(_ call: FlutterMethodCall, result: @escaping FlutterResult) throws {
    let hashes = BridgeManager.instance.blockRepo.getAllOriginBlockHashes()
    var hashObjects = [XyoObjectStructure]()
    
    let it = try! hashes.getNewIterator()
    
    while (try it.hasNext()) {
        let item = try it.next()
        hashObjects.append(item)
    }
    
    let models = hashesToBoundWitnesses(hashes: hashObjects)
    result(models.count)
  }

  private func getLastBlockData() -> DeviceBoundWitness? {
    guard let prevHash = BridgeManager.instance.stateRepo.getPreviousHash() else {
        return nil
    }
    
    
    let structure = XyoIterableStructure(value: prevHash.getBuffer())
    guard let hash = try? structure.get(index: 0) else {
        return nil
    }
    
    
    var boundWitnesses = hashesToBoundWitnesses(hashes: [hash])
    return boundWitnesses[0]
  }

  private func getLastBlock(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let lastModel: DeviceBoundWitness? = getLastBlockData()
    result(try! lastModel?.serializedData())
  }
  
  private func getBlocksData() -> DeviceBoundWitnessList? {
    let hashes = BridgeManager.instance.blockRepo.getAllOriginBlockHashes()
    guard let iterator = try? hashes.getNewIterator() else {return nil}
    
    var list = [XyoObjectStructure]()
    
    while(try! iterator.hasNext()) {
      list.append(try! iterator.next())
    }
    
    let boundWitnesseses = hashesToBoundWitnesses(hashes: list)
    
    var bwList = DeviceBoundWitnessList()
    boundWitnesseses.forEach { item in
      bwList.boundWitnesses.append(item)
    }
    
    return bwList
  }
  
  private func getBlocks(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let model: DeviceBoundWitnessList? = getBlocksData()
    result(try! model?.serializedData())
  }

  private func hashesToBoundWitnesses(hashes: [XyoObjectStructure]) -> [DeviceBoundWitness] {
    var models = [DeviceBoundWitness]()

    hashes.forEach { hash in
      let model = InteractionModel(hash.getBuffer().toByteArray(), date: Date(), linked: true)
      models.append(model.toBuffer)
    }

    return models
  }
}

extension XyoBridgeChannel: XyoNodeListener {
  public func onBoundWitnessStart() {}
  public func onBoundWitnessEndFailure() {}
  public func onBoundWitnessDiscovered(boundWitness: XyoBoundWitness) {}
  public func onBoundWitnessEndSuccess(boundWitness: XyoBoundWitness) {
    let lastBlock = getLastBlockData()!
    events.send(event: try! lastBlock.serializedData())
  }
}
