import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/booking/checkinvite.dart';

class meetingmenber extends StatefulWidget {
  final List list;
  final int index;
  const meetingmenber({Key key, this.list, this.index}) : super(key: key);

  @override
  _meetingmenberState createState() => _meetingmenberState();
}

class _meetingmenberState extends State<meetingmenber> {
  Future<List> getData() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/meeting/getmeetingmenber.php?reserve_id=${widget.list[widget.index]['reserve_id']}"));
    return json.decode(response.body);
  }

  List host = [];
  void getHoster() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/meeting/gethost.php?reserve_id=${widget.list[widget.index]['reserve_id']}"));
    var data = json.decode(response.body);
    setState(() {
      host = data;
    });
    print(host);
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
        title: Column(
          children: [
            Text("${widget.list[widget.index]['name']}"),
            Text("${widget.list[widget.index]['datein']}")
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
                    reserve_id: widget.list[widget.index]['reserve_id'],
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
  final String reserve_id;
  final List host;
  const menberlist({Key key, this.list, this.reserve_id, this.host})
      : super(key: key);

  @override
  _menberlistState createState() => _menberlistState();
}

class _menberlistState extends State<menberlist> {
  List<Widget> checkbox(String status) {
    bool accect = false;
    bool de = false;
    print(status);
    if (status == '1') {
      accect = true;
    } else if (status == '2') {
      de = true;
    } else {
      accect = false;
      de = false;
    }

    return [
      accect
          ? Container(
              height: 20,
              width: MediaQuery.of(context).size.width * 0.21,
              child: Text(
                "Accepted",
                style: TextStyle(color: Colors.green),
              ),
            )
          : de
              ? Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.21,
                  child: Text("Declined", style: TextStyle(color: Colors.red)),
                )
              : Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.21,
                  child: Text("No respond"),
                ),
      /*accect
          ? Container(
              height: 20,
              width: 20,
              child: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            )
          : Container(
              height: 20,
              width: 20,
              child: Icon(Icons.check_box_outline_blank)),
      SizedBox(
        width: 10,
      ),
      de
          ? Container(
              height: 20,
              width: 20,
              child: Icon(
                Icons.indeterminate_check_box,
                color: Colors.red,
              ),
            )
          : Container(
              height: 20,
              width: 20,
              child: Icon(Icons.check_box_outline_blank)),
      /*Checkbox(value: accect, onChanged: (v) {}),
      Checkbox(value: de, onChanged: (v) {}),*/*/
    ];
  }

  @override
  Widget build(BuildContext context) {
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
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Row(
                                  children:
                                      checkbox(widget.list[i]['Invitestatus']),
                                ),
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
