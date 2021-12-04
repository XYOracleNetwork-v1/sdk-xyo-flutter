///
//  Generated code. Do not modify.
//  source: protos/device.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use familyDescriptor instead')
const Family$json = const {
  '1': 'Family',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'prefix', '3': 2, '4': 1, '5': 9, '10': 'prefix'},
    const {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'id', '3': 4, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `Family`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List familyDescriptor = $convert.base64Decode('CgZGYW1pbHkSEgoEdXVpZBgBIAEoCVIEdXVpZBIWCgZwcmVmaXgYAiABKAlSBnByZWZpeBISCgRuYW1lGAMgASgJUgRuYW1lEg4KAmlkGAQgASgJUgJpZA==');
@$core.Deprecated('Use rangeDescriptor instead')
const Range$json = const {
  '1': 'Range',
  '2': const [
    const {'1': 'min', '3': 1, '4': 1, '5': 18, '10': 'min'},
    const {'1': 'max', '3': 2, '4': 1, '5': 18, '10': 'max'},
  ],
};

/// Descriptor for `Range`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rangeDescriptor = $convert.base64Decode('CgVSYW5nZRIQCgNtaW4YASABKBJSA21pbhIQCgNtYXgYAiABKBJSA21heA==');
@$core.Deprecated('Use iBeaconDescriptor instead')
const IBeacon$json = const {
  '1': 'IBeacon',
  '2': const [
    const {'1': 'major', '3': 1, '4': 1, '5': 3, '10': 'major'},
    const {'1': 'minor', '3': 2, '4': 1, '5': 3, '10': 'minor'},
    const {'1': 'uuid', '3': 3, '4': 1, '5': 9, '10': 'uuid'},
  ],
};

/// Descriptor for `IBeacon`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iBeaconDescriptor = $convert.base64Decode('CgdJQmVhY29uEhQKBW1ham9yGAEgASgDUgVtYWpvchIUCgVtaW5vchgCIAEoA1IFbWlub3ISEgoEdXVpZBgDIAEoCVIEdXVpZA==');
@$core.Deprecated('Use bluetoothDeviceDescriptor instead')
const BluetoothDevice$json = const {
  '1': 'BluetoothDevice',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'family', '3': 2, '4': 1, '5': 11, '6': '.Family', '10': 'family'},
    const {'1': 'beacon', '3': 3, '4': 1, '5': 11, '6': '.IBeacon', '10': 'beacon'},
    const {'1': 'rssi', '3': 4, '4': 1, '5': 18, '10': 'rssi'},
    const {'1': 'range', '3': 5, '4': 1, '5': 11, '6': '.Range', '10': 'range'},
    const {'1': 'connected', '3': 6, '4': 1, '5': 8, '10': 'connected'},
  ],
};

/// Descriptor for `BluetoothDevice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bluetoothDeviceDescriptor = $convert.base64Decode('Cg9CbHVldG9vdGhEZXZpY2USDgoCaWQYASABKAlSAmlkEh8KBmZhbWlseRgCIAEoCzIHLkZhbWlseVIGZmFtaWx5EiAKBmJlYWNvbhgDIAEoCzIILklCZWFjb25SBmJlYWNvbhISCgRyc3NpGAQgASgSUgRyc3NpEhwKBXJhbmdlGAUgASgLMgYuUmFuZ2VSBXJhbmdlEhwKCWNvbm5lY3RlZBgGIAEoCFIJY29ubmVjdGVk');
