import 'package:sdk_xyo_flutter/channels/bridge.dart';
import 'package:sdk_xyo_flutter/channels/sentinel.dart';
import 'package:sdk_xyo_flutter/channels/device.dart';
export 'package:sdk_xyo_flutter/protos/gatt.pb.dart';
export 'package:sdk_xyo_flutter/protos/device.pb.dart';
export 'package:sdk_xyo_flutter/protos/bound_witness.pb.dart';

class XyoSdk {
  static final device = XyoDeviceChannel('network.xyo/device');
  static final sentinel = XyoSentinelChannel('network.xyo/sentinel');
  static final bridge = XyoBridgeChannel('network.xyo/bridge');
}
