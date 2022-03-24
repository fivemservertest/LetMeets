import 'dart:convert';
import 'dart:ui';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/mainscreen/HomeScreen.dart';
import 'package:letsmeet/src/widgets/Participants.dart';
import 'package:letsmeet/screens/teams/teams_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'inseart_team.dart';
import 'package:letsmeet/screens/teams/addm_screen.dart';
import 'body.dart';
import 'package:letsmeet/navigation_team_screen.dart';

class Body_menber extends StatefulWidget {
  final List list;
  final String data;
  Body_menber({this.list, this.data});

  @override
  _Body_menberState createState() => _Body_menberState();
}

class _Body_menberState extends State<Body_menber> {
  final _pageController = PageController(viewportFraction: 0.877);

  TextEditingController Searchfield = TextEditingController();
  String search = "";
  bool isChecked = false;
  String team_name = "";
  @override
  void initState() {
    //checkinvite().getuserinvite(context);
    getname();
    print("team :" + widget.data);
    super.initState();
  }

  void getname() async {
    setState(() {
      team_name = widget.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFDCADA3),
        title: new Text(
          'Add Member To Team : ' + widget.data,
          style: new TextStyle(color: Colors.black),
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NavigationTeamScreen()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFDCADA3), Color(0xFFE5EAF3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: PageView(
            children: [
              Column(
                children: [
                  // custom Navigation Drawer and Search Button
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),

                  //title
                  // Center(
                  //   child: Text(
                  //     'Add Member To Team : ' + widget.data,
                  //     style: GoogleFonts.playfairDisplay(
                  //         fontSize: 20, fontWeight: FontWeight.w700),
                  //   ),
                  // ),

                  //SearchField(),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Container(
                    color: Colors.white,
                    child: TextField(
                      controller: Searchfield,
                      onChanged: (v) {
                        setState(() {
                          search = v;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 14.0),
                          hintText: "Search",
                          suffixIcon: Material(
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(0.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.search,
                                ),
                                color: Colors.black,
                                onPressed: () {},
                              )),
                          border: InputBorder.none
                          // prefixIcon: Icon(Icons.search),
                          ),
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),

                  Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Addm_screen(search: search, data: widget.data)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
