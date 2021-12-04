import 'package:sdk_xyo_flutter/main.dart';
import 'package:sdk_xyo_flutter/sdk/XyoBoundWitnessTarget.dart';
import 'package:sdk_xyo_flutter/sdk/XyoNetwork.dart';

class XyoClient extends XyoBoundWitnessTarget {
  bool isScanning = false;
  bool isAutoBoundWitnessing = false;

  XyoClient(XyoNetworkType network) : super(network);

  bool get autoBoundWitness {
    return isAutoBoundWitnessing;
  }

  bool get scan {
    return isScanning;
  }

  set scan(bool scan) {
    print("Xyo Client scan $scan");
    isScanning = scan;
    XyoClientFlutterBridge.instance.setScanning(scan);
    notifyListeners();
  }

  set autoBoundWitness(bool autoBoundWitness) {
    isAutoBoundWitnessing = autoBoundWitness;
    XyoClientFlutterBridge.instance.setAutoBoundWitnessing(autoBoundWitness);
    notifyListeners();
  }

  set acceptBridging(bool acceptBridging) {
    isAcceptingBridging = acceptBridging;
    XyoClientFlutterBridge.instance.setAcceptBridging(acceptBridging);
    notifyListeners();
  }
}

class XyoBleClient extends XyoClient {
  XyoBleClient(XyoNetworkType network) : super(network);
}

class XyoTcpClient extends XyoClient {
  XyoTcpClient(XyoNetworkType network) : super(network);
}
