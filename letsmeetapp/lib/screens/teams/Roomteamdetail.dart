import 'dart:convert';

import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/booking/Addbooking.dart';
import 'package:letsmeet/screens/booking/Cancelbooking.dart';
import 'package:letsmeet/screens/booking/checkinvite.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/screens/carendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddBookingteam.dart';

class RoomteamDetail extends StatefulWidget {
  String team_id;
  List list;
  int index;
  RoomteamDetail({
    this.index,
    this.list,
    this.team_id
  });

  @override
  _RoomteamDetailState createState() => _RoomteamDetailState();
}

class _RoomteamDetailState extends State<RoomteamDetail> {
  String username = "";
  bool checkstatus = false;
  List booklist = List();
  String bookdate;
  String bookstart;
  List UserList = List();
  String booknum;
  String bookend;
  List facilitylist = List();
  String facilityname = "";
  String permission = "";
  String team_id = null;

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

  Future get() async {
    
    if(widget.team_id != null){
      setState(() {
        team_id = widget.team_id;

        print(''+team_id);

    });

    }


  }

  @override
  void initState() {
    getEmail();
    get();
    //checkinvite().getuserinvite(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: permission == 'Managers' || permission == 'Admin'
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
         
                SizedBox(
                  height: 5,
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddBookingteam(
                              list: widget.list,
                              index: widget.index,
                              team_id : team_id
                            )));
                  },
                  child: Text("Book"),
                ),
              ],
            )
          : Container(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFCFD7ED),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFCFD7ED), Color(0xFFE8D9E6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 35,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.list[widget.index]['name'],
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child:
                    CarendarPageMyAppHome(widget.list[widget.index]['room_id']),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
