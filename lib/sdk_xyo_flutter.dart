import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mutex/mutex.dart';
import 'package:sdk_xyo_flutter/protos/device.pbserver.dart';
import 'package:retry/retry.dart';

enum XyoNodeType { client, server }

enum XyoScannerStatus {
  none,
  enabled,
  bluetoothDisabled,
  bluetoothUnavailable,
  locationDisabled,
  unknown
}

class XyoScanner {
  static XyoScanner instance = XyoScanner();
  final MethodChannel _channel = const MethodChannel('xyoDevice');

  final EventChannel _deviceDetectedChannel =
      const EventChannel('xyoDeviceOnDetect');
  final EventChannel _deviceExitedChannel =
      const EventChannel('xyoDeviceOnExit');
  final EventChannel _statusChangedChannel =
      const EventChannel('xyoOnStatusChanged');

  Future<bool> setListening(bool on) async {
    final bool success = await _channel.invokeMethod('setDeviceListening', on);
    return success;
  }

  Future<String> getPublicKey(BluetoothDevice device) async {
    final String publicKey =
        await _channel.invokeMethod('getPublicKey', device.id);
    return publicKey;
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

  Stream<XyoScannerStatus> onStatusChanged() {
    return _statusChangedChannel
        .receiveBroadcastStream()
        .map<XyoScannerStatus>((value) {
      return value;
    });
  }
}

class XyoClientFlutterBridge extends XyoFlutterBridge {
  static XyoClientFlutterBridge instance = XyoClientFlutterBridge('xyoClient');

  XyoClientFlutterBridge(String s) : super(s);

  Future<bool> setScanning(bool on) async {
    await initialize();
    print("SDK:$channelName:setScanning $on");
    final bool scanning = await _channel.invokeMethod('setScanning', on);
    return scanning;
  }

  Future<bool> getScanning() async {
    await initialize();
    final bool scanning = await _channel.invokeMethod('getScanning');
    print("SDK:$channelName:getScanning $scanning");
    return scanning;
  }

  Future<bool> initiateBoundWitness(String id) async {
    await initialize();
    print("SDK:$channelName:initiateBoundWitness");
    final bool result = await _channel.invokeMethod('initiateBoundWitness');
    return result;
  }

  Future<bool> setAutoBoundWitnessing(bool autoBoundWitness) async {
    print("SDK:$channelName:setAutoBoundWitnessing $autoBoundWitness");
    final bool success =
        await _channel.invokeMethod('setAutoBoundWitnessing', autoBoundWitness);
    return success;
  }
}

class XyoServerFlutterBridge extends XyoFlutterBridge {
  static XyoServerFlutterBridge instance = XyoServerFlutterBridge('xyoServer');

  XyoServerFlutterBridge(String s) : super(s);

  Future<bool> setListening(bool listen) async {
    await initialize();
    print("SDK:$channelName:setListening $listen");
    final bool success = await _channel.invokeMethod('setListening', listen);
    return success;
  }

  Future<bool> getListening() async {
    await initialize();
    print("SDK:$channelName:getListening");
    final bool listening = await _channel.invokeMethod('getListening');
    return listening;
  }
}

class XyoFlutterBridge {
  MethodChannel _channel;
  String _buildResult;
  final channelName;
  var _initMutex = new Mutex();

  XyoFlutterBridge(this.channelName) {
    _channel = MethodChannel(channelName);
  }

  Future<String> initialize() async {
    if (_buildResult != null) {
      return _buildResult;
    }
    print("SDK:$channelName:initialize");

    await _initMutex.acquire();
    try {
      print("SDK:$channelName:initialize2");
      final r = RetryOptions(maxAttempts: 3);
      _buildResult = await r.retry(() async {
        print("SDK:$channelName:try build");

        _buildResult = await _channel.invokeMethod('build');
        print("SDK:$channelName:try build finished");

        return _buildResult;
      }, retryIf: (e) => _buildResult == null);
    } catch (err) {
      print("Error initializing, $err");
    } finally {
      _initMutex.release();
    }
    return _buildResult;
  }

  Future<String> build() async {
    print("SDK:$channelName:build");
    return initialize();
  }

  Future<String> getPublicKey() async {
    await initialize();
    print("SDK:$channelName:getPublicKey");
    final String value = await _channel.invokeMethod('getPublicKey');
    return value;
  }

  Future<bool> setBridging(bool on) async {
    await initialize();
    print("SDK:$channelName:setBridging $on");
    final bool success = await _channel.invokeMethod('setBridging', on);
    return success;
  }

  Future<bool> setPayloadString(String data) async {
    await initialize();
    print("SDK:$channelName:setPayloadString $data");
    final bool success = await _channel.invokeMethod('setPayloadData', data);
    return success;
  }

  Future<bool> setAcceptBridging(bool acceptBridging) async {
    print("SDK:$channelName:setPayloadString $acceptBridging");
    final bool success =
        await _channel.invokeMethod('setAcceptBridging', acceptBridging);
    return success;
  }
}
