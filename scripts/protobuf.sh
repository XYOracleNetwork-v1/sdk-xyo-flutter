#!/bin/sh
protoc --dart_out="./lib" "./protos/bound_witness.proto"
protoc --dart_out="./lib" "./protos/device.proto"
protoc --dart_out="./lib" "./protos/gatt.proto"