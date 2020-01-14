import 'package:sdk_xyo_flutter/sdk_xyo_flutter.dart';
import 'package:sdk_xyo_flutter/sdk/XyoNetwork.dart';
import 'package:sdk_xyo_flutter/sdk/XyoNode.dart';

class XyoNodeBuilder {
  Future<XyoNode> build() async {
    print("XyoNodeBuilder: build");

    await XyoClientFlutterBridge.instance.build();
    await XyoServerFlutterBridge.instance.build();

    XyoNode node = XyoNode(defaultNetworks());

    return node;
  }

  defaultNetworks() {
    return {"ble": XyoBleNetwork(), "tcp": XyoTcpNetwork()};
  }
}
