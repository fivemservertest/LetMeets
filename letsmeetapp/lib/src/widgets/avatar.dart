import 'dart:convert';
import 'package:letsmeet/ipconn.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_theme.dart';

class HomeAvatar extends StatefulWidget {
  @override
  _HomeAvatarState createState() => _HomeAvatarState();
}

class _HomeAvatarState extends State<HomeAvatar> {
  String username = "";

  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
    });
  }

  Future<List> getData() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/hotelpro/getdata/getprofile.php?user_id=${username}"));
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
            : Center(
                child: CircularProgressIndicator(),
              );
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
    return Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: AppTheme.grey.withOpacity(0.6),
                offset: const Offset(2.0, 4.0),
                blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(60.0)),
          child: widget.list[0]['user_type'] == "user"
              ? Image.network(
                  'http://${ipconn}/hotelpro/upload/user/${widget.list[0]['user_pic']}')
              : Image.network(
                  'http://${ipconn}/hotelpro/upload/admin/${widget.list[0]['user_pic']}'),
        ));
  }
}
