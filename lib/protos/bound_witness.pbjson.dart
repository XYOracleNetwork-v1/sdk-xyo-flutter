///
//  Generated code. Do not modify.
//  source: protos/bound_witness.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use deviceBoundWitnessListDescriptor instead')
const DeviceBoundWitnessList$json = const {
  '1': 'DeviceBoundWitnessList',
  '2': const [
    const {'1': 'bound_witnesses', '3': 1, '4': 3, '5': 11, '6': '.DeviceBoundWitness', '10': 'boundWitnesses'},
  ],
};

/// Descriptor for `DeviceBoundWitnessList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceBoundWitnessListDescriptor = $convert.base64Decode('ChZEZXZpY2VCb3VuZFdpdG5lc3NMaXN0EjwKD2JvdW5kX3dpdG5lc3NlcxgBIAMoCzITLkRldmljZUJvdW5kV2l0bmVzc1IOYm91bmRXaXRuZXNzZXM=');
@$core.Deprecated('Use deviceBoundWitnessDescriptor instead')
const DeviceBoundWitness$json = const {
  '1': 'DeviceBoundWitness',
  '2': const [
    const {'1': 'bytes', '3': 1, '4': 1, '5': 9, '10': 'bytes'},
    const {'1': 'byte_hash', '3': 2, '4': 1, '5': 9, '10': 'byteHash'},
    const {'1': 'human_name', '3': 3, '4': 1, '5': 9, '10': 'humanName'},
    const {'1': 'huerestics', '3': 4, '4': 3, '5': 11, '6': '.DeviceBoundWitness.HueresticsEntry', '10': 'huerestics'},
    const {'1': 'parties', '3': 5, '4': 3, '5': 9, '10': 'parties'},
    const {'1': 'linked', '3': 6, '4': 1, '5': 8, '10': 'linked'},
  ],
  '3': const [DeviceBoundWitness_HueresticsEntry$json],
};

@$core.Deprecated('Use deviceBoundWitnessDescriptor instead')
const DeviceBoundWitness_HueresticsEntry$json = const {
  '1': 'HueresticsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `DeviceBoundWitness`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceBoundWitnessDescriptor = $convert.base64Decode('ChJEZXZpY2VCb3VuZFdpdG5lc3MSFAoFYnl0ZXMYASABKAlSBWJ5dGVzEhsKCWJ5dGVfaGFzaBgCIAEoCVIIYnl0ZUhhc2gSHQoKaHVtYW5fbmFtZRgDIAEoCVIJaHVtYW5OYW1lEkMKCmh1ZXJlc3RpY3MYBCADKAsyIy5EZXZpY2VCb3VuZFdpdG5lc3MuSHVlcmVzdGljc0VudHJ5UgpodWVyZXN0aWNzEhgKB3BhcnRpZXMYBSADKAlSB3BhcnRpZXMSFgoGbGlua2VkGAYgASgIUgZsaW5rZWQaPQoPSHVlcmVzdGljc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');
