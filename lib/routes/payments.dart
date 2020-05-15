import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../main.dart' as globals;
//Start Payments page code

class PaymentsPage extends StatefulWidget {
  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globals.MyAppBar(
        title: "Payments"
      ),
      drawer: globals.MyDrawer(),
      body: Container(
        alignment: Alignment.topCenter,
        margin: new EdgeInsets.only(
            top: 20.0, right: 20.0, left: 20.0, bottom: 20.0),
        child: FutureBuilder(
            future: paymentsReady(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                var datetime = DateFormat("yyyy-MM-dd hh:mm:ss")
                    .parse(json.decode(snapshot.data)[0]["date"]);
                var datetimeplusyear =
                    DateTime(datetime.year + 1, datetime.month, datetime.day);
                var duetext;
                if (DateTime.now().year == datetimeplusyear.year &&
                    DateTime.now().month == datetimeplusyear.month) {
                  duetext = """
Membership payment due soon.
Due date: ${DateFormat("dd-MM-yyyy").format(datetimeplusyear)}
                  """;
                } else if (DateTime.now().isAfter(datetimeplusyear)) {
                  duetext = """
Membership payment overdue!.
Due date: ${DateFormat("dd-MM-yyyy").format(datetimeplusyear)}
                  """;
                } else {
                  duetext = """
Membership is in date.
Due date: ${DateFormat("dd-MM-yyyy").format(datetimeplusyear)}
                  """;
                }
                return Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (((json.decode(snapshot.data)).length)
                                    .toString() ==
                                "0")
                              Text('Last paid: Never',
                                  style: globals.style.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            if (((json.decode(snapshot.data)).length)
                                    .toString() ==
                                "0")
                              Text("""
                                  You should pay for your first membership fee here or in person.
                                  If you have already paid in person it may take a few days to show up here.
                                  """,
                                  style: globals.style
                                      .copyWith(color: Colors.black)),
                            if (((json.decode(snapshot.data)).length)
                                    .toString() ==
                                "1")
                              Text(
                                  'Last paid: ${DateFormat("dd-MM-yyyy").format(datetime)}',
                                  style: globals.style.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text(duetext,
                                textAlign: TextAlign.center,
                                style: globals.style
                                    .copyWith(color: Colors.black)),
                            Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(30.0),
                                color: Color(0xff007bff),
                                child: MaterialButton(
                                  padding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  onPressed: () async {

                                  },
                                  child: Text("Membership Payment (£13)",
                                      textAlign: TextAlign.center,
                                      style: globals.style.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ))
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}

Future<String> paymentsReady() async {
  var result;
  try {
    http.Response response = await http.post(
      'https://lucas-testing.000webhostapp.com',
      body: <String, String>{
        "formname": "payments",
        "username": globals.currentUsername,
        "password": globals.currentPassword
      },
    );
    result = response.body;
  } catch (e) {
    globals.retryFuture(paymentsReady, 2000, PaymentsPage);
  }
  return result;
}

//End Payments page code