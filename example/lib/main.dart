import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sdk_xyo_flutter/sdk_xyo_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sdk_xyo_flutter/protos/bound_witness.pbserver.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _buildMessage = 'Unknown';
  String _publicKey = "";
  bool _bridging = false;
  bool _scanning = false;
  bool _listening = false;

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
      buildMessage = await SdkXyoFlutter.build;
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
        "${s.humanName.toString()} ${s.parties.toString()}",
        softWrap: true,
      ),
      subtitle: Text(fmt.format(DateTime.now())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('XYO Flutter SDK example app'),
        ),
        body: Column(children: [
          Text('Running on: $_buildMessage\n'),
          RaisedButton(
              onPressed: () async {
                String address = await SdkXyoFlutter.getPublicKey;
                setState(() {
                  _publicKey = address;
                });
              },
              child: Text("Get Public Key")),
          if (_publicKey != "") Text("Public Key: ${_publicKey.toString()}"),
          Text("Toggle Scanning"),
          Switch(
              onChanged: (isOn) async {
                bool result = await SdkXyoFlutter.setScanning(isOn);
                setState(() {
                  _scanning = isOn;
                });
              },
              value: _scanning),
          Text("Toggle Listening"),
          Switch(
              onChanged: (isOn) async {
                bool result = await SdkXyoFlutter.setListening(isOn);
                setState(() {
                  _listening = isOn;
                });
              },
              value: _listening),
          Text("Toggle Bridging"),
          Switch(
              onChanged: (isOn) async {
                bool result = await SdkXyoFlutter.setBridging(isOn);
                setState(() {
                  _bridging = isOn;
                });
              },
              value: _bridging),
          Flexible(
            child: StreamBuilder<List<DeviceBoundWitness>>(
              stream: SdkXyoFlutter.onBoundWitnessStart(),
              builder: (context, snapshot) {
                final bws = snapshot.data;
                if (bws == null) return Container();
                final count = bws.length;
                return ListView.builder(
                    itemCount: count,
                    itemBuilder: (BuildContext context, int index) {
                      print("here");
                      return _buildTile(bws[index]);
                    });
              },
            ),
          )
        ]),
      ),
    );
  }
}
