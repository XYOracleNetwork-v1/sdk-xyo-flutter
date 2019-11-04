class EventStreamHandler: NSObject, FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    private var eventSink: FlutterEventSink?


    func send(event: Any) {
        eventSink?(event)
    }
}

class XyoBaseChannel: FlutterMethodChannel, FlutterPlugin {
    static func register(with registrar: FlutterPluginRegistrar) {
        //we do nothing here since this is only so that the addMethodCallDelegate will be ok with it
    }
    
    
    init(registrar: FlutterPluginRegistrar, name: String) {
        methodChannel = FlutterMethodChannel(name:name, binaryMessenger: registrar.messenger())
        eventChannel = FlutterEventChannel(name:"\(name)events", binaryMessenger: registrar.messenger())
        super.init()
        registrar.addMethodCallDelegate(self, channel: methodChannel)
        eventChannel.setStreamHandler(events)
    }

    var events = EventStreamHandler()
    private var methodChannel: FlutterMethodChannel
    private var eventChannel: FlutterEventChannel
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}
