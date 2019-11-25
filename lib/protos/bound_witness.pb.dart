///
//  Generated code. Do not modify.
//  source: protos/bound_witness.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DeviceBoundWitnessList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DeviceBoundWitnessList', createEmptyInstance: create)
    ..pc<DeviceBoundWitness>(1, 'boundWitnesses', $pb.PbFieldType.PM, subBuilder: DeviceBoundWitness.create)
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
  @$core.pragma('dart2js:noInline')
  static DeviceBoundWitnessList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceBoundWitnessList>(create);
  static DeviceBoundWitnessList _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<DeviceBoundWitness> get boundWitnesses => $_getList(0);
}

class DeviceBoundWitness extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DeviceBoundWitness', createEmptyInstance: create)
    ..aOS(1, 'bytes')
    ..aOS(2, 'byteHash')
    ..aOS(3, 'humanName')
    ..m<$core.String, $core.String>(4, 'huerestics', entryClassName: 'DeviceBoundWitness.HueresticsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS)
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
  @$core.pragma('dart2js:noInline')
  static DeviceBoundWitness getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceBoundWitness>(create);
  static DeviceBoundWitness _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bytes => $_getSZ(0);
  @$pb.TagNumber(1)
  set bytes($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBytes() => $_has(0);
  @$pb.TagNumber(1)
  void clearBytes() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get byteHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set byteHash($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasByteHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearByteHash() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get humanName => $_getSZ(2);
  @$pb.TagNumber(3)
  set humanName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHumanName() => $_has(2);
  @$pb.TagNumber(3)
  void clearHumanName() => clearField(3);

  @$pb.TagNumber(4)
  $core.Map<$core.String, $core.String> get huerestics => $_getMap(3);

  @$pb.TagNumber(5)
  $core.List<$core.String> get parties => $_getList(4);

  @$pb.TagNumber(6)
  $core.bool get linked => $_getBF(5);
  @$pb.TagNumber(6)
  set linked($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLinked() => $_has(5);
  @$pb.TagNumber(6)
  void clearLinked() => clearField(6);
}

