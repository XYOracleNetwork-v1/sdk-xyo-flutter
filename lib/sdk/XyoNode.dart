import 'package:sdk_xyo_flutter/sdk/XyoClient.dart';
import 'package:sdk_xyo_flutter/sdk/XyoNetwork.dart';
import 'package:sdk_xyo_flutter/sdk/XyoServer.dart';

class XyoNode {
  Map<String, XyoNetwork> networks;
  XyoNode(this.networks);

  XyoServer getServer(String networkName) {
    return networks[networkName].server;
  }

  XyoClient getClient(String networkName) {
    return networks[networkName].client;
  }
}
