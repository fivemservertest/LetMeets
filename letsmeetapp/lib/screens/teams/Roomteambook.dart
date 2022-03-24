import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/navigation_home_screen.dart';
import 'package:letsmeet/screens/RoomDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Roomteamdetail.dart';

class Roomteam extends StatefulWidget {
  final String search;
  final String team_id;


  const Roomteam({Key key, this.search , this.team_id }) : super(key: key);

  //   final String search;
  // final List list;
  // final int index;

  // const Roomteam({Key key, this.search ,this.list , this.index}) : super(key: key);
  @override
  _RoomteamState createState() => _RoomteamState();
}

class _RoomteamState extends State<Roomteam> {
  Future<List> getData() async {
    if (widget.search == "" || widget.search == null) {
      final response =
          await http.get(Uri.parse("http://${ipconn}/letsmeet/room/room.php"));
      return json.decode(response.body);
    } else {
      final response = await http.get(Uri.parse(
          "http://${ipconn}/letsmeet/room/room.php?search=${widget.search}"));
      setState(() {});
      return json.decode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.startday);
        // print(''+widget.team_id);

    return FutureBuilder<List>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? Room(
                list: snapshot.data,
                team_id : widget.team_id
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
  final String team_id;
  Room({this.list , this.team_id});

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
      // print(' '+username);
    });

    
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/profile/profile.php?user_id=${username}"));
    var data = json.decode(response.body);
    setState(() {
      permission = data[0]['permission'];
    });
  }

  void daleteData(room_id) {
    var url = "http://${ipconn}/letsmeet/room/cancelroom.php";
    http.post(Uri.parse(url), body: {'room_id': room_id});
    setState(() {});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return NavigationHomeScreen();
    }));
  }

  @override
  void initState() {
    getEmail();
    // print(username);
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    // print(''+username);
    return Container(
        height: 80.4,
        margin: EdgeInsets.only(top: 16),
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            controller: _pageController,
            itemCount: widget.list.length,
            itemBuilder: (context, i) {
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
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(
                                        left: 70.0,
                                        right: 70.0,
                                        top: 80,
                                        bottom: 80),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                          width: 4, color: Colors.white),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            'http://$ipconn/letsmeet/room/roomimg/${widget.list[i]['image']}'),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 80, left: 25),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '      Total Seat : ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          widget.list[i]['size'],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => RoomteamDetail(
                                                    list: widget.list,
                                                    index: i,
                                                    team_id : widget.team_id,
                                                  )));
                                    },
                                    child: Text("See more")),
                                        permission == "Admin"
                                            ? Wrap(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  Colors.red),
                                                      onPressed: () {
                                                        daleteData(
                                                            widget.list[i]
                                                                ['room_id']);
                                                      },
                                                      child: Text("Delete")),
                                                ],
                                              )
                                            : Wrap(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /*Row(
                            children: [
                              Text(
                                'Status : ',
                                style: TextStyle(fontSize: 20),
                              ),
                              widget.list[i]['status'] == "1"
                                  ? Text(
                                      "Available",
                                      style: TextStyle(fontSize: 20),
                                    )
                                  : Text(
                                      "Unavailable",
                                      style: TextStyle(fontSize: 20),
                                    ),
                            ],
                          ),*/
                          // Container(
                          //     height: 130,
                          //     width: 130,
                          //     decoration: BoxDecoration(
                          //       image: DecorationImage(
                          //         fit: BoxFit.cover,
                          //         image: NetworkImage(
                          //             'http://$ipconn/letsmeet/room/roomimg/${widget.list[i]['image']}'),
                          //       ),
                          //     )),
                        ],
                      ),
                    ),
                    Positioned(
                        left: 17,
                        top: -5,
                        child: Container(
                          padding: EdgeInsets.all(5),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          //color: Colors.red,
                          child: Row(
                            children: [
                              Text(
                                'Room : ',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                widget.list[i]['name'],
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
