import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mutex/mutex.dart';
import 'package:sdk_xyo_flutter/protos/device.pbserver.dart';
import 'package:retry/retry.dart';

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

class XyoClientFlutterBridge extends XyoFlutterBridge {
  static XyoClientFlutterBridge instance = XyoClientFlutterBridge('xyoClient');

  XyoClientFlutterBridge(String s) : super(s);

  Future<bool> setScanning(bool on) async {
    await initialize();
    print("SDK:setScanning $on");
    final bool scanning = await _channel.invokeMethod('setScanning', on);
    return scanning;
  }

  Future<bool> getScanning() async {
    await initialize();
    final bool scanning = await _channel.invokeMethod('getScanning');
    print("SDK:getScanning $scanning");
    return scanning;
  }

  Future<bool> setAutoBoundWitnessing(bool autoBoundWitness) async {
    final bool success =
        await _channel.invokeMethod('setAutoBoundWitnessing', autoBoundWitness);
    return success;
  }
}

class XyoServerFlutterBridge extends XyoFlutterBridge {
  static XyoServerFlutterBridge instance = XyoServerFlutterBridge('xyoServer');

  XyoServerFlutterBridge(String s) : super(s);

  Future<bool> setListening(bool on) async {
    await initialize();
    print("SDK:setListening");
    final bool success = await _channel.invokeMethod('setListening', on);
    return success;
  }

  Future<bool> getListening() async {
    await initialize();
    print("SDK:getListening");
    final bool listening = await _channel.invokeMethod('getListening');
    return listening;
  }
}

class XyoFlutterBridge {
  MethodChannel _channel;
  String _buildResult;
  var _initMutex = new Mutex();

  XyoFlutterBridge(String channelName) {
    _channel = MethodChannel(channelName);
  }

  Future<void> initialize() async {
    print("SDK:initialize");
    if (_buildResult != null) {
      return;
    }
    await _initMutex.acquire();
    try {
      // check a second time since after the pause it may have been set
      if (_buildResult == null) {
        print("SDK:initialize2");
        final r = RetryOptions(maxAttempts: 3);
        _buildResult = await r.retry(() {
          return _channel.invokeMethod('build');
        }, retryIf: (e) => _buildResult == null);
      }
    } finally {
      _initMutex.release();
    }
  }

  Future<String> build() async {
    await initialize();
    print("SDK:build");
    return _buildResult;
  }

  Future<String> getPublicKey(bool isClient) async {
    await initialize();
    print("SDK:getPublicKey");
    final String value = await _channel.invokeMethod('getPublicKey');
    return value;
  }

  Future<bool> setBridging(bool on) async {
    await initialize();
    print("SDK:setBridging");
    final bool success = await _channel.invokeMethod('setBridging', on);
    return success;
  }

  Future<bool> setPayloadString(String data) async {
    await initialize();
    print("SDK:setPayloadString");
    final bool success = await _channel.invokeMethod('setPayloadData', data);
    return success;
  }

  Future<bool> setAcceptBridging(bool acceptBridging) async {
    final bool success =
        await _channel.invokeMethod('setAcceptBridging', acceptBridging);
    return success;
  }
}
