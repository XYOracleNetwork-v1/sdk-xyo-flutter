import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sdk_xyo_flutter/sdk/XyoNode.dart';

void main() {
  const MethodChannel channel = MethodChannel('sdk_xyo_flutter');
  XyoNode _xyoNode;

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('can get a public key', () async {
    expect(await _xyoNode.getClient('ble').getPublicKey(), "");
  });
}
