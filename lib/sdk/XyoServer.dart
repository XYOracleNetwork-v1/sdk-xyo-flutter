import 'package:sdk_xyo_flutter/sdk/XyoBoundWitnessTarget.dart';
import 'package:sdk_xyo_flutter/sdk/XyoNetwork.dart';

import '../XyoSdkDartBridge.dart';

class XyoBleServer extends XyoServer {
  XyoBleServer(XyoNetworkType network) : super(network);
}

class XyoTcpServer extends XyoServer {
  XyoTcpServer(XyoNetworkType network) : super(network);
}

class XyoServer extends XyoBoundWitnessTarget {
  bool isListening;

  XyoServer(XyoNetworkType network) : super(network);
  bool get listen {
    return isListening;
  }

  set listen(bool listen) {
    isListening = listen;
    XyoSdkDartBridge.instance.setListening(listen);
  }
}
