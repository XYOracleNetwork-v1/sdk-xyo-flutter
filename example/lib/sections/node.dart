import 'package:flutter/material.dart';
import 'package:sdk_xyo_flutter/channels/node.dart';

class NodeSection extends StatelessWidget {
  final Function(dynamic) _setMessage;
  final XyoNodeChannel _node;

  NodeSection(this._setMessage, this._node);

  Future<void> _getPublicKey() async {
    try {
      _setMessage(await _node.publicKey);
    } catch (ex) {
      _setMessage(ex.message);
    }
  }

  Future<void> _getBlockCount() async {
    try {
      _setMessage(await _node.blockCount);
    } catch (ex) {
      _setMessage(ex.message);
    }
  }

  Future<void> _getLastBlock() async {
    try {
      final block = await _node.lastBlock;
      _setMessage(block.writeToJson());
    } catch (ex) {
      _setMessage("Message: ${ex?.message}\nDetails:${ex?.details}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MaterialButton(
          child: Text("Public Key"),
          color: Colors.blue,
          textColor: Colors.white,
          padding: EdgeInsets.all(5),
          onPressed: _getPublicKey,
        ),
        Text(" "), //just for space
        MaterialButton(
          child: Text("Block Count"),
          color: Colors.blue,
          textColor: Colors.white,
          padding: EdgeInsets.all(5),
          onPressed: _getBlockCount,
        ),
        Text(" "), //just for space
        MaterialButton(
          child: Text("Last Block"),
          color: Colors.blue,
          textColor: Colors.white,
          padding: EdgeInsets.all(5),
          onPressed: _getLastBlock,
        ),
      ],
    );
  }
}
