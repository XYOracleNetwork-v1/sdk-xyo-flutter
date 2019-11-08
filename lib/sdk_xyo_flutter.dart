import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sdk_xyo_flutter/protos/bound_witness.pbserver.dart';

class SdkXyoFlutter {
  static const MethodChannel _channel = const MethodChannel('sdk_xyo_flutter');
  static const EventChannel _eventChannel =
      const EventChannel('sdk_xyo_flutter_events');

  static Stream<List<DeviceBoundWitness>> _onBoundWitnessStart;

  static Future<String> get build async {
    final String version = await _channel.invokeMethod('build');
    return version;
  }

  static Future<String> get getPublicKey async {
    final String value = await _channel.invokeMethod('getPublicKey');
    return value;
  }

  static Future<bool> setBridging(bool on) async {
    final bool success = await _channel.invokeMethod('setBridging', on);
    return success;
  }

  static Future<bool> setScanning(bool on) async {
    final bool success = await _channel.invokeMethod('setScanning', on);
    return success;
  }

  static Future<bool> setListening(bool on) async {
    final bool success = await _channel.invokeMethod('setListening', on);
    return success;
  }

  static Stream<List<DeviceBoundWitness>> onBoundWitnessStart() {
    List<DeviceBoundWitness> bws = [];
    _onBoundWitnessStart ??= _eventChannel
        .receiveBroadcastStream()
        .map<List<DeviceBoundWitness>>((value) {
      final bw = DeviceBoundWitness.fromBuffer(value);
      bws.add(bw);
      return bws;
    });
    return _onBoundWitnessStart;
  }
}
