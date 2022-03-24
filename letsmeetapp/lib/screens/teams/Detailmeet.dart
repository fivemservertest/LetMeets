// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/teams/room_file.dart';
import 'package:letsmeet/screens/teams/Seemore_team_member.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'atten.dart';
import 'Seemore.dart';

class detailmeet extends StatefulWidget {
  final list;
  final reserve_id;
  final host;
  final team_name;

  const detailmeet(
      {Key key, this.list, this.reserve_id, this.host, this.team_name})
      : super(key: key);

  @override
  State<detailmeet> createState() => _detailmeetState();
}

class _detailmeetState extends State<detailmeet> {
  String team_name = "";
  String hostname = "";
  String firstname = '';
  String lastname = '';
  String fullname = '';
  String status = '';

  @override
  void initState() {
    team_name = widget.team_name;
    hostname = widget.host;

    gethost();
    getEmail();
    super.initState();
  }

  Future gethost() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/teams/gethostname.php?userid_host=${hostname}"));
    var data = json.decode(response.body);
    print(data);
    setState(() {
      firstname = data[0]['firstname'];
      lastname = data[0]['lastname'];
    });
  }

  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      status = preferences.getString('status');
      // print('aaa'+username);
    });
  }

  @override
  Widget build(BuildContext context) {
    void daleteData(String meeting_id) {
      var url = "http://${ipconn}/letsmeet/booking/bookingcancal.php";
      http.post(Uri.parse(url), body: {'meeting_id': meeting_id});
      setState(() {});
    }

    var datefo = DateFormat('yyyy-MM-dd').parse(widget.list['datein']);
    String datemeet = DateFormat('dd-MM-yyyy').format(datefo);
    DateTime datein =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(widget.list['datein']);
    String dateoutStr = DateFormat('HH:mm:ss').format(datein);
    DateTime dateout =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(widget.list['dateout']);
    String dateend = DateFormat('HH:mm:ss').format(dateout);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Meeting', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFCFD7ED), Color(0xFFE8D9E6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
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
                                  'Host: ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  firstname + ' ' + lastname,
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
                            child: Row(
                              children: [
                                Text(
                                  'Room : ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  widget.list['name'],
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
                            child: Row(
                              children: [
                                Text(
                                  'Date : ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  datemeet,
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
                            child: Row(
                              children: [
                                Text(
                                  'Time: ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  dateoutStr + '  -  ' + dateend,
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
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Seemore_team_member(
                                        team_name: widget.team_name,
                                        datein: widget.list['datein'],
                                        dateout: widget.list['dateout'],
                                      )));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 250.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "View Member",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
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
                                  builder: (context) => roomupload(
                                        reser_id: widget.reserve_id,
                                        team_name: widget.team_name,
                                        datein: widget.list['datein'],
                                        dateout: widget.list['dateout'],
                                      )));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff374ABE), Color(0xff64B6FF)],
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    status == 'Managers'
                        ? Container(
                            height: 50.0,
                            margin: EdgeInsets.all(10),
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Atten(
                                            team_name: widget.team_name,
                                            reser_id: widget.reserve_id,
                                            host: widget.host)));
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
                                    "Attendance",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: status == "Managers"
            ? FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                              "Do you need to cancal meeting at ${widget.list['name']} ?"),
                          content: Text(
                              "in ${widget.list['datein']} - ${widget.list['dateout']} "),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                daleteData(widget.list['reserve_id']);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Seemore(
                                            team_id: widget.list['team_id'])));
                              },
                              child: Text("Ok"),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel"),
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.red),
                            ),
                          ],
                        );
                      });
                },
                label: const Text('Cancel Book'),
                icon: const Icon(Icons.close),
                backgroundColor: Colors.pink,
              )
            : SizedBox());
  }
}
