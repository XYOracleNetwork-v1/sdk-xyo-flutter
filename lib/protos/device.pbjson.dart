///
//  Generated code. Do not modify.
//  source: protos/device.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const Family$json = const {
  '1': 'Family',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'prefix', '3': 2, '4': 1, '5': 9, '10': 'prefix'},
    const {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'id', '3': 4, '4': 1, '5': 9, '10': 'id'},
  ],
};

const Range$json = const {
  '1': 'Range',
  '2': const [
    const {'1': 'min', '3': 1, '4': 1, '5': 18, '10': 'min'},
    const {'1': 'max', '3': 2, '4': 1, '5': 18, '10': 'max'},
  ],
};

const IBeacon$json = const {
  '1': 'IBeacon',
  '2': const [
    const {'1': 'major', '3': 1, '4': 1, '5': 3, '10': 'major'},
    const {'1': 'minor', '3': 2, '4': 1, '5': 3, '10': 'minor'},
    const {'1': 'uuid', '3': 3, '4': 1, '5': 9, '10': 'uuid'},
  ],
};

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

