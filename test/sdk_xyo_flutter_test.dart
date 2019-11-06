import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sdk_xyo_flutter/sdk_xyo_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('sdk_xyo_flutter');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SdkXyoFlutter.platformVersion, '42');
  });
}
