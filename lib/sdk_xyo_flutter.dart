import 'dart:async';

import 'package:flutter/services.dart';

class SdkXyoFlutter {
  static const MethodChannel _channel = const MethodChannel('sdk_xyo_flutter');
  static const EventChannel _eventChannel =
      const EventChannel('sdk_xyo_flutter_events');

  static Stream<String> _onBoundWitnessStart;

  static Future<String> get buildXyo async {
    final String version = await _channel.invokeMethod('build');
    return version;
  }

  static Stream<String> onBoundWitnessStart() {
    _onBoundWitnessStart ??=
        _eventChannel.receiveBroadcastStream().map<String>((value) => value);
    return _onBoundWitnessStart;
  }
}
