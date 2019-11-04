import 'package:flutter/material.dart';
import 'package:sdk_xyo_flutter/main.dart';

import 'node.dart';

class BridgeSection extends StatelessWidget {
  final Function(dynamic) _setMessage;

  BridgeSection(this._setMessage);

  Future<void> _start() async {
    try {
      try {
        _setMessage(await XyoSdk.bridge.start());
      } catch (ex) {
        _setMessage("Unexpected Local: $ex");
      }
    } catch (ex) {
      _setMessage("Unexpected Global: $ex");
    }
  }

  Future<void> _stop() async {
    try {
      _setMessage(await XyoSdk.bridge.stop());
    } catch (ex) {
      _setMessage(ex.message);
    }
  }

  Future<void> _setArchivists() async {
    try {
      _setMessage(await XyoSdk.bridge.setArchivists([]));
    } catch (ex) {
      _setMessage(ex.message);
    }
  }

  Future<void> _selfSign() async {
    try {
      _setMessage(await XyoSdk.bridge.selfSign());
    } catch (ex) {
      _setMessage(ex.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            FutureBuilder(
                future: XyoSdk.bridge.status,
                builder: (context, result) {
                  final status = result.data;
                  return (status != null) ? Text("[Status=$status]") : Text("[...]");
                }),
          ],
        ),
        Row(
          children: [
            MaterialButton(
              child: Text("Start"),
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(5),
              onPressed: _start,
            ),
            Text(" "), //just for space
            MaterialButton(
              child: Text("Stop"),
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(5),
              onPressed: _stop,
            ),
            Text(" "), //just for space
            MaterialButton(
              child: Text("Archivists"),
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(5),
              onPressed: _setArchivists,
            ),
            Text(" "), //just for space
            MaterialButton(
              child: Text("Sign"),
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(5),
              onPressed: _selfSign,
            ),
          ],
        ),
        NodeSection(_setMessage, XyoSdk.bridge),
      ],
    );
  }
}
