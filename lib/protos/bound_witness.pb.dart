///
//  Generated code. Do not modify.
//  source: protos/bound_witness.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DeviceBoundWitnessList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeviceBoundWitnessList', createEmptyInstance: create)
    ..pc<DeviceBoundWitness>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boundWitnesses', $pb.PbFieldType.PM, subBuilder: DeviceBoundWitness.create)
    ..hasRequiredFields = false
  ;

  DeviceBoundWitnessList._() : super();
  factory DeviceBoundWitnessList({
    $core.Iterable<DeviceBoundWitness>? boundWitnesses,
  }) {
    final _result = create();
    if (boundWitnesses != null) {
      _result.boundWitnesses.addAll(boundWitnesses);
    }
    return _result;
  }
  factory DeviceBoundWitnessList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceBoundWitnessList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeviceBoundWitnessList clone() => DeviceBoundWitnessList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeviceBoundWitnessList copyWith(void Function(DeviceBoundWitnessList) updates) => super.copyWith((message) => updates(message as DeviceBoundWitnessList)) as DeviceBoundWitnessList; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeviceBoundWitnessList create() => DeviceBoundWitnessList._();
  DeviceBoundWitnessList createEmptyInstance() => create();
  static $pb.PbList<DeviceBoundWitnessList> createRepeated() => $pb.PbList<DeviceBoundWitnessList>();
  @$core.pragma('dart2js:noInline')
  static DeviceBoundWitnessList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceBoundWitnessList>(create);
  static DeviceBoundWitnessList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<DeviceBoundWitness> get boundWitnesses => $_getList(0);
}

class DeviceBoundWitness extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeviceBoundWitness', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bytes')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'byteHash')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'humanName')
    ..m<$core.String, $core.String>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'huerestics', entryClassName: 'DeviceBoundWitness.HueresticsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS)
    ..pPS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'parties')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'linked')
    ..hasRequiredFields = false
  ;

  DeviceBoundWitness._() : super();
  factory DeviceBoundWitness({
    $core.String? bytes,
    $core.String? byteHash,
    $core.String? humanName,
    $core.Map<$core.String, $core.String>? huerestics,
    $core.Iterable<$core.String>? parties,
    $core.bool? linked,
  }) {
    final _result = create();
    if (bytes != null) {
      _result.bytes = bytes;
    }
    if (byteHash != null) {
      _result.byteHash = byteHash;
    }
    if (humanName != null) {
      _result.humanName = humanName;
    }
    if (huerestics != null) {
      _result.huerestics.addAll(huerestics);
    }
    if (parties != null) {
      _result.parties.addAll(parties);
    }
    if (linked != null) {
      _result.linked = linked;
    }
    return _result;
  }
  factory DeviceBoundWitness.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceBoundWitness.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeviceBoundWitness clone() => DeviceBoundWitness()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeviceBoundWitness copyWith(void Function(DeviceBoundWitness) updates) => super.copyWith((message) => updates(message as DeviceBoundWitness)) as DeviceBoundWitness; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeviceBoundWitness create() => DeviceBoundWitness._();
  DeviceBoundWitness createEmptyInstance() => create();
  static $pb.PbList<DeviceBoundWitness> createRepeated() => $pb.PbList<DeviceBoundWitness>();
  @$core.pragma('dart2js:noInline')
  static DeviceBoundWitness getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceBoundWitness>(create);
  static DeviceBoundWitness? _defaultInstance;

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

