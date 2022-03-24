import 'dart:convert';
import 'dart:ui';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/src/widgets/Participants.dart';
import 'package:letsmeet/screens/teams/teams_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'inseart_team.dart';

class BodyTeam extends StatefulWidget {
  final List list;

  BodyTeam({this.list});

  @override
  _BodyTeamState createState() => _BodyTeamState();
}

class _BodyTeamState extends State<BodyTeam> {
  final _pageController = PageController(viewportFraction: 0.877);

  TextEditingController Searchfield = TextEditingController();
  String search = "";
  bool isChecked = false;
  String status = '';

  String username = "";

  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
      status = preferences.getString('status');

      print(' ' + status);
    });
  }

  @override
  void initState() {
    getEmail();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Center(
                    child: Text(
                      'Teams',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 45.6, fontWeight: FontWeight.w700),
                    ),
                  ),

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
                      child: TeamsScreen(search: search)),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: status == 'Managers'
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.green[300],
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return insertteam();
                      }),
                    )
                  },
                  tooltip: 'Create new Team',
                  child: Icon(
                    Icons.add,
                  ),
                ),
              ],
            )
          : Wrap(),
    );
  }
}
