import 'dart:convert';
import 'package:letsmeet/ipconn.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:letsmeet/screens/booking/checkinvite.dart';
import 'package:letsmeet/screens/booking/detailroom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:letsmeet/screens/booking/Cancelbooking.dart';

class BookingListHistory extends StatefulWidget {
  final String search;
  const BookingListHistory({Key key, this.search}) : super(key: key);
  @override
  _BookingListHistoryState createState() => _BookingListHistoryState();
}

class _BookingListHistoryState extends State<BookingListHistory> {
  String username = "";
  String permission = "";

  @override
  void initState() {
    print(widget.search);
    getEmail();
    //checkinvite().getuserinvite(context);
    super.initState();
  }

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
    if (widget.search == "" || widget.search == null) {
      final response = await http.get(Uri.parse(
          "http://${ipconn}/letsmeet/booking/getbooking.php?user_id=${username}"));
      return json.decode(response.body);
    } else {
      final response = await http.get(Uri.parse(
          "http://${ipconn}/letsmeet/booking/getbooking.php?user_id=${username}&search=${widget.search}"));
      return json.decode(response.body);
    }
  }

  Future<List> getData2() async {
    if (widget.search == "" || widget.search == null) {
      final response = await http.get(Uri.parse(
          "http://${ipconn}/letsmeet/booking/getbookingparticipant.php?user_id=${username}"));
      return json.decode(response.body);
    } else {
      final response = await http.get(Uri.parse(
          "http://${ipconn}/letsmeet/booking/getbookingparticipant.php?user_id=${username}&search=${widget.search}"));
      return json.decode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  final String permission;

  ItemList({this.list, this.permission});

  void daleteData(idhom) {
    /*var url = "http://${ipconn}/letsmeet/booking/cancelbooking.php";
    http.post(url, body: {'check_in_check_out_id': idhom});*/
  }

  @override
  Widget build(BuildContext context) {
    DateTime dater = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(dater);
    DateTime now = new DateFormat('dd/MM/yyyy').parse(formattedDate);
    // print(now.add(Duration(days: -3)));
    return Container(
      width: 1000,
      height: 1000,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFCFD7ED), Color(0xFFE8D9E6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          //var idhom = list[i]['check_in_check_out_id'];
          DateTime datein =
              DateFormat('yyyy-MM-dd HH:mm:ss').parse(list[i]['datein']);
          DateTime dateout =
              DateFormat('yyyy-MM-dd HH:mm:ss').parse(list[i]['dateout']);
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              list[i]['name'],
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 10),
                                      child: Text(
                                          "${DateFormat('EE dd-MM-yyyy').format(datein)}"),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                           top: 10),
                                      child: Text(
                                        "${DateFormat('HH:mm').format(datein)} - ${DateFormat('HH:mm').format(dateout)}",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => detailroom(
                                          list: list[i],
                                          host: list[i]['user_id'],
                                          reserve_id: list[i]['reserve_id'])));
                                },
                                child: Text("View meeting")),
                          ),

                          // Container(
                          //   width: 120.0,
                          //   child: Text(
                          //     list[i]['name'],
                          //     style: TextStyle(
                          //       fontSize: 18.0,
                          //       fontWeight: FontWeight.w600,
                          //     ),
                          //     overflow: TextOverflow.ellipsis,
                          //     maxLines: 2,
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Text(
                          //   '${DateFormat('EE dd-MM-yyyy').format(datein)}',
                          //   style: TextStyle(
                          //     color: Colors.black,
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Text(
                          //   '${DateFormat('HH:mm').format(datein)} - ${DateFormat('HH:mm').format(dateout)}',
                          //   style: TextStyle(
                          //     color: Colors.black,
                          //   ),
                          // ),
                          // SizedBox(height: 10.0),
                          // ElevatedButton(
                          //     onPressed: () {
                          //       Navigator.of(context).push(MaterialPageRoute(
                          //           builder: (context) => detailroom(
                          //               list: list[i],
                          //               host: list[i]['user_id'],
                          //               reserve_id: list[i]['reserve_id'])));
                          //     },
                          //     child: Text("View meeting")),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
