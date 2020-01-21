import 'package:flutter/material.dart';
import 'dart:async';

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
  bool _listening = false;
  bool _autoBridging = false;

  String _payloadString;
  String _payloadStringTemp;

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initS();
  }

  void _initS() async {
    await buildXyo();
    _xyoNode.getClient('ble').addListener(() {
      setState(() {
        _scanning = _xyoNode.getClient('ble').scan;
        _autoBridging = _xyoNode.getClient('ble').autoBridge;
        _payloadString = _xyoNode.getClient('ble').payloadData;
        textController.text = _payloadString ?? "";
      });
    });
    _xyoNode.getServer('ble').addListener(() {
      setState(() {
        _autoBridging = _xyoNode.getServer('ble').autoBridge;
        _listening = _xyoNode.getServer('ble').listen;
        _payloadString = _xyoNode.getServer('ble').payloadData;
        textController.text = _payloadString ?? "";
      });
    });
    XyoScanner().setListening(true);
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
    // final fmt = DateFormat("MMMM dd, h:mm a");

    return ListTile(
      title: Text(
        "${s.parties} - ${s.huerestics}",
        softWrap: true,
      ),
      // subtitle: Text(fmt.format(DateTime.now())),
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
                InputChip(
                  label: Text("Client"),
                  selected: _isClient,
                  onSelected: (selected) {
                    setState(() {
                      _isClient = selected;
                    });
                  },
                ),
                InputChip(
                    label: Text("Server"),
                    selected: !_isClient,
                    onSelected: (selected) {
                      setState(() {
                        _isClient = !selected;
                      });
                    }),
              ],
            ),
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
                    value: _listening,
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
                  value: _autoBridging,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Flexible(
                    flex: 3,
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter $nodeType payload'),
                      onChanged: (newVal) => setState(() {
                        _payloadStringTemp = newVal;
                      }),
                    ),
                  ),
                ),
                if (_payloadStringTemp != null)
                  Flexible(
                    flex: 2,
                    child: RaisedButton(
                        child: Text(
                          "Set $nodeType Payload: $_payloadStringTemp",
                          softWrap: true,
                        ),
                        onPressed: () {
                          if (_isClient) {
                            _xyoNode.getClient('ble').stringHeuristic =
                                _payloadStringTemp;
                          } else {
                            _xyoNode.getServer('ble').stringHeuristic =
                                _payloadStringTemp;
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
