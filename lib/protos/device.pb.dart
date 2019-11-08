///
//  Generated code. Do not modify.
//  source: protos/device.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class Family extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Family', createEmptyInstance: create)
    ..aOS(1, 'uuid')
    ..aOS(2, 'prefix')
    ..aOS(3, 'name')
    ..aOS(4, 'id')
    ..hasRequiredFields = false
  ;

  Family._() : super();
  factory Family() => create();
  factory Family.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Family.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Family clone() => Family()..mergeFromMessage(this);
  Family copyWith(void Function(Family) updates) => super.copyWith((message) => updates(message as Family));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Family create() => Family._();
  Family createEmptyInstance() => create();
  static $pb.PbList<Family> createRepeated() => $pb.PbList<Family>();
  @$core.pragma('dart2js:noInline')
  static Family getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Family>(create);
  static Family _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get prefix => $_getSZ(1);
  @$pb.TagNumber(2)
  set prefix($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPrefix() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrefix() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get id => $_getSZ(3);
  @$pb.TagNumber(4)
  set id($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasId() => $_has(3);
  @$pb.TagNumber(4)
  void clearId() => clearField(4);
}

class Range extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Range', createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'min', $pb.PbFieldType.OS6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'max', $pb.PbFieldType.OS6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  Range._() : super();
  factory Range() => create();
  factory Range.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Range.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Range clone() => Range()..mergeFromMessage(this);
  Range copyWith(void Function(Range) updates) => super.copyWith((message) => updates(message as Range));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Range create() => Range._();
  Range createEmptyInstance() => create();
  static $pb.PbList<Range> createRepeated() => $pb.PbList<Range>();
  @$core.pragma('dart2js:noInline')
  static Range getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Range>(create);
  static Range _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get min => $_getI64(0);
  @$pb.TagNumber(1)
  set min($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMin() => $_has(0);
  @$pb.TagNumber(1)
  void clearMin() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get max => $_getI64(1);
  @$pb.TagNumber(2)
  set max($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMax() => $_has(1);
  @$pb.TagNumber(2)
  void clearMax() => clearField(2);
}

class IBeacon extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('IBeacon', createEmptyInstance: create)
    ..aInt64(1, 'major')
    ..aInt64(2, 'minor')
    ..aOS(3, 'uuid')
    ..hasRequiredFields = false
  ;

  IBeacon._() : super();
  factory IBeacon() => create();
  factory IBeacon.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IBeacon.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  IBeacon clone() => IBeacon()..mergeFromMessage(this);
  IBeacon copyWith(void Function(IBeacon) updates) => super.copyWith((message) => updates(message as IBeacon));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IBeacon create() => IBeacon._();
  IBeacon createEmptyInstance() => create();
  static $pb.PbList<IBeacon> createRepeated() => $pb.PbList<IBeacon>();
  @$core.pragma('dart2js:noInline')
  static IBeacon getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IBeacon>(create);
  static IBeacon _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get major => $_getI64(0);
  @$pb.TagNumber(1)
  set major($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMajor() => $_has(0);
  @$pb.TagNumber(1)
  void clearMajor() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get minor => $_getI64(1);
  @$pb.TagNumber(2)
  set minor($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMinor() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinor() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUuid() => clearField(3);
}

class BluetoothDevice extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('BluetoothDevice', createEmptyInstance: create)
    ..aOS(1, 'id')
    ..aOM<Family>(2, 'family', subBuilder: Family.create)
    ..aOM<IBeacon>(3, 'beacon', subBuilder: IBeacon.create)
    ..a<$fixnum.Int64>(4, 'rssi', $pb.PbFieldType.OS6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<Range>(5, 'range', subBuilder: Range.create)
    ..aOB(6, 'connected')
    ..hasRequiredFields = false
  ;

  BluetoothDevice._() : super();
  factory BluetoothDevice() => create();
  factory BluetoothDevice.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BluetoothDevice.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  BluetoothDevice clone() => BluetoothDevice()..mergeFromMessage(this);
  BluetoothDevice copyWith(void Function(BluetoothDevice) updates) => super.copyWith((message) => updates(message as BluetoothDevice));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BluetoothDevice create() => BluetoothDevice._();
  BluetoothDevice createEmptyInstance() => create();
  static $pb.PbList<BluetoothDevice> createRepeated() => $pb.PbList<BluetoothDevice>();
  @$core.pragma('dart2js:noInline')
  static BluetoothDevice getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BluetoothDevice>(create);
  static BluetoothDevice _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  Family get family => $_getN(1);
  @$pb.TagNumber(2)
  set family(Family v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFamily() => $_has(1);
  @$pb.TagNumber(2)
  void clearFamily() => clearField(2);
  @$pb.TagNumber(2)
  Family ensureFamily() => $_ensure(1);

  @$pb.TagNumber(3)
  IBeacon get beacon => $_getN(2);
  @$pb.TagNumber(3)
  set beacon(IBeacon v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBeacon() => $_has(2);
  @$pb.TagNumber(3)
  void clearBeacon() => clearField(3);
  @$pb.TagNumber(3)
  IBeacon ensureBeacon() => $_ensure(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get rssi => $_getI64(3);
  @$pb.TagNumber(4)
  set rssi($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRssi() => $_has(3);
  @$pb.TagNumber(4)
  void clearRssi() => clearField(4);

  @$pb.TagNumber(5)
  Range get range => $_getN(4);
  @$pb.TagNumber(5)
  set range(Range v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasRange() => $_has(4);
  @$pb.TagNumber(5)
  void clearRange() => clearField(5);
  @$pb.TagNumber(5)
  Range ensureRange() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get connected => $_getBF(5);
  @$pb.TagNumber(6)
  set connected($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasConnected() => $_has(5);
  @$pb.TagNumber(6)
  void clearConnected() => clearField(6);
}

