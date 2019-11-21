import 'package:sdk_xyo_flutter/sdk/XyoClient.dart';
import 'package:sdk_xyo_flutter/sdk/XyoServer.dart';

enum XyoNetworkType { ble, tcpip, other }

abstract class XyoNetwork {
  XyoClient client;
  XyoServer server;
  XyoNetworkType type;
}

class XyoBleNetwork extends XyoNetwork {
  XyoBleNetwork() : super() {
    client = XyoBleClient();
    client.autoBoundWitness = true;
    client.autoBridge = false;
    client.acceptBridging = false;
    client.scan = true;
    server = XyoBleServer();
    server.autoBridge = false;
    server.acceptBridging = false;
    server.listen = true;
  }
}

class XyoTcpNetwork extends XyoNetwork {
  XyoTcpNetwork() : super() {
    client = XyoTcpClient();
    client.autoBoundWitness = true;
    client.autoBridge = false;
    client.acceptBridging = false;
    client.scan = true;
    server = XyoTcpServer();
    server.autoBridge = false;
    server.acceptBridging = false;
    server.listen = true;
  }
}
