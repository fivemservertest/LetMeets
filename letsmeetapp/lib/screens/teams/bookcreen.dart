import 'dart:convert';
import 'dart:ui';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/src/widgets/Participants.dart';
import 'package:letsmeet/src/widgets/Room.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Roomteambook.dart';
import 'package:letsmeet/navigation_home_screen.dart';

class teambookscreen extends StatefulWidget {
  final List list;
  final int index;

  const teambookscreen({Key key, this.list, this.index}) : super(key: key);

  @override
  _teambookscreenState createState() => _teambookscreenState();
}

class _teambookscreenState extends State<teambookscreen> {
  final _pageController = PageController(viewportFraction: 0.877);

  TextEditingController Searchfield = TextEditingController();
  String search = "";

  @override
  void initState() {
    //checkinvite().getuserinvite(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('teambooksceen' + widget.list[widget.index]['team_id']);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Room',
          style: GoogleFonts.playfairDisplay(
              color: Colors.black, fontSize: 30.6, fontWeight: FontWeight.w700),
        ),
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
                  //     'Room',
                  //     style: GoogleFonts.playfairDisplay(
                  //         fontSize: 45.6, fontWeight: FontWeight.w700),
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
                  //Tab bar with Indicator
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),

                  Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Roomteam(
                          search: search,
                          team_id: widget.list[widget.index]['team_id'])),
                ],
              ),
              Column(
                children: [
                  // custom Navigation Drawer and Search Button
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  //title
                  Center(
                    child: Text(
                      'Participant',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 45.6, fontWeight: FontWeight.w700),
                    ),
                  ),

                  //SearchField(),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  //Tab bar with Indicator

                  Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: permissionHome()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}









      // Container(
      //                 height: MediaQuery.of(context).size.height * 0.7,
      //                 child: Roomteam(
      //                     search: search,
      //                     team_id: widget.list[widget.index]['team_id'])),