import 'dart:convert';
import 'package:letsmeet/ipconn.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';

class HomeUsername extends StatefulWidget {
  @override
  _HomeUsernameState createState() => _HomeUsernameState();
}

class _HomeUsernameState extends State<HomeUsername> {
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
            ? ItemList(
                list: snapshot.data,
              )
            : CircularProgressIndicator();
      },
    );
  }
}

class ItemList extends StatefulWidget {
  final List list;

  ItemList({
    this.list,
  });

  @override
  ItemListState createState() => ItemListState();
}

class ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.list[0]['firstname'] + "  " + widget.list[0]['lastname'],
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppTheme.grey,
        fontSize: 18,
      ),
    );
  }
}
