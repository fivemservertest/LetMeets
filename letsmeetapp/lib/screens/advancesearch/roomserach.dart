import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/navigation_home_screen.dart';
import 'package:letsmeet/screens/RoomDetail.dart';
import 'package:letsmeet/screens/booking/checkmeet.dart';
import 'package:letsmeet/screens/booking/detailroom.dart';
import 'package:letsmeet/screens/booking/detailroom2.dart';
import 'package:letsmeet/screens/booking/invite.dart';
import 'package:letsmeet/screens/mainscreen/HomeScreen.dart';
import 'package:letsmeet/sendmail/sendmail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Roomresult extends StatefulWidget {
  final seat;
  final date;
  final start;
  final end;
  final bool data1;
  final bool data2;
  final bool data3;
  final bool data4;
  final bool data5;

  const Roomresult(
      {Key key,
      this.seat,
      this.date,
      this.start,
      this.end,
      this.data1,
      this.data2,
      this.data3,
      this.data4,
      this.data5})
      : super(key: key);


  @override
  _RoomresultState createState() => _RoomresultState();
}

class _RoomresultState extends State<Roomresult> {
  String username;
  String status;
  String stringValue1;
  String stringValue2;
  String stringValue3;
  String stringValue4;
  String stringValue5;

  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
      status = preferences.getString('status');
    });
  }

  String seats = "";
  Future<List> getData() async {
    setState(() {
      seats = widget.seat;
      stringValue1 = widget.data1.toString();
      stringValue2 = widget.data2.toString();
      stringValue3 = widget.data3.toString();
      stringValue4 = widget.data4.toString();
      stringValue5 = widget.data5.toString();
    });
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/advancesearch/room2.php?user_id=${username}&seat=${seats}&start=${widget.start}&end=${widget.end}&whiteboardandchalk=${stringValue1}&projectorandscreen=${stringValue2}&podium=${stringValue3}&microphoneandspeaker=${stringValue4}&computer=${stringValue5}"));
    print(
        "http://${ipconn}/letsmeet/advancesearch/room2.php?user_id=${username}&seat=${widget.seat}&start=${widget.start}&end=${widget.end}&whiteboardandchalk=${stringValue1}&projectorandscreen=${stringValue2}&podium=${stringValue3}&microphoneandspeaker=${stringValue4}&computer=${stringValue5}");
    return json.decode(response.body);
  }

  @override
  void initState() {
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.startday);
    //print(widget.startday);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFCFD7ED),
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: new Text("Search Result"),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? Room(
                    list: snapshot.data,
                    seat: widget.seat,
                    date: widget.date,
                    start: widget.start,
                    end: widget.end,
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}

class Room extends StatefulWidget {
  List list;
  final seat;
  final date;
  final start;
  final end;
  Room({this.list, this.date, this.seat, this.end, this.start});

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  final _pageController = PageController(viewportFraction: 0.877);

  String username = "";
  String permission = "";
  String status;
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
    return Container(
        margin: EdgeInsets.only(top: 16),
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            controller: _pageController,
            itemCount: widget.list.length,
            itemBuilder: (context, i) {
              return Container(
                height: 220,
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
                                        permission == "Admin" ||
                                                permission == "Managers"
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  _showconfirm(
                                                      status,
                                                      widget.list[i]['name'],
                                                      widget.list[i]['size'],
                                                      widget.list[i]['room_id'],
                                                      widget.date.toString());
                                                },
                                                child: Text("Book"),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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

  void _showconfirm(
      String status, String name, String seat, String roomid, String date) {
    Future uploadRoom() async {
      final uri =
          Uri.parse("http://${ipconn}/letsmeet/booking/bookingadd2.php");
      var request = await http.post(
        uri,
        body: {
          'room_id': roomid,
          'user_id': username,
          'bookingin': widget.start,
          'bookingout': widget.end
        },
      );
      print(request.body);
      print(json.decode(request.body));
      if (json.decode(request.body) == "Error") {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                    "Someone have booked in this time, Please change your time for booking"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("ok"))
                ],
              );
            });
      } else if (json.decode(request.body) == "timeout") {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title:
                    Text("Sorry, The limit of booking is not more than 23:59"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("ok"))
                ],
              );
            });
      } else {
        final response2 = await http.get(Uri.parse(
            "http://${ipconn}/letsmeet/profile/profile.php?user_id=${username}"));
        var data2 = json.decode(response2.body);
        sendmail().sendmailer(
            name: data2[0]['firstname'],
            email: data2[0]['email'],
            subject: "Booking meeting room",
            body:
                "${data2[0]['firstname']} ${data2[0]['lastname']} have booking the meeting room ${name} in ${widget.date} at ${widget.start} - ${widget.end}}");
        var data = json.decode(request.body);
        print(data);
        _showsuccess(name, seat, roomid, date, data);
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // StatefulBuilder
          builder: (context, setState) {
            return AlertDialog(
              actions: <Widget>[
                Container(
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Are you sure that you want to book this room?",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 2,
                          color: Colors.black,
                        ),
                        Text(
                          "Room : " + name,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Total seat : " + seat,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Date : " + date.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Time Start : " + widget.start,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Time End :  " + widget.end,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green),
                          onPressed: () {
                            uploadRoom();
                            // _showsuccess(name, seat, roomid, date);
                          },
                          child: Text("Confirm"),
                        ),
                        ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Back"),
                        ),
                      ],
                    ))
              ],
            );
          },
        );
      },
    );
  }

  void _showsuccess(
      String name, String seat, String roomid, String date, var list) {
    int i = 0;
    print("reseve_id =" + list[0]['reserve_id']);
    print("user_id =" + list[0]['user_id']);
    print(list);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // StatefulBuilder
          builder: (context, setState) {
            return AlertDialog(
              actions: <Widget>[
                Container(
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Book Successful!",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 2,
                          color: Colors.black,
                        ),
                        Text(
                          "Room : " + name,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Total seat : " + seat,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Date : " + date,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Time Start : " + widget.start,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Time End :  " + widget.end,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.green),
                            onPressed: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => detailroom2(
                                    list: list[i],
                                    reserve_id: list[i]['reserve_id'],
                                    host: list[i]['user_id']),
                              ));
                            },
                            child: Text("View meeting")),
                        ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green),
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InvitePage(list: list, index: 0)));
                          },
                          child: Text("Invite member"),
                        ),
                        ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NavigationHomeScreen()));
                          },
                          child: Text("Back"),
                        ),
                      ],
                    ))
              ],
            );
          },
        );
      },
    );
  }
}
