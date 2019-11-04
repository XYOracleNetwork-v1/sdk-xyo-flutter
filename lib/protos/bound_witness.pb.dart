///
//  Generated code. Do not modify.
//  source: protos/bound_witness.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, pragma, String;

import 'package:protobuf/protobuf.dart' as $pb;

class DeviceBoundWitnessList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DeviceBoundWitnessList')
    ..pc<DeviceBoundWitness>(1, 'boundWitnesses', $pb.PbFieldType.PM,DeviceBoundWitness.create)
    ..hasRequiredFields = false
  ;

  DeviceBoundWitnessList._() : super();
  factory DeviceBoundWitnessList() => create();
  factory DeviceBoundWitnessList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceBoundWitnessList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  DeviceBoundWitnessList clone() => DeviceBoundWitnessList()..mergeFromMessage(this);
  DeviceBoundWitnessList copyWith(void Function(DeviceBoundWitnessList) updates) => super.copyWith((message) => updates(message as DeviceBoundWitnessList));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeviceBoundWitnessList create() => DeviceBoundWitnessList._();
  DeviceBoundWitnessList createEmptyInstance() => create();
  static $pb.PbList<DeviceBoundWitnessList> createRepeated() => $pb.PbList<DeviceBoundWitnessList>();
  static DeviceBoundWitnessList getDefault() => _defaultInstance ??= create()..freeze();
  static DeviceBoundWitnessList _defaultInstance;

  $core.List<DeviceBoundWitness> get boundWitnesses => $_getList(0);
}

class DeviceBoundWitness extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DeviceBoundWitness')
    ..aOS(1, 'bytes')
    ..aOS(2, 'byteHash')
    ..aOS(3, 'humanName')
    ..m<$core.String, $core.String>(4, 'huerestics', 'DeviceBoundWitness.HueresticsEntry',$pb.PbFieldType.OS, $pb.PbFieldType.OS, null, null, null )
    ..pPS(5, 'parties')
    ..aOB(6, 'linked')
    ..hasRequiredFields = false
  ;

  DeviceBoundWitness._() : super();
  factory DeviceBoundWitness() => create();
  factory DeviceBoundWitness.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceBoundWitness.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  DeviceBoundWitness clone() => DeviceBoundWitness()..mergeFromMessage(this);
  DeviceBoundWitness copyWith(void Function(DeviceBoundWitness) updates) => super.copyWith((message) => updates(message as DeviceBoundWitness));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeviceBoundWitness create() => DeviceBoundWitness._();
  DeviceBoundWitness createEmptyInstance() => create();
  static $pb.PbList<DeviceBoundWitness> createRepeated() => $pb.PbList<DeviceBoundWitness>();
  static DeviceBoundWitness getDefault() => _defaultInstance ??= create()..freeze();
  static DeviceBoundWitness _defaultInstance;

  $core.String get bytes => $_getS(0, '');
  set bytes($core.String v) { $_setString(0, v); }
  $core.bool hasBytes() => $_has(0);
  void clearBytes() => clearField(1);

  $core.String get byteHash => $_getS(1, '');
  set byteHash($core.String v) { $_setString(1, v); }
  $core.bool hasByteHash() => $_has(1);
  void clearByteHash() => clearField(2);

  $core.String get humanName => $_getS(2, '');
  set humanName($core.String v) { $_setString(2, v); }
  $core.bool hasHumanName() => $_has(2);
  void clearHumanName() => clearField(3);

  $core.Map<$core.String, $core.String> get huerestics => $_getMap(3);

  $core.List<$core.String> get parties => $_getList(4);

  $core.bool get linked => $_get(5, false);
  set linked($core.bool v) { $_setBool(5, v); }
  $core.bool hasLinked() => $_has(5);
  void clearLinked() => clearField(6);
}

