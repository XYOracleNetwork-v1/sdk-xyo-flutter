import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sdk_xyo_flutter/sdk_xyo_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _buildMessage = 'Unknown';

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
      buildMessage = await SdkXyoFlutter.buildXyo;
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('XYO Flutter SDK example app'),
        ),
        body: Center(
          child: Text('Running on: $_buildMessage\n'),
        ),
      ),
    );
  }
}
