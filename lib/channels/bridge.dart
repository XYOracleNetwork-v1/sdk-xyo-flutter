import 'package:sdk_xyo_flutter/channels/node.dart';
import 'package:sdk_xyo_flutter/classes/archivist.dart';
import 'package:sdk_xyo_flutter/main.dart';

class XyoBridgeChannel extends XyoNodeChannel {
  XyoBridgeChannel(String name) : super(name);

  // Set the archivists
  Future<bool> setArchivists(List<ArchivistModel> archivists) async {
    final List<Map<String, dynamic>> values = archivists.map((a) => {'dns': a.dns, 'port': a.port}).toList();

    return await invokeMethod('setArchivists', <String, dynamic>{
      'archivists': values,
    });
  }

  // Self Sign a Block
  Future<DeviceBoundWitness> selfSign() async {
    return DeviceBoundWitness.fromBuffer(await invokeMethod('selfSign'));
  }

  Future<DeviceBoundWitness> initiateBoundWitness(String deviceId) async {
    return DeviceBoundWitness.fromBuffer(await invokeMethod('initiateBoundWitness', <String, dynamic>{
      'deviceId': deviceId,
    }));
  }
}
