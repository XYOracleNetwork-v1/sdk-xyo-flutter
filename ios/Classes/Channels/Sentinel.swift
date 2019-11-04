class XyoSentinelChannel: XyoNodeChannel {
    
    override
    init(registrar: FlutterPluginRegistrar, name: String) {
        super.init(registrar: registrar, name: name)
        XYBluetoothManager.setup()
    }
    
    override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        default:
            super.handle(call, result:result)
        }
    }
}
