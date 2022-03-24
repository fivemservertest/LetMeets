import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/bookinglist/showhost.dart';
import 'package:letsmeet/sendmail/sendmail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InviteList extends StatefulWidget {
  @override
  _InviteListState createState() => _InviteListState();
}

class _InviteListState extends State<InviteList> {
  String username = "";

  Future<List> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
    });
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/participant/getinvite.php?user_id=${username}"));
    
    var data = json.decode(response.body);
    print (data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFCFD7ED),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFCFD7ED), Color(0xFFE8D9E6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: FutureBuilder<List>(
          future: getData(),
          builder: (context, data) {
            if (data.hasError) {
              print(data.error);
            }
            //print(data.data);
            return data.hasData
                ? showlist(list: data.data, id: username)
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}

class showlist extends StatefulWidget {
  final List list;
  final String id;
  const showlist({Key key, this.list, this.id}) : super(key: key);

  @override
  _showlistState createState() => _showlistState();
}

class _showlistState extends State<showlist> {
  /*Future<List> getHoster(String reserve_id) async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/meeting/gethost.php?reserve_id=${reserve_id}"));
    var data = json.decode(response.body);

    return data;
  }*/

  Future<void> responseinvite(String id, String status,
      {List userlist, int i}) async {
    print("Update");
    print(id);
    print(status);
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/participant/responseinvite.php?id=${id}&response=${status}"));
    final response2 = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/profile/profile.php?user_id=${widget.id}"));
    var data = json.decode(response2.body);
    if (status == "1") {
      sendmail().sendmailer(
          name: userlist[i]['firstname'],
          email: userlist[i]['email'],
          subject:
              "${data[0]['firstname']} ${data[0]['lastname']} just accept your invite",
          body:
              "${data[0]['firstname']} ${data[0]['lastname']} just accept your invite");
    } else {
      sendmail().sendmailer(
          name: userlist[i]['firstname'],
          email: userlist[i]['email'],
          subject:
              "${data[0]['firstname']} ${data[0]['lastname']} just declined your invite",
          body:
              "${data[0]['firstname']} ${data[0]['lastname']} just declined your invite");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.list);
    return Container(
      child: ListView.builder(
          itemCount: widget.list.length,
          itemBuilder: (context, i) {
            DateTime datein = DateFormat('yyyy-MM-dd HH:mm:ss')
                .parse(widget.list[i]['datein']);
            String dateinStr = DateFormat('HH:mm:ss').format(datein);
            String date = DateFormat('EE dd-MM-yyyy').format(datein);
            DateTime dateout = DateFormat('yyyy-MM-dd HH:mm:ss')
                .parse(widget.list[i]['dateout']);
            String dateoutStr = DateFormat('HH:mm:ss').format(dateout);
            return /*FutureBuilder(
                future: getHoster(widget.list[i]['reserve_id']),
                builder: (context, data) {
                  if (data.hasError) {
                    print(data.error);
                  }
                  return data.hasData
                      ?*/
                Container(
                  
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Material(
                  elevation: 8.0,
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Name: ${widget.list[i]['firstname']} ${widget.list[i]['lastname']}"),
                        //Text(widget.list[i]['reserve_id']),
                        /*SizedBox(
                                        width: 5,
                                      ),*/
                        Text("Room: ${widget.list[i]['name']}"),
                        /*SizedBox(
                                        width: 5,
                                      ),*/
                        Text("Date: ${date}"),
                        Text(
                          "Start: ${dateinStr}",
                        ),
                        Text("To: ${dateoutStr}"),
                      ],
                    ),
                    trailing: Wrap(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              responseinvite(
                                  widget.list[i]['inmeeting_id'], "1",
                                  //hostlist: data.data,
                                  userlist: widget.list,
                                  i: i);
                           
                            },
                            style:
                                ElevatedButton.styleFrom(primary: Colors.green),
                            child: Text("Accept",
                                style: TextStyle(color: Colors.white))),
                        ElevatedButton(
                          onPressed: () {
                            responseinvite(widget.list[i]['inmeeting_id'], "2",
                                //hostlist: data.data,
                                userlist: widget.list,
                                i: i);
                           
                          },
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          child: Text("Decline",
                              style: TextStyle(color: Colors.white)),
                        ),
                        //       ElevatedButton(
                        //   onPressed: () {
                        //       Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) { 
                        //             return ShowHost(
                        //               res_id: widget.list[i]['reser'],
                        //             );
                        //        }));
                        //   },
                        //   style: ElevatedButton.styleFrom(primary: Colors.blue),
                        //   child: Text("Decline",
                        //       style: TextStyle(color: Colors.white)),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            );
            /*: Center(
                          child: CircularProgressIndicator(),*/
            //);
            //});
          }),
    );
  }
}
