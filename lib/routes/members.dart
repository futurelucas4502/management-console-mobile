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
      body: FutureBuilder<dynamic>(
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
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MemberExpandPage(userdata: data[index])));
                        },
                      ),
                    );
                  });
            } else {
              return Container(
                  alignment: Alignment.topRight,
                  margin: new EdgeInsets.only(top: 20.0, right: 20.0),
                  child: CircularProgressIndicator());
            }
          }),
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
//End

//Member Expand Page
class MemberExpandPage extends StatefulWidget {
  final Map<dynamic, dynamic> userdata;
  MemberExpandPage({this.userdata}) : super();
  @override
  _MemberExpandState createState() => _MemberExpandState();
}

class _MemberExpandState extends State<MemberExpandPage> {
  // Create a "global" key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  var firstLoad = true;
  String dropdownValue = "";
  @override
  Widget build(BuildContext context) {
    var data = widget.userdata;
    if (firstLoad) {
      dropdownValue = data["Privileges"].toString() == "1" ? "Admin" : "Standard";
      firstLoad = false;
    }
    return Scaffold(
      appBar: globals.MyAppBar(
        title: "Editing member: ${data["username"]}",
      ),
      body: Builder(
        // Create an inner BuildContext so that the onPressed methods
        // can refer to the Scaffold with Scaffold.of().
        builder: (BuildContext context) {
          return Card(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          enabled: false,
                          initialValue: data["username"].toString(),
                          style: globals.style.copyWith(
                            color: Colors.grey[600],
                          ),
                          decoration: const InputDecoration(
                            enabled: false,
                            icon: Icon(
                              Icons.person,
                              size: 40,
                            ),
                            hintText: 'Username',
                            labelText: 'Username',
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: data["email"].toString(),
                          style: globals.style.copyWith(
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.alternate_email,
                              size: 40,
                            ),
                            hintText: 'Email',
                            labelText: 'Email',
                          ),
                        ),
                        InputDecorator(
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.supervised_user_circle,
                              size: 40,
                            ),
                            hintText: 'User type',
                            labelText: 'User type',
                          ),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                            style: globals.style.copyWith(
                              color: Colors.black,
                            ),
                            value: dropdownValue,
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>['Standard', 'Admin']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false
                              // otherwise.
                              if (_formKey.currentState.validate()) {
                                // If the form is valid, display a Snackbar.
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Updating Data...')));
                              }
                            },
                            child: Text('Submit'),
                          ),
                        ),
                      ],
                    ))),
          );
        },
      ),
    );
  }
}

//End Member Expand Page

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
