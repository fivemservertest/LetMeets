import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'components/body_detail.dart';
import 'components/body_m.dart';

class Addm_screen extends StatefulWidget {
  final String search;
  final String data;
  const Addm_screen({Key key, this.search, this.data}) : super(key: key);
  @override
  _Addm_screenState createState() => _Addm_screenState();
}

class _Addm_screenState extends State<Addm_screen> {
  String team_name = "";

  @override
  void initState() {
    getname();
    super.initState();
  }

  void getname() async {
    setState(() {
      team_name = widget.data;
    });
  }

  Future<List> getData() async {
    if (widget.search == "" || widget.search == null) {
      final response = await http.get(Uri.parse(
          "http://${ipconn}/letsmeet/teams/menber.php?teamname=${team_name}"));
      return json.decode(response.body);
    } else {
      final response = await http.get(Uri.parse(
          "http://${ipconn}/letsmeet/teams/menber.php?search=${widget.search}&teamname=${team_name}"));
      setState(() {});
      return json.decode(response.body);
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
            ? Room(list: snapshot.data, data: widget.data)
            : Center(
                //child: CircularProgressIndicator(),
                );
      },
    );
  }
}

class Room extends StatefulWidget {
  final List list;
  final String data;
  Room({this.list, this.data});

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  final _pageController = PageController(viewportFraction: 0.877);

  String username = "";
  String permission = "";
  String team_name = "";
  String firstname = "";
  String lastname = "";

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

  void inseartData(username, firstname, lastname) async {
    var url = "http://${ipconn}/letsmeet/teams/addmenber.php";
    var response = await http.post(Uri.parse(url), body: {
      'team_name': team_name,
      'username': username,
      'firstname': firstname,
      'lastname': lastname
    });
    var data = json.decode(response.body);
    if (data == 'add member') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Body_menber(data:team_name)));
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
            type: ArtSweetAlertType.warning,
            title: "This member is already in the team.",
          ));
    }
  }

  @override
  void initState() {
    getEmail();
    getname();

    super.initState();
  }

  void getname() async {
    setState(() {
      team_name = widget.data;
    });
  }

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
              username = widget.list[i]['username'];
              firstname = widget.list[i]['firstname'];
              lastname = widget.list[i]['lastname'];
              return Container(
                //color: Colors.green,
                //height: MediaQuery.of(context).size.height,

                child: Stack(
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
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.list[i]['firstname'] +
                                      "  " +
                                      widget.list[i]['lastname'],
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Wrap(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.black),
                                        onPressed: () {
                                          inseartData(
                                            widget.list[i]['username'],
                                            widget.list[i]['firstname'],
                                            widget.list[i]['lastname'],
                                          );
                                        },
                                        child: Text("Invite")),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        left: 17,
                        top: -5,
                        child: Container(
                          padding: EdgeInsets.all(5),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          //color: Colors.red,
                          child: Row(
                            children: [
                              Text(
                                'User : ',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                widget.list[i]['username'],
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            }));
  }
}
