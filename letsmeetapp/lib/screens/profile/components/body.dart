import 'dart:convert';
import 'dart:io';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/profile/components/editprofilepic.dart';
import 'package:letsmeet/screens/profile/editProfileScareen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'profile_menu.dart';
import 'profile_pic.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  String username = "";

  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
    });
  }

  Future<List> getData() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/profile/profile.php?user_id=${username}"));
    return json.decode(response.body);
  }

  @override
  void initState() {
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? Body(
                list: snapshot.data,
                username: username,
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}

class Body extends StatefulWidget {
  File _image;
  final List list;
  final String username;
  Body({this.list, this.username});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String Provinces = '';
  List ProvincesList = List();
  List ProvincesList2 = List();
  String ProvincesNum = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //DateTime birtyday = DateTime.parse(widget.list[0]['cus_birtday']);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          // ProfilePic(),
          /* FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.grey),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => editprofilepic(
                            list: widget.list,
                            index: 0,
                          )));
                },
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),*/
          /*IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => editprofilepic())),
              icon: const Icon(Icons.add_photo_alternate)),*/
          SizedBox(height: 20),
          ProfileMenu(
            text: "Edit profile",
            icon: "assets/icons/User Icon.svg",
            press: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditData(
                            list: widget.list,
                            index: 0,
                          )))
            },
          ),
          // Text()
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Name:  ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      widget.list[0]['firstname'] +
                          "  " +
                          widget.list[0]['lastname'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ), //ชื่อ นามสกุล
                Row(
                  children: [
                    Text(
                      'Email:  ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      widget.list[0]['email'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ), //ต้นทาง
                Row(
                  children: [
                    Text(
                      'Account:  ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    widget.list[0]['verify_account'] == "1"
                        ? Text(
                            "Verified",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            "Not verified",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),

                /*Row(
                  children: [
                    Text(
                      'วันเกิด:  ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(birtyday).toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),*/
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Permission:  ',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Expanded(
                      child: Text(
                        widget.list[0]['permission'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Age:  ',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Expanded(
                      child: Text(
                        widget.list[0]['age'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}