import 'package:flutter/material.dart';
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:sdk_xyo_flutter/protos/bound_witness.pbserver.dart';
import 'package:sdk_xyo_flutter/sdk/XyoNodeBuilder.dart';
import 'package:sdk_xyo_flutter/sdk/XyoNode.dart';
import 'package:sdk_xyo_flutter/sdk_xyo_flutter.dart';
import 'package:sdk_xyo_flutter/protos/device.pbserver.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isClient = true;
  XyoNode _xyoNode;
  String _publicKey = "";
  bool _scanning = false;

  String _payloadString;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await buildXyo();
    _xyoNode.getClient('ble').addListener(() {
      setState(() {
        _scanning = _xyoNode.getClient('ble').scan;
      });
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> buildXyo() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    final builder = XyoNodeBuilder();
    final xyoNode = await builder.build();

    if (!mounted) return;

    setState(() {
      _xyoNode = xyoNode;
    });
    /*} on PlatformException {
      print("Received Platform Exception");
    }*/
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
    if (_xyoNode == null) {
      return Center(child: CircularProgressIndicator());
    }
    String nodeType = _isClient ? "Client" : "Server";
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('XY $nodeType Config'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              children: <Widget>[
                RaisedButton(
                    onPressed: () async {
                      String address = _isClient
                          ? await _xyoNode.getClient('ble').getPublicKey()
                          : await _xyoNode.getServer('ble').getPublicKey();
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
                      _xyoNode.getClient('ble').scan = isOn;
                    },
                    value: _scanning,
                  ),
                ],
              ),
            if (!_isClient)
              Row(
                children: <Widget>[
                  Text("Toggle Server Listening"),
                  Switch(
                    onChanged: (isOn) async {
                      _xyoNode.getServer('ble').listen = isOn;
                    },
                    value: _xyoNode.getServer('ble').listen,
                  ),
                ],
              ),
            Row(
              children: <Widget>[
                Text("Toggle Bridging on $nodeType"),
                Switch(
                  onChanged: (isOn) async {
                    if (_isClient) {
                      _xyoNode.getClient('ble').autoBridge = isOn;
                    } else {
                      _xyoNode.getServer('ble').autoBridge = isOn;
                    }
                  },
                  value: _isClient ? _xyoNode.getClient('ble').autoBridge : _xyoNode.getServer('ble').autoBridge,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Flexible(
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Enter $nodeType payload'),
                      onChanged: (newVal) => setState(() {
                        _payloadString = newVal;
                      }),
                    ),
                  ),
                ),
                if (_payloadString != null)
                  Flexible(
                    flex: 2,
                    child: RaisedButton(
                        child: Text(
                          "Set $nodeType Payload: $_payloadString",
                          softWrap: true,
                        ),
                        onPressed: () {
                          if (_isClient) {
                            _xyoNode.getClient('ble').stringHeuristic = _payloadString;
                          } else {
                            _xyoNode.getServer('ble').stringHeuristic = _payloadString;
                          }
                        }),
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
            if (_isClient)
              Flexible(
                flex: 3,
                child: StreamBuilder<List<DeviceBoundWitness>>(
                  stream: _xyoNode.getClient('ble').onBoundWitnessSuccess(),
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
            if (!_isClient)
              Flexible(
                flex: 3,
                child: StreamBuilder<List<DeviceBoundWitness>>(
                  stream: _xyoNode.getServer('ble').onBoundWitnessSuccess(),
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
