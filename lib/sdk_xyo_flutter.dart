import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sdk_xyo_flutter/protos/bound_witness.pbserver.dart';
import 'package:sdk_xyo_flutter/protos/device.pbserver.dart';

enum XyoNodeType { client, server }

class XyoScanner {
  static XyoScanner instance = XyoScanner();
  final MethodChannel _channel = const MethodChannel('xyoDevice');

  final EventChannel _deviceDetectedChannel =
      const EventChannel('xyoDeviceOnDetect');
  final EventChannel _deviceExitedChannel =
      const EventChannel('xyoDeviceOnExit');

  Future<bool> setListening(bool on) async {
    final bool success = await _channel.invokeMethod('setListening', on);
    return success;
  }

  Stream<BluetoothDevice> onDeviceDetected() {
    return _deviceDetectedChannel
        .receiveBroadcastStream()
        .map<BluetoothDevice>((value) {
      final bw = BluetoothDevice.fromBuffer(value);
      return bw;
    });
  }

  Stream<BluetoothDevice> onDeviceExited() {
    return _deviceExitedChannel
        .receiveBroadcastStream()
        .map<BluetoothDevice>((value) {
      final bw = BluetoothDevice.fromBuffer(value);
      return bw;
    });
  }
}

class XyoNode {
  static XyoNode instance = XyoNode();

  final MethodChannel _channel = const MethodChannel('xyoNode');
  final EventChannel _boundWitnessSuccessChannel =
      const EventChannel('xyoNodeEvents');

  Stream<List<DeviceBoundWitness>> _boundWitnessSuccessStream;

  Future<String> get build async {
    final String version = await _channel.invokeMethod('build');
    return version;
  }

  Future<String> getPublicKey(bool isClient) async {
    final String value = await _channel.invokeMethod('getPublicKey', isClient);
    return value;
  }

  Future<bool> setBridging(bool isClient, bool on) async {
    final bool success =
        await _channel.invokeMethod('setBridging', [isClient, on]);
    return success;
  }

  Future<bool> setScanning(bool on) async {
    final bool success = await _channel.invokeMethod('setScanning', on);
    return success;
  }

  Future<bool> setListening(bool on) async {
    final bool success = await _channel.invokeMethod('setListening', on);
    return success;
  }

  Future<bool> setPayloadString(bool isClient, String data) async {
    final bool success =
        await _channel.invokeMethod('setPayloadData', [isClient, data]);
    return success;
  }

  Stream<List<DeviceBoundWitness>> onBoundWitnessSuccess() {
    List<DeviceBoundWitness> bws = [];
    _boundWitnessSuccessStream ??= _boundWitnessSuccessChannel
        .receiveBroadcastStream()
        .map<List<DeviceBoundWitness>>((value) {
      final bw = DeviceBoundWitness.fromBuffer(value);
      bws.add(bw);
      return bws;
    });
    return _boundWitnessSuccessStream;
  }
}
