// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';

class Atten extends StatefulWidget {
  final team_name;
  final host;
  final reser_id;
  Atten({Key key, this.team_name, this.host, this.reser_id}) : super(key: key);

  @override
  State<Atten> createState() => _AttenState();
}

String team_name = '';
String hostname = '';
String hfirstname = '';
String image = '';
String lastname;

class _AttenState extends State<Atten> {
  void initState() {
    team_name = widget.team_name;
    hostname = widget.host;
    gethost();
    super.initState();
  }

  Future<List> getdata() async {
    final response = await http.get(Uri.parse(
        "http://$ipconn/letsmeet/teams/viewmember.php?team_name=$team_name"));
    var data = json.decode(response.body);
    print(data);
    return data;
  }

  Future gethost() async {
    final response = await http.get(Uri.parse(
        "http://$ipconn/letsmeet/teams/gethostname.php?userid_host=$hostname"));
    var data = json.decode(response.body);

    setState(() {
      image = data[0]['image'];
      hfirstname = data[0]['firstname'];
      lastname = data[0]['lastname'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Attendance'),
        backgroundColor: Color(0xFFDCADA3),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(width: 3, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 1,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'http://$ipconn/letsmeet/login_logout/upload/${image}'),
                          ),
                        ),
                      )),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(hfirstname),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Host"),
                  ),
                ),
                Text("status")
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Pic/Name Participant'),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Attended'),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Not Attended'),
                  
                  ),
                ),
                Text('Status'),
              ],
            ),
            Container(
              height: 500,
              width: 390,
              child: new FutureBuilder<List>(
                future: getdata(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? new Itemlist(
                          list: snapshot.data, reser_id: widget.reser_id)
                      : new Center(
                          child: new CircularProgressIndicator(),
                        );
                },
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
  final reser_id;

  Itemlist({this.list, this.status, this.reser_id});
  @override
  _ItemlistState createState() => _ItemlistState();
}

class _ItemlistState extends State<Itemlist> {
  List<bool> checkedin = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<bool> checkedout = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  void update(String username, var checkedin, var checkedout, var reser_id) {
    var url = Uri.parse("http://$ipconn/letsmeet/teams/checkmeet.php");
    http.post(url, body: {
      'username': username,
      'reser_id': reser_id,
      'checkedin': checkedin.toString(),
      'checkedout': checkedout.toString()
    });
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red;
      }
      return Colors.green;
    }

    Color getColorS(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red;
      }
      return Colors.red;
    }

    return new ListView.builder(
      itemCount: widget.list == null ? 0 : widget.list.length,
      itemBuilder: (context, i) {
        String username = widget.list[i]['username'];
        String firstname = widget.list[i]['firstname'];
        String lastname = widget.list[i]['lastname'];
        String status = widget.list[i]['status'];
        String team_name = widget.list[i]['team_name'];
        String reser_id = widget.reser_id;

        return Container(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 5,
              ),
              status == 'member'
                  ? Row(
                      children: [
                        Expanded(
                            child: Icon(
                          Icons.supervised_user_circle,
                          size: 40,
                        )),
                        Expanded(child: Text(widget.list[i]['firstname'])),
                        Expanded(
                          child: Checkbox(
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: checkedin[i],
                            onChanged: i == widget.list.length
                                ? null
                                : (bool value) {
                                    setState(() {
                                      checkedin[i] = value;
                                      checkedout[i] = false;
                                      print(checkedin[i]);
                                      print(checkedout[i]);
                                      print(widget.list[i]['username']);
                                      update(
                                          widget.list[i]['username'],
                                          checkedin[i],
                                          checkedout[i],
                                          reser_id);
                                    });
                                  },
                          ),
                        ),
                        Expanded(
                          child: Checkbox(
                            fillColor:
                                MaterialStateProperty.resolveWith(getColorS),
                            value: checkedout[i],
                            onChanged: i == widget.list.length
                                ? null
                                : (bool value) {
                                    setState(() {
                                      checkedout[i] = value;
                                      checkedin[i] = false;
                                      print(checkedout[i]);
                                      print(checkedin[i]);
                                      update(
                                          widget.list[i]['username'],
                                          checkedin[i],
                                          checkedout[i],
                                          reser_id);
                                    });
                                  },
                          ),
                        ),
                        Text("in")
                      ],
                    )
                  : SizedBox()
            ],
          ),
        );
      },
    );
  }
}
