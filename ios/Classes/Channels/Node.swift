class XyoNodeChannel: XyoBaseChannel {
    
    override
    init(registrar: FlutterPluginRegistrar, name: String) {
        super.init(registrar: registrar, name: name)
    }
    
    static var STATUS_STARTED = "Started"
    static var STATUS_STOPPED = "Stopped"

    var status = STATUS_STOPPED

  override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
    case "start":
        start(call, result:result)
        break
    case "stop":
        stop(call, result:result)
        break
    case "getPublicKey":
        getPublicKey(call, result:result)
        break
    case "getStatus":
        getStatus(call, result:result)
        break
    default:
        super.handle(call, result:result)
        break;
    }
  }
    
    //this should return the new running state
    func onStart() -> String {
        return XyoNodeChannel.STATUS_STARTED
    }

    //this should return the new running state
    func onStop() -> String {
        return XyoNodeChannel.STATUS_STOPPED
    }

  private func getStatus(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(status)
  }

  private func start(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    status = onStart()
    result(status)
  }

  private func stop(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    status = onStop()
    result(status)
  }

  private func getPublicKey(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let pk = BridgeManager.instance.primaryPublicKeyAsString
    result(pk)
  }
}
