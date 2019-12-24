import 'package:sdk_xyo_flutter/sdk_xyo_flutter.dart';
import 'package:sdk_xyo_flutter/sdk/XyoBoundWitnessTarget.dart';
import 'package:sdk_xyo_flutter/sdk/XyoNetwork.dart';

class XyoClient extends XyoBoundWitnessTarget {
  bool isScanning;
  bool isAutoBoundWitnessing;

  XyoClient(XyoNetworkType network) : super(network);

  bool get autoBoundWitness {
    return isAutoBoundWitnessing;
  }

  bool get scan {
    return isScanning;
  }

  set scan(bool scan) {
    isScanning = scan;
    XyoSdkDartBridge.instance.setScanning(scan);
  }

  set autoBoundWitness(bool autoBoundWitness) {
    isAutoBoundWitnessing = autoBoundWitness;
    XyoSdkDartBridge.instance
        .setAutoBoundWitnessing(this is XyoClient, autoBoundWitness);
  }
}

class XyoBleClient extends XyoClient {
  XyoBleClient(XyoNetworkType network) : super(network);
}

class XyoTcpClient extends XyoClient {
  XyoTcpClient(XyoNetworkType network) : super(network);
}
