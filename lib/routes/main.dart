import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart' as globals;

//Main Page Code

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main",
            style: globals.style
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      drawer: globals.MyDrawer(),
      body: Container(
        alignment: Alignment.topRight,
        margin: new EdgeInsets.only(top: 20.0, right: 20.0),
        child: FutureBuilder(
            future: mainReady(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return Text('Total Members: ${snapshot.data}',
                    style: globals.style.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold));
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}

Future<String> mainReady() async {
  var result;
  try {
    http.Response response = await http.post(
      'https://lucas-testing.000webhostapp.com',
      body: <String, String>{
        "formname": "mainReady",
        "username": globals.currentUsername,
        "password": globals.currentPassword
      },
    );
    result = json.decode(response.body);
  } catch (e) {
    globals.retryFuture(mainReady, 2000, MainPage);
  }
  return ((result).length).toString();
}

//End Main page code