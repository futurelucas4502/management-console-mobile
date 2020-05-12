import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'globals.dart' as globals;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Management Console',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(title: 'Login'),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _myUsername = TextEditingController();
  final _myPassword = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final usernameField = TextField(
      controller: _myUsername,
      obscureText: false,
      style: globals.style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      controller: _myPassword,
      obscureText: true,
      style: globals.style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff007bff),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (_myUsername.text == "" ||
              _myPassword.text == "" ||
              _myUsername.text == null ||
              _myPassword.text == null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Login Error"),
                  content: new Text("Username or password cannot be empty!"),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            _login(_myUsername.text, _myPassword.text, context);
            setState(() {
              isLoading = true;
            });
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: globals.style
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Center(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 155.0,
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 45.0),
                      usernameField,
                      SizedBox(height: 25.0),
                      passwordField,
                      SizedBox(
                        height: 35.0,
                      ),
                      loginButon,
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _login(usernameField, passwordField, context) async {
    globals.currentUsername = usernameField;
    encryptFunc(passwordField);

    http.Response response = await http.post(
      'https://lucas-testing.000webhostapp.com',
      body: <String, String>{
        "formname": "login",
        "username": globals.currentUsername,
        "password": globals.currentPassword,
        "datetime": DateFormat("yyyy-MM-dd HH:mm:ss")
            .format(DateTime.now()) // MySql Datetime format
      },
    );

    setState(() {
      isLoading = false;
    });

    if (response.body == "1") {
      globals.privileges = "1";
    } else if (response.body == "0") {
      globals.privileges = "0";
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Login Error"),
            content: new Text(
                "Please check your username and password are correct and that you have an internet connection."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }
}

void encryptFunc(password) {
  final key = encrypt.Key.fromUtf8('eb45707674371ce8259b2153c7b6a453');
  final iv = encrypt.IV.fromUtf8('70cd8558247bed84');
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  globals.currentPassword = (encrypter.encrypt(password, iv: iv)).base64;
}

void logout(context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
  globals.currentUsername = null;
  globals.currentPassword = null;
  globals.privileges = null;
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // column holds all the widgets in the drawer
      child: Column(
        children: <Widget>[
          Expanded(
            // ListView contains a group of widgets that scroll inside the drawer
            child: ListView(
              children: <Widget>[
                Card(
                  child: ListTile(
                    title: Center(
                        child: Text("Payments",
                            style: globals.style.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Center(
                        child: Text("Acccounting",
                            style: globals.style.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Center(
                        child: Text("Members",
                            style: globals.style.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Center(
                        child: Text("Events",
                            style: globals.style.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Center(
                        child: Text("Events Attending",
                            style: globals.style.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Center(
                        child: Text("Main",
                            style: globals.style.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Center(
                        child: Text("Messaging",
                            style: globals.style.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // This container holds the align
          Container(
              // This align moves the children to the bottom
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  // This container holds all the children that will be aligned
                  // on the bottom and should not scroll with the above ListView
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings',
                            style: globals.style.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Logout',
                            style: globals.style.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        onTap: () {
                          logout(context);
                        },
                      )
                    ],
                  ))))
        ],
      ),
    );
  }
}

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
      drawer: MyDrawer(),
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
    retryFuture(mainReady, 2000);
  }
  return ((result).length).toString();
}

retryFuture(future, delay) {
  Future.delayed(Duration(milliseconds: delay), () {
    future();
  });
}
