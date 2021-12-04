import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdk_xyo_flutter/main.dart';
import 'package:sdk_xyo_flutter/protos/bound_witness.pb.dart';
import 'package:sdk_xyo_flutter/sdk/XyoNetwork.dart';

import 'XyoClient.dart';

class XyoBoundWitnessTarget with ChangeNotifier {
  EventChannel? _boundWitnessStartedChannel;
  EventChannel? _boundWitnessCompletedChannel;
  XyoNetworkType? network;

  XyoFlutterBridge? _flutterBridge;

  XyoBoundWitnessTarget(this.network) {
    String cliStr = isClient() ? "xyoClient" : "xyoServer";
    // String networkStr = this.network == XyoNetworkType.ble ? "ble" : "tcpip";

    String startChannelName = cliStr + "Started";
    //xyoNodebleClientStarted
    String completeChannelName = cliStr + "Ended";
    //xyoNodebleClientEnded
    _boundWitnessStartedChannel = EventChannel(startChannelName);
    _boundWitnessCompletedChannel = EventChannel(completeChannelName);
    _flutterBridge = isClient()
        ? XyoClientFlutterBridge.instance
        : XyoServerFlutterBridge.instance;
  }

  Future<String> getPublicKey() async {
    return Future.value(await _flutterBridge?.getPublicKey());
  }

  bool isBridging = false;
  bool isAcceptingBridging = false;
  String? payloadData;

  bool get autoBridge {
    return isBridging;
  }

  String? get stringHeuristic {
    return payloadData;
  }

  set stringHeuristic(String? stringHeuristic) {
    payloadData = stringHeuristic;
    _flutterBridge?.setPayloadString(payloadData);
    notifyListeners();
  }

  set autoBridge(bool autoBridge) {
    isBridging = autoBridge;
    _flutterBridge?.setBridging(autoBridge);
    notifyListeners();
  }

  set acceptBridging(bool acceptBridging) {
    isAcceptingBridging = acceptBridging;
    _flutterBridge?.setAcceptBridging(acceptBridging);
    notifyListeners();
  }

  bool isClient() => this is XyoClient;

  Stream<List<DeviceBoundWitness>> onBoundWitnessSuccess() {
    var boundWitnessCompletedChannel = _boundWitnessCompletedChannel;
    if (boundWitnessCompletedChannel == null) return Stream.empty();
    List<DeviceBoundWitness> bws = [];
    return boundWitnessCompletedChannel
        .receiveBroadcastStream()
        .map<List<DeviceBoundWitness>>((value) {
      final bw = DeviceBoundWitness.fromBuffer(value);
      // print("Bw Completed $value");
      bws.add(bw);
      return bws;
    });
  }

  Stream<List<dynamic>> onBoundWitnessStarted() {
    var boundWitnessStartedChannel = _boundWitnessStartedChannel;
    if (boundWitnessStartedChannel == null) return Stream.empty();

    List<dynamic> somethings = [];

    return boundWitnessStartedChannel.receiveBroadcastStream().map((value) {
      print("Bw Started $value");
      somethings.add(value);
      return somethings;
    });
  }
}
