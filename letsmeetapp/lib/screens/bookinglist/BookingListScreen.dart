import 'dart:convert';
import 'package:letsmeet/ipconn.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:letsmeet/screens/booking/checkinvite.dart';
import 'package:letsmeet/screens/booking/invite.dart';
import 'package:letsmeet/screens/meeting/meetingmenber.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingListScreen extends StatefulWidget {
  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  String username = "";
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

  Future<List> getData() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/booking/getbooking.php?user_id=${username}"));
    return json.decode(response.body);
  }

  Future<List> getData2() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/participant/regetinvite.php?user_id=${username}"));
    setState(() {});
    return json.decode(response.body);
  }

  @override
  void initState() {
    getEmail();
    //checkinvite().getuserinvite(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFCFD7ED),
        ),
        body: permission == "Participant"
            ? FutureBuilder<List>(
                future: getData2(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ItemList(
                          list: snapshot.data,
                          permission: permission,
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              )
            : FutureBuilder<List>(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ItemList(
                          list: snapshot.data,
                          permission: permission,
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ));
  }
}

class ItemList extends StatefulWidget {
  final List list;
  final String permission;
  const ItemList({Key key, this.list, this.permission}) : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  Future<List> getHoster(String reserve_id) async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/meeting/gethost.php?reserve_id=${reserve_id}"));
    var data = json.decode(response.body);

    return data;
  }

  Future<void> responseinvite(String id, String status,
      {List userlist, List hostlist}) async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/participant/responseinvite.php?id=${id}&response=${status}"));
    /*if (status == "1") {
      /*sendmail().sendmailer(
          name: hostlist[0]['inviter'],
          email: hostlist[0]['email'],
          subject:
              "${userlist[0]['firstname']} ${userlist[0]['lastname']} just accect your invite",
          body:
              "${userlist[0]['firstname']} ${userlist[0]['lastname']} just accect your invite");*/
    }*/
    setState(() {});
  }

  GestureDetector reinv(
    List data,
    int i,
  ) {
    DateTime datein =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(widget.list[i]['datein']);
    String dateinStr = DateFormat('HH:mm:ss').format(datein);
    String date = DateFormat('EE dd-MM-yyyy').format(datein);
    DateTime dateout =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(widget.list[i]['dateout']);
    String dateoutStr = DateFormat('HH:mm:ss').format(dateout);
    return GestureDetector(
      onTap: () {
        if (widget.permission == "Participant") {
        } else {
          if (widget.list[i]['meetstatus'] == "1") {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return InvitePage(list: widget.list, index: i);
            }));
          }
        }
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            elevation: 8.0,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Host: ${data[0]['firstname']} ${data[0]['lastname']}"),
                        //Text(widget.list[i]['reserve_id']),
                        /*SizedBox(
                                        width: 5,
                                      ),*/
                        Text("Room: ${widget.list[i]['name']}"),
                        /*SizedBox(
                                        width: 5,
                                      ),*/
                        Text("Date: ${date}"),
                        Text(
                          "Start: ${dateinStr}",
                        ),
                        Text("To: ${dateoutStr}"),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: widget.list[i]['meetstatus'] == "1"
                      ? widget.permission == "Participant"
                          ? Column(
                              children: [
                                Wrap(
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          responseinvite(
                                              widget.list[i]['inmeeting_id'],
                                              "1",
                                              hostlist: data,
                                              userlist: widget.list);
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.green),
                                        child: Text("Accept",
                                            style: TextStyle(
                                                color: Colors.white))),
                                    ElevatedButton(
                                      onPressed: () {
                                        responseinvite(
                                            widget.list[i]['inmeeting_id'], "2",
                                            hostlist: data,
                                            userlist: widget.list);
                                        setState(() {});
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red),
                                      child: Text("Decline",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                                widget.list[i]['meetstatus'] == "1"
                                    ? widget.permission == "Participant"
                                        ? widget.list[i]['Invitestatus'] == "1"
                                            ? Text("Accepted",
                                                style: TextStyle(
                                                    color: Colors.green))
                                            : Text("Declined",
                                                style: TextStyle(
                                                    color: Colors.red))
                                        : Wrap()
                                    : Wrap(),
                              ],
                            )
                          : Wrap(
                              //crossAxisAlignment: WrapCrossAlignment.end,
                              alignment: WrapAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.people),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return meetingmenber(
                                        list: widget.list,
                                        index: i,
                                      );
                                    }));
                                  },
                                )
                              ],
                            )
                      : Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text("cancelled",
                                style: TextStyle(color: Colors.red))
                          ],
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFCFD7ED), Color(0xFFE8D9E6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: ListView.builder(
            itemCount: widget.list.length,
            itemBuilder: (context, i) {
              DateTime datein = DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse(widget.list[i]['datein']);
              String dateinStr = DateFormat('HH:mm:ss').format(datein);
              String date = DateFormat('EE dd-MM-yyyy').format(datein);
              DateTime dateout = DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse(widget.list[i]['dateout']);
              String dateoutStr = DateFormat('HH:mm:ss').format(dateout);

              return FutureBuilder(
                  future: getHoster(widget.list[i]['reserve_id']),
                  builder: (context, data) {
                    if (data.hasError) {
                      print(data.error);
                    }

                    return data.hasData
                        ? reinv(data.data, i)
                        /*Container(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: Material(
                                elevation: 8.0,
                                child: ListTile(
                                  onTap: () {
                                    if (widget.permission == "Participant") {
                                    } else {
                                      if (widget.list[i]['meetstatus'] == "1") {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return InvitePage(
                                              list: widget.list, index: i);
                                        }));
                                      }
                                    }
                                  },
                                  title: Column(
                                    children: [
                                      Text(
                                          "${data.data[0]['firstname']} ${data.data[0]['lastname']}"),
                                      //Text(widget.list[i]['reserve_id']),
                                      /*SizedBox(
                                  width: 5,
                                ),*/
                                      Text(widget.list[i]['name']),
                                      /*SizedBox(
                                  width: 5,
                                ),*/
                                      Text("${date}"),
                                      Text(
                                        "Start ${dateinStr}",
                                      ),
                                      Text("To ${dateoutStr}"),
                                      widget.list[i]['meetstatus'] == "1"
                                          ? widget.permission == "Participant"
                                              ? widget.list[i]
                                                          ['Invitestatus'] ==
                                                      "1"
                                                  ? Text("Accepted",
                                                      style: TextStyle(
                                                          color: Colors.green))
                                                  : Text("Declined",
                                                      style: TextStyle(
                                                          color: Colors.red))
                                              : Wrap()
                                          : Wrap(),
                                    ],
                                  ),
                                  trailing: widget.list[i]['meetstatus'] == "1"
                                      ? widget.permission == "Participant"
                                          ? Column(
                                              children: [
                                                Wrap(
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          responseinvite(
                                                              widget.list[i][
                                                                  'inmeeting_id'],
                                                              "1",
                                                              hostlist:
                                                                  data.data,
                                                              userlist:
                                                                  widget.list);
                                                          setState(() {});
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary: Colors
                                                                    .green),
                                                        child: Text("Accept",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        responseinvite(
                                                            widget.list[i][
                                                                'inmeeting_id'],
                                                            "2",
                                                            hostlist: data.data,
                                                            userlist:
                                                                widget.list);
                                                        setState(() {});
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  Colors.red),
                                                      child: Text("Decline",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Wrap(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.people),
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return meetingmenber(
                                                        list: widget.list,
                                                        index: i,
                                                      );
                                                    }));
                                                  },
                                                )
                                              ],
                                            )
                                      : Wrap(
                                          children: [
                                            Text("cancelled",
                                                style: TextStyle(
                                                    color: Colors.red))
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          )*/
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  });
            }));
  }
}
