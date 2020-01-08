import 'dart:async';

import 'package:flutter/services.dart';
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

class XyoSdkDartBridge {
  static XyoSdkDartBridge instance = XyoSdkDartBridge();

  final MethodChannel _channel = const MethodChannel('xyoNode');

  Future<String> build() async {
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

  Future<bool> setAutoBoundWitnessing(
      bool isClient, bool autoBoundWitness) async {
    final bool success = await _channel
        .invokeMethod('setAutoBoundWitnessing', [isClient, autoBoundWitness]);
    return success;
  }

  Future<bool> setAcceptBridging(bool isClient, bool acceptBridging) async {
    final bool success = await _channel
        .invokeMethod('setAcceptBridging', [isClient, acceptBridging]);
    return success;
  }
}
