import XyBleSdk
import sdk_xyobleinterface_swift

class XyoDeviceChannel: XyoBaseChannel {
  
  let bridgeManager: BridgeManager;
  
  private let onEnterChannel: FlutterEventChannel
  private let onExitChannel: FlutterEventChannel
  private let onDetectChannel: FlutterEventChannel
  private let onStatusChannel: FlutterEventChannel
  private let onConnectionChannel: FlutterEventChannel
  
  private let onEnter = EventStreamHandler()
  private let onExit = EventStreamHandler()
  private let onDetect = EventStreamHandler()
  private let onStatus = EventStreamHandler()
  
  override
  init(registrar: FlutterPluginRegistrar, name: String) {
    bridgeManager = BridgeManager.instance
    XYBluetoothManager.setup()
    
    onEnterChannel = FlutterEventChannel(name:"\(name)OnEnter", binaryMessenger: registrar.messenger())
    
    onExitChannel = FlutterEventChannel(name:"\(name)OnExit", binaryMessenger: registrar.messenger())
    
    onDetectChannel = FlutterEventChannel(name:"\(name)OnDetect", binaryMessenger: registrar.messenger())
    
    onStatusChannel = FlutterEventChannel(name:"\(name)OnStatus", binaryMessenger: registrar.messenger())
    
    onConnectionChannel = FlutterEventChannel(name:"\(name)OnConnection", binaryMessenger: registrar.messenger())

    super.init(registrar: registrar, name: name)
    
    onEnterChannel.setStreamHandler(onEnter)
    onExitChannel.setStreamHandler(onExit)
    onDetectChannel.setStreamHandler(onDetect)
    onStatusChannel.setStreamHandler(onStatus)
    
    XyoBluetoothDevice.family.enable(enable: true)
    XyoBluetoothDeviceCreator.enable(enable: true)
    XyoSentinelXDeviceCreator().enable(enable: true)
    
    XYBluetoothManager.scanner.setDelegate(self, key: "DeviceChannel")
  }
  
  override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
    case "start":
      start(call, result:result)
      break
    case "stop":
      stop(call, result:result)
      break
    case "gattSingle":
      gattSingle(call, result:result)
      break
    case "gattGroup":
      gattGroup(call, result:result)
      break
    case "gattList":
      gattList(call, result:result)
      break
    case "getStatus":
      reportStatus(XYBluetoothManager.scanner.currentStatus)
      break;
    case "getPublicKey":
      getPublicKey(call, result:result)
      break;
    default:
      super.handle(call, result:result)
      break
    }
  }
  
  private func start(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    XYBluetoothManager.scanner.start(mode: XYSmartScanMode.foreground)
    result(true)
  }
  
  private func stop(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    XYBluetoothManager.scanner.stop()
    result(true)
  }
  
  private func gattSingle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    GattSingleRequest.process(arguments: call.arguments, result: result)
  }
  
  private func gattGroup(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    GattGroupRequest.process(arguments: call.arguments, result: result)
  }
  
  private func gattList(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    GattGroupRequest.process(arguments: call.arguments, result: result)
  }
  
  private func getPublicKey(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("")
  }
  
  func reportStatus(_ status: XYSmartScanStatus) {
    var statusString: Any
    switch(status) {
    case XYSmartScanStatus.none:
      statusString = "none"
      break
    case XYSmartScanStatus.enabled:
      statusString = "enabled"
      break
    case XYSmartScanStatus.backgroundLocationDisabled:
      statusString = "locationDisabled"
      break
    case XYSmartScanStatus.bluetoothDisabled:
      statusString = "bluetoothDisabled"
      break
    case XYSmartScanStatus.bluetoothUnavailable:
      statusString = "bluetoothUnavailable"
      break
    case XYSmartScanStatus.locationDisabled:
      statusString = "locationDisabled"
      break
    }
    onStatus.send(event: statusString)
  }
}

extension XyoDeviceChannel : XYSmartScanDelegate {
  
  func smartScan(status: XYSmartScanStatus) {
    reportStatus(status)
  }
  
  func smartScan(location: XYLocationCoordinate2D) {}
  func smartScan(detected device: XYBluetoothDevice, rssi: Int, family: XYDeviceFamily) {
    let buffer = device.toBuffer
    onDetect.send(event: try! buffer.serializedData())
  }
  func smartScan(detected devices: [XYBluetoothDevice], family: XYDeviceFamily) {
    devices.forEach { device in
      self.smartScan(detected: device, rssi: device.rssi, family: family)
    }
  }
  func smartScan(entered device: XYBluetoothDevice) {
    let buffer = device.toBuffer
    onEnter.send(event: try! buffer.serializedData())
  }
  func smartScan(exiting device:XYBluetoothDevice) {}
  func smartScan(exited device: XYBluetoothDevice) {
    let buffer = device.toBuffer
    onExit.send(event: try! buffer.serializedData())
  }
}
