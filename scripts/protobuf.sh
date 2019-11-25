#!/bin/sh
protoc --dart_out="./lib" ./protos/*.proto

protoc --swift_out="./ios/Classes" ./protos/*.proto