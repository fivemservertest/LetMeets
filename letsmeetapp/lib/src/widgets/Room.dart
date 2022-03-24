import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/navigation_home_screen.dart';
import 'package:letsmeet/screens/RoomDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomHome extends StatefulWidget {
  final String search;
  final bool data1;
  final bool data2;
  final bool data3;
  final bool data4;
  final bool data5;

  const RoomHome(
      {Key key,
      this.search,
      this.data1,
      this.data2,
      this.data3,
      this.data4,
      this.data5})
      : super(key: key);

  //   final String search;
  // final List list;
  // final int index;

  // const RoomHome({Key key, this.search ,this.list , this.index}) : super(key: key);
  @override
  _RoomHomeState createState() => _RoomHomeState();
}

class _RoomHomeState extends State<RoomHome> {
  String stringValue1;
  String stringValue2;
  String stringValue3;
  String stringValue4;
  String stringValue5;

  Future<List> getData() async {
    setState(() {
      stringValue1 = widget.data1.toString();
      stringValue2 = widget.data2.toString();
      stringValue3 = widget.data3.toString();
      stringValue4 = widget.data4.toString();
      stringValue5 = widget.data5.toString();
    });

    if (stringValue1 == "false" &&
            stringValue2 == "false" &&
            stringValue3 == "false" &&
            stringValue4 == "false" &&
            stringValue5 == "false" &&
            widget.search == "" ||
        widget.search == null) {
      final response =
          await http.get(Uri.parse("http://${ipconn}/letsmeet/room/room.php"));
      print("1");
      return json.decode(response.body);
    } else if (widget.search == "" ||
        widget.search == null && stringValue1 == "true" ||
        stringValue2 == "true" ||
        stringValue3 == "true" ||
        stringValue4 == "true" ||
        stringValue5 == "true") {
      final response = await http.get(Uri.parse(
          "http://${ipconn}/letsmeet/room/room.php?whiteboardandchalk=${stringValue1}&projectorandscreen=${stringValue2}&podium=${stringValue3}&microphoneandspeaker=${stringValue4}&computer=${stringValue5}"));
      print("2");
      print(
          "http://${ipconn}/letsmeet/room/room.php?whiteboardandchalk=${stringValue1}&projectorandscreen=${stringValue2}&podium=${stringValue3}&microphoneandspeaker=${stringValue4}&computer=${stringValue5}");
      return json.decode(response.body);
    } else if (stringValue2 == "true" ||
        stringValue3 == "true" ||
        stringValue4 == "true" ||
        stringValue5 == "true" ||
        widget.search != "" ||
        widget.search == null && stringValue1 != "true") {
      final response = await http.get(Uri.parse(
          "http://${ipconn}/letsmeet/room/room.php?search=${widget.search}&whiteboardandchalk=${stringValue1}&projectorandscreen=${stringValue2}&podium=${stringValue3}&microphoneandspeaker=${stringValue4}&computer=${stringValue5}"));
      print("2");
      print(
          "http://${ipconn}/letsmeet/room/room.php?search=${widget.search}&whiteboardandchalk=${stringValue1}&projectorandscreen=${stringValue2}&podium=${stringValue3}&microphoneandspeaker=${stringValue4}&computer=${stringValue5}");
      return json.decode(response.body);
    } else if (widget.search != "" || widget.search != null) {
      final response = await http.get(Uri.parse(
          "http://${ipconn}/letsmeet/room/room.php?search=${widget.search}"));
      print("3");
      print("http://${ipconn}/letsmeet/room/room.php?search=${widget.search}");
      return json.decode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.startday);
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
      // print('aaa'+username);
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
    // print('keeeee'+username);
    return Container(
        height: 81,
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
                          Padding(
                            padding: const EdgeInsets.only(top: 28),
                            child: Container(
                              width: 202,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(
                                          'Total Seat : ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Text(
                                        widget.list[i]['size'],
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                      height: 70,
                                      width: double.infinity,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: Expanded(
                                          child: SingleChildScrollView(
                                            child: Text(
                                              'Description : ${widget.list[i]['detail']}',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      permission != "Admin"
                                          ? SizedBox(
                                              width: 10,
                                            )
                                          : SizedBox(
                                              width: 0,
                                            ),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RoomDetail(
                                                          list: widget.list,
                                                          index: i,
                                                        )));
                                          },
                                          child: Text("See more")),
                                      permission == "Admin"
                                          ? Wrap(
                                              children: [
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.red),
                                                    onPressed: () {
                                                      daleteData(widget.list[i]
                                                          ['room_id']);
                                                    },
                                                    child: Text("Delete")),
                                              ],
                                            )
                                          : Wrap(),
                                    ],
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
                        top: 1,
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
