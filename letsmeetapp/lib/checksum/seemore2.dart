// ignore_for_file: unnecessary_brace_in_string_interps, unused_local_variable, non_constant_identifier_names, missing_return, unused_import

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/checksum/seemore3.dart';
import 'package:letsmeet/checksum/show.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/teams/Seemore.dart';

class SeeMore2 extends StatefulWidget {
  final room_id;
  final name;
  final datein;
  final dateout;
  final int index;

  SeeMore2({this.name, this.room_id, this.datein, this.dateout, this.index});

  @override
  State<SeeMore2> createState() => _SeeMore2State();
}

class _SeeMore2State extends State<SeeMore2> {
  String room_id;
  String nameroom;
  String count;
  List roomList;

  Future get() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/checksum/countbookingroom.php?room_id=${widget.room_id}"));
    var data = json.decode(response.body);

    setState(() {
      count = data[0]['total'];
      print(count);
    });
  }

  
  Future<List> Showdata() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/checksum/show.php?room_id=${widget.room_id}"));
    var data = json.decode(response.body);
    setState(() {
      roomList = data;
    });

    print(roomList);
  }

  @override
  void initState() {
    get();
    Showdata();

    room_id = widget.room_id;
    nameroom = widget.name;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade800,
      ),
      body: SafeArea(
        child: Container(
            height: 700,
            width: double.infinity,
            color: Colors.blue.shade800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  nameroom,
                  style: TextStyle(fontSize: 45, color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text(
                        "Booking Count : ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        count,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: roomList.length,
                    itemBuilder: (BuildContext context, int index) {
                      DateTime tempDate =
                          DateTime.parse(roomList[index]['datein']);
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(tempDate);
                      DateTime tempDate2 =
                          DateTime.parse(roomList[index]['datein']);
                      String formattedDate2 =
                          DateFormat('hh:mm:ss').format(tempDate2);
                      DateTime tempDate3 =
                          DateTime.parse(roomList[index]['dateout']);
                      String formattedDate3 =
                          DateFormat('hh:mm:ss').format(tempDate3);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            height: 84,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(9),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date :  ${formattedDate}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text('Start :  ${formattedDate2}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500)),
                                      Text('To     : ${formattedDate3}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 60,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return Seemore3(
                                            user_id: roomList[index]['user_id'],
                                            date: formattedDate,
                                            timein: formattedDate2,
                                            timeout: formattedDate3,
                                          );
                                        })
                                        );
                                      },
                                      child: Text('Detail'))
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
