import 'package:sdk_xyo_flutter/XyoSdkDartBridge.dart';
import 'package:sdk_xyo_flutter/sdk/XyoBoundWitnessTarget.dart';

class XyoClient extends XyoBoundWitnessTarget {
  bool isScanning;
  bool isAutoBoundWitnessing;

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

class XyoBleClient extends XyoClient {}

class XyoTcpClient extends XyoClient {}
