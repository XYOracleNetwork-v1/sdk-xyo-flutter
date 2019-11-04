///
//  Generated code. Do not modify.
//  source: protos/gatt.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class DefinedOperation extends $pb.ProtobufEnum {
  static const DefinedOperation STAY_AWAKE = DefinedOperation._(0, 'STAY_AWAKE');
  static const DefinedOperation GO_TO_SLEEP = DefinedOperation._(1, 'GO_TO_SLEEP');
  static const DefinedOperation LOCK = DefinedOperation._(2, 'LOCK');
  static const DefinedOperation UNLOCK = DefinedOperation._(3, 'UNLOCK');
  static const DefinedOperation SONG = DefinedOperation._(4, 'SONG');
  static const DefinedOperation STOP_SONG = DefinedOperation._(5, 'STOP_SONG');
  static const DefinedOperation PUBLIC_KEY = DefinedOperation._(6, 'PUBLIC_KEY');

  static const $core.List<DefinedOperation> values = <DefinedOperation> [
    STAY_AWAKE,
    GO_TO_SLEEP,
    LOCK,
    UNLOCK,
    SONG,
    STOP_SONG,
    PUBLIC_KEY,
  ];

  static final $core.Map<$core.int, DefinedOperation> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DefinedOperation valueOf($core.int value) => _byValue[value];

  const DefinedOperation._($core.int v, $core.String n) : super(v, n);
}

