import 'package:flutter/material.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:letsmeet/screens/teams/carendarteam.dart';
import 'package:letsmeet/screens/carendar.dart';
import 'package:letsmeet/screens/booking/Addbooking.dart';
import '../../src/widgets/Room.dart';
import 'package:letsmeet/navigation_home_screen.dart';
import 'package:letsmeet/navigation.dart';
import 'package:letsmeet/screens/mainscreen/HomeScreen.dart';
import 'package:letsmeet/screens/teams/bookcreen.dart';
import 'Cancelbookingteam.dart';
import 'Seemore.dart';

class TeamMeet extends StatefulWidget {
  final List list;
  final int index;
  const TeamMeet({Key key, this.list, this.index}) : super(key: key);

  @override
  _TeamMeetState createState() => _TeamMeetState();
}

class _TeamMeetState extends State<TeamMeet> {
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
    //getData();
    //checkinvite().getuserinvite(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.list);
    return Scaffold(
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Seemore(
                    team_id: widget.list[widget.index]['team_id'],
                    team_name: widget.list[widget.index]['team_name'])));
          },
          child: Text(
            "See More",
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        permission == 'Managers'
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => teambookscreen(
                            list: widget.list,
                            index: widget.index,
                          )));
                },
                child: Text("Book"),
              )
            : SizedBox(),
      ]),
      appBar: AppBar(
        centerTitle: true,
        title: Text('TeamMeet'),
        backgroundColor: Color(0xFFDCADA3),
        elevation: 0,
        automaticallyImplyLeading: true,
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
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100.0,
                color: Colors.transparent,
                child: new Container(
                    decoration: new BoxDecoration(
                        color: Colors.deepOrange[200],
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(100.0),
                          topRight: const Radius.circular(100.0),
                        )),
                    child: new Center(
                      child: Text(widget.list[widget.index]['team_name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 2.2,
                            fontSize: 22,
                            color: Colors.black,
                            letterSpacing: 0.1,
                          )),
                    )),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: CarendarTeam(widget.list[widget.index]['team_id']),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
