import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'team_detail.dart';

class TeamsScreen extends StatefulWidget {
  final String search;

  const TeamsScreen({Key key, this.search}) : super(key: key);
  @override
  _TeamsScreenState createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  String fullname = '';
  String status = '';

  Future getuser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      fullname = preferences.getString('fullname');
      status = preferences.getString('status');
      print('name ' + fullname);
      print('status ' + status);
    });
  }

  @override
  void initState() {
    getuser();
    super.initState();
  }

  Future<List> getData() async {
    if (status == 'Managers') {
      if (widget.search == "" || widget.search == null) {
        final response = await http.get(Uri.parse(
            "http://${ipconn}/letsmeet/teams/teams.php?fullname=${fullname}&status=${status}"));
        return json.decode(response.body);
      } else {
        final response = await http.get(Uri.parse(
            "http://${ipconn}/letsmeet/teams/teams.php?search=${widget.search}&fullname=${fullname}&status=${status}"));
        setState(() {});
        return json.decode(response.body);
      }
    } else {
      if (widget.search == "" || widget.search == null) {
        final response = await http.get(Uri.parse(
            "http://${ipconn}/letsmeet/teams/teams.php?fullname=${fullname}&status=${status}"));
        return json.decode(response.body);
      } else {
        final response = await http.get(Uri.parse(
            "http://${ipconn}/letsmeet/teams/teams.php?search=${widget.search}&fullname=${fullname}&status=${status}"));
        setState(() {});
        return json.decode(response.body);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.startday);

    return FutureBuilder<List>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? Room(
                list: snapshot.data,
              )
            : Center(
                //child: CircularProgressIndicator(),
                );
      },
    );
  }
}

class Room extends StatefulWidget {
  final List list;
  Room({this.list});

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  final _pageController = PageController(viewportFraction: 0.877);

  String username = "";
  String permission = "";
  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
    });
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/profile/profile.php?user_id=${username}"));
    var data = json.decode(response.body);
    setState(() {
      permission = data[0]['permission'];
    });
  }

  @override
  void initState() {
    getEmail();
    // print("teams" + username);
    super.initState();
  }

  // void inseartData(team_name) {
  //   var url = "http://${ipconn}/letsmeet/teams/teambyid.php";
  //   print(team_name);
  //   http.post(Uri.parse(url), body: {
  //     'team_name': team_name,
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80.4,
        margin: EdgeInsets.only(top: 16),
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            controller: _pageController,
            itemCount: widget.list.length,
            itemBuilder: (context, i) {
              String teamname = widget.list[i]['team_name'];
              return Container(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => team_detail(
                                      teamname: teamname,
                                    )));
                      },
                      child: Container(
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
