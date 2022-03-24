import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:http/http.dart' as http;
class ShowHost extends StatefulWidget {
  final String res_id ;
  ShowHost({this.res_id});

  @override
  State<ShowHost> createState() => _ShowHostState();
}

class _ShowHostState extends State<ShowHost> {
  List dataList ;
   Future<List> getHoster(String res_id) async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/participant/gethost.php?reserve_id=${widget.res_id}"));
    var data = json.decode(response.body);
    setState(() {
      dataList = data ;
    });
    print(dataList);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:  Center(child: Text(widget.res_id)),
    );
  }
}