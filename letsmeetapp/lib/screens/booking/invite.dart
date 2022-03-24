import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/booking/checkinvite.dart';
import 'package:letsmeet/sendmail/sendmail.dart';
import 'package:letsmeet/navigation_home_screen.dart';

class InvitePage extends StatefulWidget {
  final List list;
  final int index;

  const InvitePage({Key key, this.list, this.index}) : super(key: key);
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  Future getparticipant() async {
    //print(Searchfield.text);
    if (Searchfield.text == "" || Searchfield.text == null) {
      final response = await http.get(Uri.parse(
          "http://${ipconn}/letsmeet/participant/getfreeparticipant.php"));
      var data = json.decode(response.body);
      setState(() {});
      return data;
    } else {
      final response = await http.get(Uri.parse(
          "http://${ipconn}/letsmeet/participant/getfreeparticipant.php?search=${Searchfield.text}"));
      var data = json.decode(response.body);
      setState(() {});
      return data;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController Searchfield = TextEditingController();
  String search = "";

  @override
  Widget build(BuildContext context) {
    DateTime datein = DateFormat('yyyy-MM-dd HH:mm:ss')
        .parse(widget.list[widget.index]['datein']);
    DateTime dateout = DateFormat('yyyy-MM-dd HH:mm:ss')
        .parse(widget.list[widget.index]['dateout']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFDCADA3),
        elevation: 0,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              padding: EdgeInsets.only(
                right: 20,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavigationHomeScreen()));
              },
              icon: Icon(Icons.home, color: Colors.white)) //note_add
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFDCADA3), Color(0xFFE5EAF3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.13,
              color: Colors.white,
              child: Column(
                children: [
                  Text("Room : ${widget.list[widget.index]['name']}"),
                  //Text("Meeting strat now"),
                  Text(
                      "${DateFormat('HH:mm').format(datein)} - ${DateFormat('HH:mm').format(dateout)}"),
                  /*ElevatedButton(
                      onPressed: () {
                        http.get(Uri.parse(
                            "http://${ipconn}/letsmeet/test/add.php"));
                      },
                      child: Text("Test"))*/
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
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.7,
              //color: Colors.red,
              child: FutureBuilder(
                future: getparticipant(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? participantlist(
                          list: snapshot.data,
                          Room: widget.list,
                          Roomindex: widget.index,
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class participantlist extends StatefulWidget {
  final List list;
  final List Room;
  final int Roomindex;
  const participantlist({Key key, this.list, this.Room, this.Roomindex})
      : super(key: key);

  @override
  _participantlistState createState() => _participantlistState();
}

class _participantlistState extends State<participantlist> {
  List invited = [];
  Future<void> invite(String user_id,
      {List list, int index, List room, int roomindex}) async {
    final uri =
        Uri.parse("http://${ipconn}/letsmeet/participant/addparticipant.php");
    var request = await http.post(uri, body: {
      'reserve_id': widget.Room[widget.Roomindex]['reserve_id'],
      'user_id': user_id,
    });
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/profile/profile.php?user_id=${room[roomindex]['user_id']}"));
    var data = json.decode(response.body);
    final response2 = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/profile/profile.php?user_id=${user_id}"));
    var data2 = json.decode(response2.body);
    sendmail().sendmailer(
        name: data2[0]['firstname'],
        email: data2[0]['email'],
        subject: "You have invited to meeting",
        body:
            "${data[0]['firstname']} have invite you to meeting at ${room[roomindex]['name']} in ${room[roomindex]['datein']} - ${room[roomindex]['dateout']}");
    setState(() {});
  }

  Future<List> getparticipant(String user_id) async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/participant/checkparticipant.php?user_id=${user_id}"));
    var data = json.decode(response.body);

    //setState(() {});
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    invited = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: widget.list.length,
          itemBuilder: (context, i) {
            DateTime meetingin;
            DateTime meetingout;
            if (widget.list[i]['inmeeting_id'] != null) {
              meetingin = DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse(widget.Room[widget.Roomindex]['datein']);
              meetingout = DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse(widget.Room[widget.Roomindex]['dateout']);
            }
            //print(widget.list);

            return Container(
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder<List>(
                  future: getparticipant(widget.list[i]['user_id']),
                  builder: (context, data) {
                    if (data.hasError) {
                      print(data.error);
                    }
                    //print(data.data);
                    /*datein = DateFormat('yyyy-MM-dd HH:mm:ss')
                        .parse(widget.list[i]['datein']);
                    dateout = DateFormat('yyyy-MM-dd HH:mm:ss')
                        .parse(widget.list[i]['dateout']);*/
                    List meet = data.data;
                    List meet_id = [];
                    // List<DateTime> datein = [];
                    //List<DateTime> dateout = [];
                    if (data.hasData) {
                      for (int i = 0; i < meet.length; i++) {
                        meet_id.add(meet[i]['reserve_id']);
                        /* datein.add(DateFormat('yyyy-MM-dd HH:mm:ss')
                          .parse(widget.Room[widget.Roomindex]['datein']));
                      dateout.add(DateFormat('yyyy-MM-dd HH:mm:ss')
                          .parse(widget.Room[widget.Roomindex]['dateout']));*/
                      }
                    }

                    return data.hasData
                        ? !meet_id.contains(
                                widget.Room[widget.Roomindex]['reserve_id'])
                            ? Container(
                                //color: Colors.blue,
                                padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                width: MediaQuery.of(context).size.width,
                                //height: 20,
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.add_alert,
                                          size: 50,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            invite(widget.list[i]['user_id'],
                                                list: widget.list,
                                                index: i,
                                                room: widget.Room,
                                                roomindex: widget.Roomindex);
                                            invited
                                                .add(widget.list[i]['user_id']);
                                          },
                                          child: Text("Invite"),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                        "${widget.list[i]['firstname']} ${widget.list[i]['lastname']} \n \nDepartment: ${widget.list[i]['department']} "),
                                  ],
                                ),
                              )
                            : Container()
                        : Center(child: CircularProgressIndicator());
                  }),
            );
          }),
    );
  }
}
