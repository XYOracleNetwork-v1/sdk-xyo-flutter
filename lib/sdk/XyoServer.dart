import 'package:sdk_xyo_flutter/sdk/XyoBoundWitnessTarget.dart';

import '../XyoSdkDartBridge.dart';

class XyoBleServer extends XyoServer {}

class XyoTcpServer extends XyoServer {}

class XyoServer extends XyoBoundWitnessTarget {
  bool isListening;
  bool get listen {
    return isListening;
  }

  set listen(bool listen) {
    isListening = listen;
    XyoSdkDartBridge.instance.setListening(listen);
  }
}
