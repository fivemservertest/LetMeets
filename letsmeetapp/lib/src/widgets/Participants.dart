import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/RoomDetail.dart';

class permissionHome extends StatefulWidget {
  @override
  _permissionHomeState createState() => _permissionHomeState();
}

class _permissionHomeState extends State<permissionHome> {
  Future<List> getData() async {
    final response = await http.get(
        Uri.parse("http://${ipconn}/letsmeet/participant/participant.php"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.startday);

    return FutureBuilder<List>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? permissio(
                list: snapshot.data,
              )
            : Center(
                //child: CircularProgressIndicator(),
                );
      },
    );
  }
}

class permissio extends StatefulWidget {
  final List list;
  permissio({this.list});

  @override
  _permissioState createState() => _permissioState();
}

class _permissioState extends State<permissio> {
  final _pageController = PageController(viewportFraction: 0.877);

  @override
  void initState() {
    super.initState();
  }

  Future<List> getData(String user_id) async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/participant/freeTimeparticipant.php?user_id=${user_id}"));
    return json.decode(response.body);
  }

  /*Future<bool> checkroom(String room_id, DateTime ssday, DateTime eeday) async {
    final response = await http.get(
        "http://${ipconn}/hotelpro/booking/checkbooking.php?room_id=${room_id}&datein=${ssday}&dateout=${eeday}");
    var data = json.decode(response.body);
    if (data == "Error") {
      return true;
    } else {
      return false;
    }
  }*/

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
              return Container(
                //color: Colors.green,
                //height: MediaQuery.of(context).size.height,

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
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              //Text('Room size : '),
                              Text(
                                widget.list[i]['firstname'],
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Department ${widget.list[i]['department']}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Icon(
                                Icons.people,
                                size: 50,
                              )
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                          right: 17,
                          top: -5,
                          child: Container(
                            height: 100,
                            width: 150,
                            child: FutureBuilder(
                              future: getData(widget.list[i]['user_id']),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) print(snapshot.error);
                                return snapshot.hasData
                                    ? FreeTime(
                                        list: snapshot.data,
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      );
                              },
                            ),
                            /*ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5.0),
                                  child: Container(
                                      height: 30,
                                      child: Row(
                                        children: [Text('  09:00 - 12:00')],
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Container(
                                      height: 30,
                                      child: Row(
                                        children: [Text('  13:00 - 15:00')],
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Container(
                                      height: 30,
                                      child: Row(
                                        children: [Text('  15:00 - 18:00')],
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Container(
                                      height: 30,
                                      child: Row(
                                        children: [Text('  19:00 - 21:00')],
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                      )),
                                ),
                              ],
                            ),*/
                          )),
                    ],
                  ),
                ),
              );
            }));
  }
}

class FreeTime extends StatefulWidget {
  final List list;

  const FreeTime({Key key, this.list}) : super(key: key);
  @override
  _FreeTimeState createState() => _FreeTimeState();
}

class _FreeTimeState extends State<FreeTime> {
  List<DateTime> free = [];

  Future checkAvailableTime() async {
    free = [];
    for (int i = 0; i < widget.list.length; i++) {
      DateTime get =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(widget.list[i]["datein"]);
      print(get);
      free.add(get);
      setState(() {});
      print(free.toString());
    }
  }

  @override
  void initState() {
    checkAvailableTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5.0),
            child: Container(
                height: 30,
                child: Row(
                  children: [
                    free.contains(DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day, 9))
                        ? Icon(Icons.block)
                        : Icon(Icons.check),
                    Text('  09:00 - 12:00')
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Container(
                height: 30,
                child: Row(
                  children: [
                    free.contains(DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day, 13))
                        ? Icon(Icons.block)
                        : Icon(Icons.check),
                    Text('  13:00 - 15:00')
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Container(
                height: 30,
                child: Row(
                  children: [
                    free.contains(DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day, 16))
                        ? Icon(Icons.block)
                        : Icon(Icons.check),
                    Text('  16:00 - 18:00')
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Container(
                height: 30,
                child: Row(
                  children: [
                    free.contains(DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day, 19))
                        ? Icon(Icons.block)
                        : Icon(Icons.check),
                    Text('  19:00 - 21:00')
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                )),
          ),
        ],
      ),
    );
  }
}
