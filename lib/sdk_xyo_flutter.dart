import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mutex/mutex.dart';
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
  String _version;
  var _initMutex = new Mutex();

  Future<void> initialize() async {
    print("SDK:initialize");
    if (_version != null) {
      return;
    }
    await _initMutex.acquire();
    try {
      // check a second time since after the pause it may have been set
      if (_version == null) {
        print("SDK:initialize2");
        _version = (await _channel.invokeMethod('build')).toString();
      }
    }
    finally {
      _initMutex.release();
    }
  }

  Future<String> build() async {
    await initialize();
    print("SDK:build");
    return _version;
  }

  Future<String> getPublicKey(bool isClient) async {
    await initialize();
    print("SDK:getPublicKey");
    final String value = await _channel.invokeMethod('getPublicKey', isClient);
    return value;
  }

  Future<bool> setBridging(bool isClient, bool on) async {
    await initialize();
    print("SDK:setBridging");
    final bool success =
        await _channel.invokeMethod('setBridging', [isClient, on]);
    return success;
  }

  Future<bool> setScanning(bool on) async {
    await initialize();
    print("SDK:setScanning");
    final bool scanning = await _channel.invokeMethod('setScanning', on);
    return scanning;
  }

  Future<bool> getScanning() async {
    await initialize();
    print("SDK:getScanning");
    final bool scanning = await _channel.invokeMethod('getScanning');
    return scanning;
  }

  Future<bool> setListening(bool on) async {
    await initialize();
    print("SDK:setListening");
    final bool success = await _channel.invokeMethod('setListening', on);
    return success;
  }

  Future<bool> setPayloadString(bool isClient, String data) async {
    await initialize();
    print("SDK:setPayloadString");
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
