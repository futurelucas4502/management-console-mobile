//Start Imports
library my_prj.globals;
import 'package:flutter/material.dart';
import 'package:management_console_mobile/routes/login.dart';
import 'package:management_console_mobile/routes/main.dart';
import 'package:management_console_mobile/routes/payments.dart';
var currentUsername;
var currentPassword;
var privileges;
TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
//End Imports

//App Start point

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Management Console',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login' : (context) => LoginPage(),
        '/main' : (context) => MainPage(),
        '/payments' : (context) => PaymentsPage(),
      },
    );
  }
}

//End Start point

//Drawer code

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
                            style: style.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => PaymentsPage()),
                      );
                    },
                  ),
                ),
                if (privileges == "1")
                  Card(
                    child: ListTile(
                      title: Center(
                          child: Text("Acccounting",
                              style: style.copyWith(
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
                if (privileges == "1")
                  Card(
                    child: ListTile(
                      title: Center(
                          child: Text("Members",
                              style: style.copyWith(
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
                            style: style.copyWith(
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
                            style: style.copyWith(
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
                            style: style.copyWith(
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
                            style: style.copyWith(
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
                            style: style.copyWith(
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
                            style: style.copyWith(
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

//End drawer code

//Start Retry load data function

retryFuture(future, delay, route) {
  //Any future/function name and a delay and it will work
  Future.delayed(Duration(milliseconds: delay), () {
    route.future();
  });
}

//End Retry load data function
