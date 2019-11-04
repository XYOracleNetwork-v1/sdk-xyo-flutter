import 'package:flutter/material.dart';
import 'package:sdk_xyo_flutter/main.dart';

import 'node.dart';

class SentinelSection extends StatelessWidget {
  final Function(dynamic) _setMessage;

  SentinelSection(this._setMessage);

  Future<void> _start() async {
    try {
      _setMessage(await XyoSdk.sentinel.start());
    } catch (ex) {
      _setMessage(ex.message);
    }
  }

  Future<void> _stop() async {
    try {
      _setMessage(await XyoSdk.sentinel.stop());
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
                future: XyoSdk.sentinel.status,
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
          ],
        ),
        NodeSection(_setMessage, XyoSdk.sentinel)
      ],
    );
  }
}
