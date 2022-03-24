import 'dart:convert';
import 'dart:ui';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/advancesearch/advance.dart';
import 'package:letsmeet/src/widgets/Participants.dart';
import 'package:letsmeet/src/widgets/Room.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreenT extends StatefulWidget {
  final List list;

  HomeScreenT({this.list});

  @override
  _HomeScreenTState createState() => _HomeScreenTState();
}

class _HomeScreenTState extends State<HomeScreenT> {
  final _pageController = PageController(viewportFraction: 0.877);

  TextEditingController Searchfield = TextEditingController();
  String username = "";
  String permission = "";

  String search = "";
  bool data1 = false;
  bool data2 = false;
  bool data3 = false;
  bool data4 = false;
  bool data5 = false;

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

  @override
  void initState() {
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(data1);
    // print(data2);
    // print(data3);
    // print(data4);
    // print(data5);
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
              permission == "Admin" || permission == "Managers"
                  ? Column(
                      children: [
                        // custom Navigation Drawer and Search Button
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        //title
                        Center(
                          child: Text(
                            'Room',
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
                                        Icons.filter_alt_sharp,
                                        color: Colors.grey[700],
                                      ),
                                      color: Colors.black,
                                      onPressed: () async {
                                        await _showDialog();
                                        setState(() {});
                                      },
                                    )),
                                border: InputBorder.none
                                // prefixIcon: Icon(Icons.search),
                                ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return advance();
                              }));
                            },
                            child: Text(
                              "Advance Search",
                              style: TextStyle(fontSize: 20),
                            )),
                        //Tab bar with Indicator
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        // Container(
                        //     color: Color(0XFF90CAF9),
                        //     height: MediaQuery.of(context).size.height * 0.1,
                        //     child: fillter()),
                        Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: RoomHome(
                                search: search,
                                data1: data1,
                                data2: data2,
                                data3: data3,
                                data4: data4,
                                data5: data5)),
                      ],
                    )
                  : Column(
                      children: [
                        // custom Navigation Drawer and Search Button
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        //title
                        Center(
                          child: Text(
                            'Room',
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
                                        Icons.filter_alt_sharp,
                                        color: Colors.grey[700],
                                      ),
                                      color: Colors.black,
                                      onPressed: () async {
                                        await _showDialog();
                                        setState(() {});
                                      },
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
                        // Container(
                        //     color: Color(0XFF90CAF9),
                        //     height: MediaQuery.of(context).size.height * 0.1,
                        //     child: fillter()),
                        Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: RoomHome(
                                search: search,
                                data1: data1,
                                data2: data2,
                                data3: data3,
                                data4: data4,
                                data5: data5)),
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

  void _showDialog() {
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
                          "Filter Search",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 2,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CheckboxListTile(
                            value: data1,
                            title: Text("Whiteboard and Chalk"),
                            onChanged: (value) {
                              setState(() => this.data1 = value);
                              this.setState(() {});
                            }),
                        CheckboxListTile(
                          value: data2,
                          title: Text("Projector and Screen"),
                          onChanged: (value) {
                            setState(() {
                              data2 = value;
                              this.setState(() {});
                            });
                          },
                        ),
                        CheckboxListTile(
                          value: data3,
                          title: Text("Podium"),
                          onChanged: (value) {
                            setState(() {
                              data3 = value;
                              this.setState(() {});
                            });
                          },
                        ),
                        CheckboxListTile(
                          value: data4,
                          title: Text("Microphone and Speaker"),
                          onChanged: (value) {
                            setState(() {
                              data4 = value;
                              this.setState(() {});
                            });
                          },
                        ),
                        CheckboxListTile(
                          value: data5,
                          title: Text("Computer"),
                          onChanged: (value) {
                            setState(() {
                              data5 = value;
                              this.setState(() {});
                            });
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            // Material(
                            //   elevation: 5.0,
                            //   color: Colors.blue[900],
                            //   child: MaterialButton(
                            //     padding:
                            //         EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                            //     onPressed: () {
                            //       return HomeScreenT();
                            //     },
                            //     child: Text("Search",
                            //         textAlign: TextAlign.center,
                            //         style: TextStyle(
                            //           color: Colors.white,
                            //           fontSize: 15,
                            //         )),
                            //   ),
                            // ),
                            Material(
                              elevation: 5.0,
                              color: Colors.blue[900],
                              child: MaterialButton(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Search",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    )),
                              ),
                            ),
                          ],
                        )
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
