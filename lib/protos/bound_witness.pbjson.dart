///
//  Generated code. Do not modify.
//  source: protos/bound_witness.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const DeviceBoundWitnessList$json = const {
  '1': 'DeviceBoundWitnessList',
  '2': const [
    const {'1': 'bound_witnesses', '3': 1, '4': 3, '5': 11, '6': '.DeviceBoundWitness', '10': 'boundWitnesses'},
  ],
};

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

const DeviceBoundWitness_HueresticsEntry$json = const {
  '1': 'HueresticsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': const {'7': true},
};

