// members.dart
// Changelog:
// 20-05: Initial Code / Commit - Harrison

// Import required libaries / packages
import 'package:flutter/material.dart';
import 'package:management_console_mobile/main.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

// Start MembersPage

class MembersPage extends StatefulWidget {
  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  @override
  Widget build(BuildContext context) {
    // Create a basic app scaffold with appbar, drawer, body and floating btn
    return Scaffold(
      appBar: globals.MyAppBar(
        title: "Members",
      ),
      drawer: globals.MyDrawer(),
      body: MembersPageBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Hello, World!');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class MembersPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget page = FutureBuilder<dynamic>(
        future: membersReady(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data);
            return new ListView.builder(
                itemCount: data?.length,
                itemBuilder: (context, index) {
                  return new Card(
                    child: ListTile(
                      title: new Text("${data[index]["username"]}",
                          style: globals.style.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      onTap: () {},
                    ),
                  );
                });
          } else {
            return CircularProgressIndicator();
          }
        });
    return page;
  }
}

Future<dynamic> membersReady() async {
  var result;
  try {
    http.Response response = await http.post(
      globals.apiUrl,
      body: <String, String>{
        "formname": "membersReady",
        "username": globals.currentUsername,
        "password": globals.currentPassword
      },
    );
    result = response.body;
  } catch (e) {
    globals.retryFuture(membersReady, 2000, MembersPage);
  }
  return result;
}

// AddNewMemberPage
class AddNewMemberPage extends StatefulWidget {
  @override
  _AddNewMemberState createState() => _AddNewMemberState();
}

class _AddNewMemberState extends State<AddNewMemberPage> {
  // Set text field controllers
  final _userNameController = TextEditingController();
  final _emailFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Setup Input Fields

    final userNameField = TextFormField(
      controller: _userNameController,
      style: globals.style,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: 'Username',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      // TODO: Add field submitted
    );

    final emailField = TextFormField(
      controller: _emailFieldController,
      style: globals.style,
      decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      // TODO Add field submitted.
    );
  }
}
