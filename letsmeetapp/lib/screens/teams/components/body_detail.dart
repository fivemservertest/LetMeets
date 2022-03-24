// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/teams/team_uploadfile.dart';
import 'package:letsmeet/screens/teams/team_member.dart';
import 'package:letsmeet/screens/teams/editTeamScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../team_meet.dart';

class HomeDetail extends StatefulWidget {
  final teamname;

  const HomeDetail({Key key, this.teamname}) : super(key: key);
  @override
  _HomeDetailState createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
  String username = "";
  String team_name = "";
  String status = "";
  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
      status = preferences.getString('status');
    });
  }

  Future<List> getData() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/teams/teambyid.php?team_name=${team_name}"));
    return json.decode(response.body);
  }

  @override
  void initState() {
    getEmail();
    getname();
    super.initState();
  }

  void getname() async {
    setState(() {
      team_name = widget.teamname;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? Body(
                list: snapshot.data,
                username: username,
                status: status,
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}

class Body extends StatefulWidget {
  final List list;
  final String username;
  final String status;
  Body({this.list, this.username, this.status});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80.4,
        margin: EdgeInsets.only(top: 16),
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: widget.list.length,
            itemBuilder: (context, i) {
              return Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      //height: 500,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(
                                5.0) //                 <--- border radius here
                            ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Team name : ',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        widget.list[i]['team_name'],
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Description :',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.list[i]['team_description'],
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            height: 50.0,
                            margin: EdgeInsets.all(10),
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TeamMeet(
                                              list: widget.list,
                                              index: i,
                                            )));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff374ABE),
                                        Color(0xff64B6FF)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: 250.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Team Meeting",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                               Container(
                                  height: 50.0,
                                  margin: EdgeInsets.all(10),
                                 
                                  child: RaisedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => team_member(
                                                    list: widget.list,
                                                    index: 0,
                                                  )));
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(80.0)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xff374ABE),
                                              Color(0xff64B6FF)
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 250.0, minHeight: 50.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "View Member",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          Container(
                            height: 50.0,
                            margin: EdgeInsets.all(10),
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => teamupload(
                                              list: widget.list,
                                              index: 0,
                                            )));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff374ABE),
                                        Color(0xff64B6FF)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: 250.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Documents",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    widget.status == 'Managers'
                        ? Container(
                            height: 50.0,
                            margin: EdgeInsets.all(10),
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditData(
                                              list: widget.list,
                                              index: 0,
                                            )));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff374ABE),
                                        Color(0xff64B6FF)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: 250.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Edit Team",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Wrap(),
                  ],
                ),
              );
            }));
  }
}
