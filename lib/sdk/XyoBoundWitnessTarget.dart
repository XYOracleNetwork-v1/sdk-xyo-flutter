import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdk_xyo_flutter/sdk_xyo_flutter.dart';
import 'package:sdk_xyo_flutter/protos/bound_witness.pb.dart';
import 'package:sdk_xyo_flutter/sdk/XyoNetwork.dart';

import 'XyoClient.dart';

class XyoBoundWitnessTarget extends ChangeNotifier {
  EventChannel _boundWitnessStartedChannel;
  EventChannel _boundWitnessCompletedChannel;
  XyoNetworkType network;

  XyoFlutterBridge _flutterBridge;

  XyoBoundWitnessTarget(this.network) {
    String cliStr = isClient() ? "xyoClient" : "xyoServer";
    String networkStr = this.network == XyoNetworkType.ble ? "ble" : "tcpip";

    String startChannelName = cliStr + networkStr + "Started";
    //xyoNodebleClientStarted
    String completeChannelName = cliStr + networkStr + "Ended";
    //xyoNodebleClientEnded
    _boundWitnessStartedChannel = EventChannel(startChannelName);
    _boundWitnessCompletedChannel = EventChannel(completeChannelName);
    _flutterBridge = isClient()
        ? XyoClientFlutterBridge.instance
        : XyoServerFlutterBridge.instance;
  }

  Future<String> getPublicKey() async {
    return _flutterBridge.getPublicKey(this is XyoClient);
  }

  bool isBridging;
  bool isAcceptingBridging;
  String payloadData;

  bool get autoBridge {
    return isBridging;
  }

  String get stringHeuristic {
    return payloadData;
  }

  set stringHeuristic(String stringHeuristic) {
    payloadData = stringHeuristic;
    _flutterBridge.setPayloadString(payloadData);
  }

  set autoBridge(bool autoBridge) {
    isBridging = autoBridge;
    _flutterBridge.setBridging(autoBridge);
    notifyListeners();
  }

  set acceptBridging(bool acceptBridging) {
    isAcceptingBridging = acceptBridging;
    _flutterBridge.setAcceptBridging(acceptBridging);
  }

  bool isClient() => this is XyoClient;

  Stream<List<DeviceBoundWitness>> onBoundWitnessSuccess() {
    if (_boundWitnessCompletedChannel == null) return Stream.empty();
    List<DeviceBoundWitness> bws = [];
    return _boundWitnessCompletedChannel
        .receiveBroadcastStream()
        .map<List<DeviceBoundWitness>>((value) {
      final bw = DeviceBoundWitness.fromBuffer(value);
      // print("Bw Completed $value");
      bws.add(bw);
      return bws;
    });
  }

  Stream<List<dynamic>> onBoundWitnessStarted() {
    if (_boundWitnessStartedChannel == null) return Stream.empty();

    List<dynamic> somethings = [];

    return _boundWitnessStartedChannel.receiveBroadcastStream().map((value) {
      print("Bw Started $value");
      somethings.add(value);
      return somethings;
    });
  }
}
