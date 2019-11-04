///
//  Generated code. Do not modify.
//  source: protos/gatt.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const DefinedOperation$json = const {
  '1': 'DefinedOperation',
  '2': const [
    const {'1': 'STAY_AWAKE', '2': 0},
    const {'1': 'GO_TO_SLEEP', '2': 1},
    const {'1': 'LOCK', '2': 2},
    const {'1': 'UNLOCK', '2': 3},
    const {'1': 'SONG', '2': 4},
    const {'1': 'STOP_SONG', '2': 5},
    const {'1': 'PUBLIC_KEY', '2': 6},
  ],
};

const GattOperationList$json = const {
  '1': 'GattOperationList',
  '2': const [
    const {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'operations', '3': 2, '4': 3, '5': 11, '6': '.GattOperation', '10': 'operations'},
    const {'1': 'disconnect_on_completion', '3': 3, '4': 1, '5': 8, '10': 'disconnectOnCompletion'},
  ],
};

const GattCall$json = const {
  '1': 'GattCall',
  '2': const [
    const {'1': 'service_uuid', '3': 1, '4': 1, '5': 9, '10': 'serviceUuid'},
    const {'1': 'characteristic_uuid', '3': 2, '4': 1, '5': 9, '10': 'characteristicUuid'},
  ],
};

const GattOperation$json = const {
  '1': 'GattOperation',
  '2': const [
    const {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'defined_operation', '3': 2, '4': 1, '5': 14, '6': '.DefinedOperation', '9': 0, '10': 'definedOperation'},
    const {'1': 'gatt_call', '3': 3, '4': 1, '5': 11, '6': '.GattCall', '9': 0, '10': 'gattCall'},
    const {'1': 'write_request', '3': 4, '4': 1, '5': 11, '6': '.GattOperation.Write', '10': 'writeRequest'},
    const {'1': 'disconnect_on_completion', '3': 5, '4': 1, '5': 8, '10': 'disconnectOnCompletion'},
  ],
  '3': const [GattOperation_Write$json],
  '8': const [
    const {'1': 'operation'},
  ],
};

const GattOperation_Write$json = const {
  '1': 'Write',
  '2': const [
    const {'1': 'request', '3': 1, '4': 1, '5': 12, '10': 'request'},
    const {'1': 'requires_response', '3': 2, '4': 1, '5': 8, '10': 'requiresResponse'},
  ],
};

const GattResponseList$json = const {
  '1': 'GattResponseList',
  '2': const [
    const {'1': 'responses', '3': 1, '4': 3, '5': 11, '6': '.GattResponse', '10': 'responses'},
  ],
};

const GattResponse$json = const {
  '1': 'GattResponse',
  '2': const [
    const {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'defined_operation', '3': 2, '4': 1, '5': 14, '6': '.DefinedOperation', '9': 0, '10': 'definedOperation'},
    const {'1': 'gatt_call', '3': 3, '4': 1, '5': 11, '6': '.GattCall', '9': 0, '10': 'gattCall'},
    const {'1': 'response', '3': 4, '4': 1, '5': 12, '10': 'response'},
    const {'1': 'error', '3': 5, '4': 1, '5': 9, '10': 'error'},
  ],
  '8': const [
    const {'1': 'operation'},
  ],
};

