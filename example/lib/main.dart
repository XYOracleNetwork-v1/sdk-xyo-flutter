import 'package:flutter/material.dart';

import 'sections/bridge.dart';
import 'sections/sentinel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XYO SDK Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'XYO Flutter SDK Test Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var message = "";

  void _setMessage(dynamic msg) {
    setState(() {
      message = msg.toString();
    });
  }

  void _clear() {
    _setMessage("");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: EdgeInsets.all(5),
          child: ListView(
            children: <Widget>[
              MaterialButton(
                child: Text("Clear"),
                color: Colors.blue,
                textColor: Colors.white,
                padding: EdgeInsets.all(5),
                onPressed: _clear,
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                  child: Text(message),
                ),
              ),
              Divider(),
              Text("Sentinel"),
              SentinelSection(_setMessage),
              Text("Bridge"),
              BridgeSection(_setMessage),
            ],
          ),
        ));
  }
}
