// ignore_for_file: missing_required_param

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/booking/check_user.dart';
import 'package:letsmeet/screens/booking/checkinvite.dart';

class checkmeet extends StatefulWidget {
  final reser_id;
  final room_name;
  final dateoutStr;

  const checkmeet({Key key, this.reser_id, this.room_name, this.dateoutStr})
      : super(key: key);

  @override
  _checkmeetState createState() => _checkmeetState();
}

class _checkmeetState extends State<checkmeet> {
  Future<List> getData() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/meeting/getmeetingmenberCheck.php?reserve_id=${widget.reser_id}"));
    return json.decode(response.body);
  }

  List host = [];
  void getHoster() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/meeting/gethost.php?reserve_id=${widget.reser_id}"));
    var data = json.decode(response.body);
    setState(() {
      host = data;
    });
    print("host : ${host[0]['reserve_id']}");
  }

  @override
  void initState() {
    // TODO: implement initState
    getHoster();
    //checkinvite().getuserinvite(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFCFD7ED),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [Text("${widget.room_name}"), Text("${widget.dateoutStr}",)],
            ),
                ElevatedButton(onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) {
                 return CheckUser(host_id: host[0]['reserve_id'],);
               },));
             }, child: Text('View Saved List'))
          ], 
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFCFD7ED), Color(0xFFE8D9E6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? menberlist(
                    list: snapshot.data,
                    reser_id: widget.reser_id,
                    host: host,
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}

class menberlist extends StatefulWidget {
  final List list;
  final String reser_id;
  final List host;
  const menberlist({Key key, this.list, this.reser_id, this.host})
      : super(key: key);

  @override
  _menberlistState createState() => _menberlistState();
}

class _menberlistState extends State<menberlist> {
    List host = [];
  void getHoster() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/meeting/gethost.php?reserve_id=${widget.reser_id}"));
    var data = json.decode(response.body);
    setState(() {
      host = data;
    });
   
  }
  List<bool> checkedin = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<bool> checkedout = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  void update(String username, var checkedin, var checkedout, var reser_id) {
    var url = Uri.parse("http://$ipconn/letsmeet/teams/checkmeet.php");
    http.post(url, body: {
      'username': username,
      'reser_id': reser_id,
      'checkedin': checkedin.toString(),
      'checkedout': checkedout.toString()
    });
  }

  @override
  Widget build(BuildContext context) {
    String reser_id = widget.reser_id;
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red;
      }
      return Colors.green;
    }

    Color getColorS(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red;
      }
      return Colors.red;
    }

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Container(
                // color: Colors.green,
                padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                width: MediaQuery.of(context).size.width,
                //height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.person,
                                size: 50,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(widget.host[0]['firstname'])
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.21,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text("Host"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
              itemCount: widget.list.length,
              itemBuilder: (context, i) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        //color: Colors.red,
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                        width: MediaQuery.of(context).size.width,
                        //height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 50,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(widget.list[i]['firstname']),
                                ],
                              ),
                            ),
                            SizedBox(
                                    width: 150,
                                  ),
                            Expanded(
                              child: Checkbox(
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                value: checkedin[i],
                                onChanged: i == widget.list.length
                                    ? null
                                    : (bool value) {
                                        setState(() {
                                          checkedin[i] = value;
                                          checkedout[i] = false;
                                           print(checkedin[i]);
                                           print(checkedout[i]);
                                           print(widget.list[i]['username']);
                                          update(
                                              widget.list[i]['username'],
                                              checkedin[i],
                                              checkedout[i],
                                              reser_id);
                                        });
                                      },
                              ),
                            ),
                             Expanded(
                    child: Checkbox(
                      fillColor: MaterialStateProperty.resolveWith(getColorS),
                      
                      value: checkedout[i],
                      onChanged: i == widget.list.length
                          ? null
                          : (bool value) {
                              setState(() {
                                checkedout[i] = value;
                                checkedin[i] = false;
                                 print(checkedout[i]);
                                 print(checkedin[i]);
                                update(widget.list[i]['username'], checkedin[i],
                                    checkedout[i],reser_id);
                              });
                            },
                    ),
                  ),
               
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}
