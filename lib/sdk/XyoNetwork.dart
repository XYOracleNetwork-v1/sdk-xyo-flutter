import 'package:sdk_xyo_flutter/sdk/XyoClient.dart';
import 'package:sdk_xyo_flutter/sdk/XyoServer.dart';

enum XyoNetworkType { ble, tcpip, other }

abstract class XyoNetwork {
  XyoClient? client;
  XyoServer? server;
  XyoNetworkType? type;
}

class XyoBleNetwork extends XyoNetwork {
  XyoBleNetwork() : super() {
    type = XyoNetworkType.ble;

    client = XyoBleClient(XyoNetworkType.ble);
    client?.autoBoundWitness = true;
    client?.autoBridge = false;
    client?.acceptBridging = false;
    client?.scan = true;
    server = XyoBleServer(XyoNetworkType.ble);
    server?.autoBridge = true;
    server?.acceptBridging = false;
    server?.isListening = false;
  }
}

class XyoTcpNetwork extends XyoNetwork {
  XyoTcpNetwork() : super() {
    type = XyoNetworkType.tcpip;
    client = XyoTcpClient(XyoNetworkType.tcpip);
    client?.autoBoundWitness = true;
    client?.autoBridge = false;
    client?.acceptBridging = false;
    client?.scan = true;
    server = XyoTcpServer(XyoNetworkType.tcpip);
    server?.autoBridge = false;
    server?.acceptBridging = false;
    server?.listen = true;
  }
}
