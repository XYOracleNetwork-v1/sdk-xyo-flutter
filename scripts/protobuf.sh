#!/bin/sh
protoc --dart_out="./lib" "./protos/bound_witness.proto"
protoc --dart_out="./lib" "./protos/device.proto"
protoc --dart_out="./lib" "./protos/gatt.proto"

protoc --swift_out="./ios/Classes" "./protos/bound_witness.proto"
protoc --swift_out="./ios/Classes" "./protos/device.proto"
protoc --swift_out="./ios/Classes" "./protos/gatt.proto"

#Note: Android Generates automatically at build