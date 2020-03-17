import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sdk_xyo_flutter/main.dart';

import 'package:sdk_xyo_flutter/protos/device.pbserver.dart';
import 'package:mockito/mockito.dart';
import 'package:sdk_xyo_flutter/protos/device.pb.dart';

class MockClient extends Mock implements XyoScanner {

  static XyoScanner instance = XyoScanner();

  final MethodChannel _channel = const MethodChannel('xyoDevice');

  final EventChannel _deviceDetectedChannel =
      const EventChannel('xyoDeviceOnDetect');
  final EventChannel _deviceExitedChannel =
      const EventChannel('xyoDeviceOnExit');
  final EventChannel _statusChangedChannel =
      const EventChannel('xyoDeviceOnStatusChanged');

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

void main() {
  final MethodChannel _channel = const MethodChannel('xyoDevice');
  group('scanner', () {
    test('can start listening', () async {
      final client = MockClient();
      final bool success = await _channel.invokeMethod('setDeviceListening');
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.setListening(true))
          .thenAnswer((_) async => _channel.invokeMethod('setDeviceListening'));

      expect(await client.setListening(true), success);
    });
  });
}
