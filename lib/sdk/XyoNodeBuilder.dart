import 'package:sdk_xyo_flutter/XyoSdkDartBridge.dart';
import 'package:sdk_xyo_flutter/sdk/XyoNetwork.dart';
import 'package:sdk_xyo_flutter/sdk/XyoNode.dart';

class XyoNodeBuilder {
  Future<XyoNode> build() async {
    XyoNode node = XyoNode(defaultNetworks());
    await XyoSdkDartBridge.instance.build();
    return node;
  }

  defaultNetworks() {
    return {"ble": XyoBleNetwork(), "tcp": XyoTcpNetwork()};
  }
}
