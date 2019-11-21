import 'package:flutter/services.dart';
import 'package:sdk_xyo_flutter/XyoSdkDartBridge.dart';
import 'package:sdk_xyo_flutter/protos/bound_witness.pb.dart';

import 'XyoClient.dart';

class XyoBoundWitnessTarget {
  EventChannel _boundWitnessStartedChannel;
  EventChannel _boundWitnessCompletedChannel;

  init() {
    String cliStr = isClient() ? "Client" : "Server";
    String startChannelName = "xyo" + cliStr + "Started";
    String completeChannelName = "xyo" + cliStr + "Completed";
    _boundWitnessStartedChannel = EventChannel(startChannelName);
    _boundWitnessCompletedChannel = EventChannel(completeChannelName);
  }

  Future<String> getPublicKey() async {
    return XyoSdkDartBridge.instance.getPublicKey(this is XyoClient);
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
    XyoSdkDartBridge.instance.setPayloadString(this is XyoClient, payloadData);
  }

  set autoBridge(bool autoBridge) {
    isBridging = autoBridge;
    XyoSdkDartBridge.instance.setBridging(this is XyoClient, autoBridge);
  }

  set acceptBridging(bool acceptBridging) {
    isAcceptingBridging = acceptBridging;
    XyoSdkDartBridge.instance
        .setAcceptBridging(this is XyoClient, acceptBridging);
  }

  bool isClient() => this is XyoClient;

  Stream<List<DeviceBoundWitness>> onBoundWitnessSuccess() {
    List<DeviceBoundWitness> bws = [];
    return _boundWitnessCompletedChannel
        .receiveBroadcastStream()
        .map<List<DeviceBoundWitness>>((value) {
      final bw = DeviceBoundWitness.fromBuffer(value);
      print("Bw Completed $value");
      bws.add(bw);
      return bws;
    });
  }

  Stream<List<dynamic>> onBoundWitnessStarted() {
    List<dynamic> somethings = [];

    return _boundWitnessStartedChannel.receiveBroadcastStream().map((value) {
      print("Bw Started");
      somethings.add(value);
      return somethings;
    });
  }

  @override
  boundWitnessCompleted(
      source, XyoBoundWitnessTarget target, DeviceBoundWitness boundWitness) {
    // TODO: implement boundWitnessCompleted
    return null;
  }

  @override
  boundWitnessStarted(source, XyoBoundWitnessTarget target) {
    // TODO: implement boundWitnessStarted
    return null;
  }
}
