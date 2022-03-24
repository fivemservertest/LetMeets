// ignore_for_file: unnecessary_brace_in_string_interps, camel_case_types, unused_import, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class seemorecahrt extends StatefulWidget {
  final room_id;
  final name;
  final size;
  const seemorecahrt({Key key, this.room_id, this.name, this.size})
      : super(key: key);

  @override
  State<seemorecahrt> createState() => _seemorecahrtState();
}

class _seemorecahrtState extends State<seemorecahrt> {
  String room_id;
  String name;
  String size;
  String count;

  Future get() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/checksum/countbookingroom.php?room_id=${widget.room_id}"));
    var data = json.decode(response.body);
    setState(() {
      count = data[0]['total'];
      print(count);
    });
  }

  @override
  void initState() {
    get();
    room_id = widget.room_id;
    name = widget.name;
    size = widget.size;

    print(room_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo[500],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // title: Text('Meeting', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(),
          child: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text("Room Summary",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    //height: 500,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                              5.0) //                 <--- border radius here
                          ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      'Room Name: ',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      name,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      'Room Size  : ',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      size,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      'Total book count : ',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      count,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 280,
                      width: 390,
                      child: InAppWebView(
                          initialUrlRequest: URLRequest(
                              url: Uri.parse(
                                  "http://${ipconn}/letsmeet/checksum/Chart.php?room_id=${room_id}&name=${name}"))))
                ],
              ),
            ],
          ),
        ));
  }
}
