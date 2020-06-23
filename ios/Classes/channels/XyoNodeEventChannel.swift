//
//  XyoBoundWitnessEventChannel.swift
//  sdk_xyo_flutter
//
//  Created by Kevin Weiler on 11/21/19.
//

import Foundation
import sdk_xyo_swift
import Flutter
import sdk_core_swift

// Wraps up the event listener and the event sink, used by the wrapper below
internal class XyoNodeStreamHandler: NSObject, FlutterStreamHandler {

    var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

}


class XyoNodeEventChannel : BoundWitnessDelegate {
  let bwStartedHandler = XyoNodeStreamHandler()
  let bwCompletedHandler = XyoNodeStreamHandler()
  let _hasher : XyoHasher;
  
  init(channelPrefix: String, with registrar: FlutterPluginRegistrar, with hasher: XyoHasher) {
    _hasher = hasher
    let bwStarted = FlutterEventChannel(name: channelPrefix + "Started", binaryMessenger: registrar.messenger())
    let bwEnded = FlutterEventChannel(name: channelPrefix + "Ended", binaryMessenger: registrar.messenger())
    bwStarted.setStreamHandler(bwStartedHandler)
    bwEnded.setStreamHandler(bwCompletedHandler)
  }
  
  private func hashToBoundWitnesses(hash: XyoObjectStructure, _ originalBw: XyoBoundWitness) -> DeviceBoundWitness {
    let model = InteractionModel(hash.getBuffer().toByteArray(), date: Date(), boundWitness: originalBw, linked: true)
    return model.toBuffer
  }
  
  func boundWitness(started withDeviceId: String) {
    print("Started BW with \(withDeviceId)")
    bwStartedHandler.eventSink?(withDeviceId)
  }
  
  func boundWitness(completed withDeviceId: String, withBoundWitness: XyoBoundWitness?) {
    print("Completed BW with \(withDeviceId)")
    
    if let bw = withBoundWitness {
      do {
        if try bw.getNewIterator().hasNext() {
          if let sink = bwCompletedHandler.eventSink {
            let hash = try bw.getHash(hasher: _hasher)
            let boundWitness = hashToBoundWitnesses(hash: hash, bw)
            try sink(boundWitness.serializedData())
          }
        }
      } catch {
        print("Error thrown \(error)")
      }
    }
  }
  
  func boundWitness(failed withDeviceId: String?, withError: XyoError) {
    print("Errored BW with \(String(describing: withDeviceId)) \(String(describing: withError))")
  }
  

}
