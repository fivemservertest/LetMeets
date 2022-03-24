import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:letsmeet/navigation_home_screen.dart';
import 'package:letsmeet/screens/loginscreen/login.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:flutter/material.dart';
import 'package:letsmeet/screens/teams/team_detail.dart';
import 'package:letsmeet/screens/teams/components/body.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:letsmeet/screens/teams/components/body_m.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class Seemore_team_member extends StatefulWidget {
  final team_name;
  final datein;
  final dateout;
  const Seemore_team_member(
      {Key key, this.team_name, this.datein, this.dateout})
      : super(key: key);

  @override
  _Seemore_team_memberState createState() => _Seemore_team_memberState();
}

class _Seemore_team_memberState extends State<Seemore_team_member> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String team_name = "";
  String username = "";
  String h_firstname = '';
  String h_lastname = '';
  String status = '';
  String datein;
  String dateout;
  void initState() {
    getus();
    team_name = widget.team_name;
    datein = widget.datein;
    dateout = widget.dateout;

    print("getdata " + datein);
    super.initState();
  }

  void getus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('fullname');
      status = preferences.getString('status');
    });
  }

  Future<List> getdata() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/teams/viewmember.php?team_name=${team_name}"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Member'),
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
                    height: 20,
                  ),
                  Container(
                    height: 100.0,
                    color: Colors.transparent,
                    child: new Container(
                      decoration: new BoxDecoration(
                          color: Colors.deepOrange[200],
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(100.0),
                            topRight: const Radius.circular(100.0),
                          )),
                      child: Column(
                        children: [
                          Center(
                            child: Text(widget.team_name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  height: 2.2,
                                  fontSize: 22,
                                  color: Colors.black,
                                  letterSpacing: 0.1,
                                )),
                          ),
                          Center(
                            child: Text('Date In :' + widget.datein,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  letterSpacing: 0.1,
                                )),
                          ),
                          Center(
                            child: Text('Date Out :' + widget.dateout,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  letterSpacing: 0.1,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 500,
                    width: 390,
                    child: new FutureBuilder<List>(
                      future: getdata(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        return snapshot.hasData
                            ? new Itemlist(list: snapshot.data, status: status)
                            : new Center(
                                child: new CircularProgressIndicator(),
                              );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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

class Itemlist extends StatefulWidget {
  final list;
  final status;
  Itemlist({this.list, this.status});
  @override
  _ItemlistState createState() => _ItemlistState();
}

class _ItemlistState extends State<Itemlist> {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: widget.list == null ? 0 : widget.list.length,
      itemBuilder: (context, i) {
        String username = widget.list[i]['username'];
        String firstname = widget.list[i]['firstname'];
        String lastname = widget.list[i]['lastname'];
        String status = widget.list[i]['status'];
        String team_name = widget.list[i]['team_name'];

        return Container(
          height: 80,
          child: Padding(
            padding: EdgeInsets.only(left: 10, bottom: 5, right: 10, top: 5),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.account_box_rounded,
                    color: Colors.deepOrangeAccent[200]),
                title: Text(
                    widget.list[i]['firstname'] +
                        " " +
                        widget.list[i]['lastname'],
                    style: TextStyle(fontSize: 17, color: Colors.black)),
                trailing: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Text(widget.list[i]['status'],
                          style: TextStyle(fontSize: 17, color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
