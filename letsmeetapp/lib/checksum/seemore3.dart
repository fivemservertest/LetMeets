// ignore_for_file: unused_import, non_constant_identifier_names, missing_return, unused_local_variable, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';

class Seemore3 extends StatefulWidget {
  final user_id;
  final date;
  final timein;
  final timeout;
  Seemore3({this.user_id, this.date, this.timein, this.timeout});

  @override
  State<Seemore3> createState() => _Seemore3State();
}

class _Seemore3State extends State<Seemore3> {
  List userList;
  Future<List> getdata() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/checksum/show2.php?user_id=${widget.user_id}"));
    var data_user = json.decode(response.body);
    print(data_user);
    setState(() {
      userList = data_user;
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue.shade800,
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 700,
              color: Colors.blue.shade800,
            ),
            Positioned(
              left: 9,
              top: 10,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(8)),
                child: Container(
                  height: 150,
                  width: 370,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Host : ${userList[0]['firstname']} '
                          ' ${userList[0]['lastname']} ',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          "Date : ${widget.date}",
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          "Start : ${widget.timein}",
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          "To     : ${widget.timeout}",
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
