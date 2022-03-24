import 'dart:convert';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'body.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/teams/components/body_m.dart';

class insertteam extends StatefulWidget {
  @override
  _insertteamState createState() => _insertteamState();
}

class _insertteamState extends State<insertteam> {
  String fullname = '';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController team_name = TextEditingController();
  TextEditingController team_description = TextEditingController();

  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      fullname = preferences.getString('fullname');
    });
  }

  @override
  void initState() {
    getEmail();
    super.initState();
  }

  insert() async {
    var url = 'http://${ipconn}/letsmeet/teams/teamadd.php';
    var response = await http.post(Uri.parse(url), body: {
      'team_name': team_name.text,
      'team_description': team_description.text,
      'username': fullname
    });

    var data = json.decode(response.body);
    if (data == 'success') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Body_menber(data: team_name.text)));
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.success,
            title: "Successful",
          ));
    } else {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger,
            title: "This name is already in the system, Please change the name",
          ));
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFDCADA3),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: ListView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: Text("Create new Team",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 2.2,
                          fontSize: 22,
                          color: Colors.black,
                          letterSpacing: 0.1,
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Text("Team name",
                                      style: TextStyle(
                                        height: 2.2,
                                        fontSize: 16,
                                        color: Colors.black.withOpacity(0.6),
                                        letterSpacing: 0.1,
                                      )),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 60, right: 60, top: 10, bottom: 10),
                            child: TextFormField(
                              controller: team_name,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Text("Team description",
                                      style: TextStyle(
                                        height: 2.2,
                                        fontSize: 16,
                                        color: Colors.black.withOpacity(0.6),
                                        letterSpacing: 0.1,
                                      )),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 60, right: 60, bottom: 10),
                            child: Card(
                                color: Colors.grey[200],
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: team_description,
                                    // maxLength: 1000,
                                    maxLines: 4,
                                  ),
                                )),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            height: 50,
                            width: 150,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              // background
                              textColor: Colors.blue, // foreground
                              onPressed: () {
                                insert();
                              },
                              child: Text('Next'),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
