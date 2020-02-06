import 'package:sdk_xyo_flutter/sdk/XyoBoundWitnessTarget.dart';
import 'package:sdk_xyo_flutter/sdk/XyoNetwork.dart';
import 'package:sdk_xyo_flutter/main.dart';

class XyoBleServer extends XyoServer {
  XyoBleServer(XyoNetworkType network) : super(network);
}

class XyoTcpServer extends XyoServer {
  XyoTcpServer(XyoNetworkType network) : super(network);
}

class XyoServer extends XyoBoundWitnessTarget {
  bool isListening;

  XyoServer(XyoNetworkType network) : super(network) {
    _initVars();
  }

  _initVars() async {
    isListening = await XyoServerFlutterBridge.instance.getListening();
  }

  bool get listen {
    return isListening;
  }

  set listen(bool listen) {
    print("Listen set $listen");
    isListening = listen;

    XyoServerFlutterBridge.instance.setListening(listen);
  }
}
