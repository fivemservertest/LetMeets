import 'dart:convert';
import 'dart:io';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/verify/components/verify_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
    final response = await http
        .get(Uri.parse("http://${ipconn}/letsmeet/verify/show_register.php"));
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
            ? new Itemlist(list: snapshot.data)
            : new Center(
                child: new CircularProgressIndicator(),
              );
      },
    );
  }
}

class Itemlist extends StatefulWidget {
  final list;
  final i;
  Itemlist({this.list, this.i});
  @override
  _ItemlistState createState() => _ItemlistState();
}

class _ItemlistState extends State<Itemlist> {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: widget.list == null ? 0 : widget.list.length,
        itemBuilder: (context, i) {
          return SingleChildScrollView(
            child: Column(
              children: [
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account',
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
                            widget.list[i]['firstname'] +
                                "  " +
                                widget.list[i]['lastname'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ), //Name-Surname

                      Row(
                        children: [
                          Text(
                            'department:  ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            widget.list[i]['department'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      Align(
                          alignment: Alignment.topRight,
                          child: RaisedButton(
                            onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => verify_detail(
                                            list: widget.list,
                                            index: i,
                                          )))
                            },
                            color: Colors.blue,
                            child: Text(
                              'Verify',
                              style: TextStyle(color: Colors.white),
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
