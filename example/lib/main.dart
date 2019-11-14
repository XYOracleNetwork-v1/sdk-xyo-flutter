import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sdk_xyo_flutter/sdk_xyo_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sdk_xyo_flutter/protos/bound_witness.pbserver.dart';
import 'package:sdk_xyo_flutter/protos/device.pbserver.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isClient = true;
  String _buildMessage = 'Unknown';
  String _publicKey = "";
  bool _bridging = false;
  bool _scanning = false;
  bool _listening = false;
  String _payloadString;
  @override
  void initState() {
    super.initState();
    buildXyo();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> buildXyo() async {
    String buildMessage;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      buildMessage = await XyoNode.instance.build;
    } on PlatformException {
      buildMessage = 'Failed to build XYO.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _buildMessage = buildMessage;
    });
  }

  Widget _buildTile(DeviceBoundWitness s) {
    final fmt = DateFormat("MMMM dd, h:mm a");

    return ListTile(
      title: Text(
        "${s.parties} - ${s.huerestics}",
        softWrap: true,
      ),
      subtitle: Text(fmt.format(DateTime.now())),
    );
  }

  Widget _buildDeviceTile(BluetoothDevice s) {
    final fmt = DateFormat("MMMM dd, h:mm a");

    return ListTile(
      title: Text(
        "${s.family.name} ${s.family.prefix} - ${s.family.uuid} ",
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
      subtitle: Text("RSSI: ${s.rssi}"),
      trailing: s.connected
          ? Icon(
              Icons.link,
              color: Colors.green,
            )
          : Icon(Icons.link_off),
    );
  }

  @override
  Widget build(BuildContext context) {
    String nodeType = _isClient ? "Client" : "Server";
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('XYO $nodeType Config'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              children: <Widget>[
                RaisedButton(
                    onPressed: () async {
                      String address =
                          await XyoNode.instance.getPublicKey(_isClient);
                      setState(() {
                        _publicKey = address;
                      });
                    },
                    child: Text("View Public Key")),
                if (_publicKey != "")
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: Text(
                      "${_publicKey.toString()}",
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
              ],
            ),
            Row(
              children: <Widget>[
                Text("$nodeType Config"),
                Switch(
                    onChanged: (isOn) {
                      setState(() {
                        _isClient = isOn;
                      });
                    },
                    value: _isClient),
              ],
            ),
            if (_isClient)
              Row(
                children: <Widget>[
                  Text("Toggle Client BW Scanning"),
                  Switch(
                      onChanged: (isOn) async {
                        bool result = await XyoNode.instance.setScanning(isOn);
                        setState(() {
                          _scanning = isOn;
                        });
                      },
                      value: _scanning),
                ],
              ),
            if (!_isClient)
              Row(
                children: <Widget>[
                  Text("Toggle Server Listening"),
                  Switch(
                      onChanged: (isOn) async {
                        bool result = await XyoNode.instance.setListening(isOn);
                        setState(() {
                          _listening = isOn;
                        });
                      },
                      value: _listening),
                ],
              ),
            Row(
              children: <Widget>[
                Text("Toggle Bridging on $nodeType"),
                Switch(
                    onChanged: (isOn) async {
                      bool result =
                          await XyoNode.instance.setBridging(_isClient, isOn);
                      setState(() {
                        _bridging = isOn;
                      });
                    },
                    value: _bridging),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: 200,
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter $nodeType payload'),
                      onChanged: (newVal) => setState(() {
                        _payloadString = newVal;
                      }),
                    ),
                  ),
                ),
                if (_payloadString != null)
                  Container(
                    width: 150,
                    child: RaisedButton(
                      child: Text(
                        "Set $nodeType Payload: $_payloadString",
                        softWrap: true,
                      ),
                      onPressed: () => XyoNode.instance
                          .setPayloadString(_isClient, _payloadString),
                    ),
                  )
              ],
            ),
            Text("Detected Devices:"),
            Flexible(
              flex: 1,
              child: StreamBuilder<BluetoothDevice>(
                stream: XyoScanner.instance.onDeviceDetected(),
                builder: (context, snapshot) {
                  final bws = snapshot.data;
                  if (bws == null) return Container();
                  return _buildDeviceTile(bws);
                },
              ),
            ),
            Text("Bound Witnesses:"),
            Flexible(
              flex: 3,
              child: StreamBuilder<List<DeviceBoundWitness>>(
                stream: XyoNode.instance.onBoundWitnessSuccess(),
                builder: (context, snapshot) {
                  final bws = snapshot.data;
                  if (bws == null) return Container();
                  final count = bws.length;
                  return ListView.builder(
                      itemCount: count,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildTile(bws[index]);
                      });
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
