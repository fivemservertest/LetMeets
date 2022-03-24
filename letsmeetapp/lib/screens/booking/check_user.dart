// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, missing_return

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
class CheckUser extends StatefulWidget {
  final host_id ;

  CheckUser({Key key, host, this.host_id, }) : super(key: key);

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  List dataList ;
    Future<List> getData() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/meeting/showcheck.php?host_id=${widget.host_id}"));
    var data = json.decode(response.body);
  
    setState(() {
      dataList = data;  
      print('dataList : ${dataList}');
        });
  }
  @override
  void initState() {
   getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFFCFD7ED),),
      body: Container(
        color: Color(0xFFCFD7ED,),
        child: Column(
          children: [
            SizedBox(height: 30,),
            Padding(
           padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Username",style: TextStyle(fontSize: 20),),
                  Text("Status",style: TextStyle(fontSize: 20),),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Expanded(
              child: ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (BuildContext context, int index) { 
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person,size: 50,),
                    SizedBox(width: 10,),
                    Text(dataList[index]['chk_name'],style: TextStyle(color: Colors.black,fontSize: 18),),
                  ],
                ),
                Text(dataList[index]['chk_status'],style: TextStyle(color: Colors.black,fontSize: 18),),
              ],
                        ),
                      );
                     },),
            ),
          ],
        )
      )
      
    );
  }
}