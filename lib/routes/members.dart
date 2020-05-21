// members.dart
// Changelog:
// 20-05: Initial Code / Commit - Harrison

// Import required libaries / packages
import 'package:flutter/material.dart';
import 'package:management_console_mobile/main.dart' as globals;

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
      ), body: Center(child: Text('Members'),),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      // TODO: Add field submitted
    );

    final emailField = TextFormField(
      controller: _emailFieldController,
      style: globals.style,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      // TODO Add field submitted.
    );
  }
}