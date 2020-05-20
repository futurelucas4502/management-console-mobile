// password-reset.dart
// Changelog:
// 20-05: Inital code / Commit - Harrison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:management_console_mobile/routes/login.dart';
import 'package:http/http.dart' as http;
import 'package:management_console_mobile/routes/login.dart' as login;
import '../main.dart' as globals;

// Start passwordResetPage

String code;

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordResetPage> {
  final _myEmail = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 77.5,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextFormField(
      controller: _myEmail,
      style: globals.style,
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      textInputAction: TextInputAction.go,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      onFieldSubmitted: (term) {
        _validateEmail();
      },
    );

    final submitEmailBtn = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff007bff),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          _validateEmail();
        },
        child: Text('Submit Email', style: globals.style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
    );

    final goBackBtn = FlatButton(
      child: Text(
        'Go Back',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.pop(context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );

    // Return a scaffold of elements to build the widget
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: isLoading 
        ? Center(child: CircularProgressIndicator(),)
        : ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 24.0),
            submitEmailBtn,
            goBackBtn
          ],
        )
      ),
    );
  }

  void _validateEmail() {
    // Check if email has been entered
    if (_myEmail.text == "" || _myEmail.text == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // Return Alert Dialog
          return AlertDialog(
            title: new Text('Password Reset Error'),
            content: new Text('Please enter an email'),
            actions: <Widget>[
              // Show button at bottom of alert
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    } else {
      _generateCode(_myEmail.text);
      setState(() {
        isLoading = true;
      });
    }
  }

  void _generateCode(String email) async {
    http.Response response = await http.post(
      'https://thecityoftruromariners.futurelucas4502.co.uk',
      body: <String, String> {
        'formname': 'resetPassword',
        'email': email,
        'datetime': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
      }
    );

    setState(() {
      isLoading = false;
    });

    if (response.body == "Success") {
      // Show enterCodePage
      Navigator.push(context, MaterialPageRoute(builder: (context) => EnterCodePage()));
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          // Return Alert Dialog
          return AlertDialog(
            title: new Text('Password Reset Error'),
            content: new Text('Please check your email and thast you have a active internet connection'),
            actions: <Widget>[
              // Show button at hottom of alarrt
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }
  }
}

class EnterCodePage extends StatefulWidget {
  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCodePage>{

  final _myCode = TextEditingController();
  
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    // Build code input
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 77.5,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final codeInput = TextFormField(
      controller: _myCode,
      style: globals.style,
      autofocus: true,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly
      ],
      textInputAction: TextInputAction.go,
      decoration: InputDecoration(
        hintText: 'Verification Code',
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      onFieldSubmitted: (term) {
        _verifyCode();
      },
    );

    final submitCodeBtn = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff007bff),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        child: Text('Submit Verification Code',
          style: globals.style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          _verifyCode();
        },
      ),
    );

    final goBackBtn = FlatButton(
      child: Text('Go Back', style: TextStyle(color: Colors.black54)),
      onPressed: () {
        Navigator.pop(context, MaterialPageRoute(builder: (context) => PasswordResetPage()));
      },
    );

    // Return a scaffold of elements to build the widget
    return Scaffold(
      body: Center(
        child: isLoading ? Center(child: CircularProgressIndicator()) 
        : ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            codeInput,
            SizedBox(height: 24.0),
            submitCodeBtn,
            goBackBtn
          ],
        ),
      )
    );
  }

  void _verifyCode() {
    if (_myCode.text == '' || _myCode.text == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // Return alert dialog
          return AlertDialog(
            title: new Text('Verification Error'),
            content: new Text('Please enter a verification code'),
            actions: <Widget>[
              // Show button at bottom of alart
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    } else if (_myCode.text.length <=0 || _myCode.text.length >4) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // Return alert dialog
          return AlertDialog(
            title: new Text('Verification Error'),
            content: new Text('Please enter the 4 digit verification code that has been emailed to you'),
            actions: <Widget>[
              // Show button at bottom of alart
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    } else {
      code = _myCode.text;
      // Send user to new password widget
      Navigator.push(context, MaterialPageRoute(builder: (context) => NewPasswordWidget()));
    }
  }
}

// New Password Widget

class NewPasswordWidget extends StatefulWidget {
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPasswordWidget> {

  final _passwordField = TextEditingController();
  final _passwordVerify = TextEditingController();

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _verifyFocus = FocusNode();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 77.5,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final passwordField = TextFormField(
      controller: _passwordField,
      obscureText: true,
      style: globals.style,
      focusNode: _passwordFocus,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'New Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _passwordFocus, _verifyFocus);
      },
    );

    final verifyField = TextFormField(
      controller: _passwordVerify,
      obscureText: true,
      style: globals.style,
      focusNode: _verifyFocus,
      textInputAction: TextInputAction.go,
      decoration: InputDecoration(
        hintText: 'Verify Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      onFieldSubmitted: (term) {
        _updatePassword();
      },
    );

    final submitBtn = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff007bff),
      child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            _updatePassword();
          },
          child: Text('Change Password', style: globals.style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      )
    );

    final goBackBtn = FlatButton(
      onPressed: () {
        Navigator.popAndPushNamed(context,'/login');
      }, 
      child: Text(
        'Go Back',
        style: TextStyle(color: Colors.black54)
      )
    );

    // Return scaffold of elements to build a widget

    return Scaffold(
      body: Center(
        child: isLoading
        ? Center(
          child: CircularProgressIndicator(),
        ) : ListView (
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            passwordField,
            SizedBox(height: 8.0),
            verifyField,
            SizedBox(height: 24.0),
            submitBtn,
            goBackBtn
          ],
        )
      ),
    );
  }
  _updatePassword() async {
      // Show Loading Screen
      setState(() {
        isLoading = true;
      });

      // Ensure that both password field and verify field contain passwords
      if (_passwordField.text == "" || _passwordField.text == null || _passwordVerify.text == "" || _passwordVerify.text == null) {return AlertDialog(
              title: Text('Error'),
              content: Text('You must enter a password and verify'),
              actions: <Widget>[
                new FlatButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text('Ok'))
              ],
            );
      } else {
        if (_passwordField.text == _passwordVerify.text) {
          // Encrypt password
          final password = login.encryptFunc(_passwordField.text);

          // Send encrpyted password, entered code and current datetime to api
          http.Response response = await http.post(
            'https://thecityoftruromariners.futurelucas4502.co.uk',
            body: <String, String>{
              "formname": "resetPasswordConfirmed",
              "code": code,
              "newpass": password,
              'datetime': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
            }
          );

          // Remove loading view
          setState(() {
            isLoading = false;
          });

          if (response.body == 'Success') {
            showDialog(context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success!'),
                content: Text('Your password was updated successfully!'),
                actions: <Widget>[
                  new FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/login');
                    },
                  )
                ],
              );
            }
            );
          } else if (response.body == 'Incorrect') {
            showDialog(context: context,
            builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('The password change request could not be found. Please check your code and ensure that it was less than 10 minutes since the code was sent to your email'),
              actions: <Widget>[
                new FlatButton(onPressed: () {
                  Navigator.popAndPushNamed(context, '/login');
                }, child: Text('Ok'))
              ],
            );
            });
          } else {
            // Unknown Error
            showDialog(context: context,
            builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An unkonwn error occured. Please attempt the password reset again. If this keeps happening, please contact us at truromariners@gmail.com'),
              actions: <Widget>[
                new FlatButton(onPressed: () {
                  Navigator.popAndPushNamed(context, '/login');
                }, child: Text('Ok'))
              ],
            );
          });
          }
        } else {
          showDialog(context: context,
          builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Error'),
              content: Text('Your passwords do not match. Please re-enter the new password'),
              actions: <Widget>[
                new FlatButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text('Ok'))
              ],
            );
            });
        }
      }
    }
}
  
  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    // Change the current focused field
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }