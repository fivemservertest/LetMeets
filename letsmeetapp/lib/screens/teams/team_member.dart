import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:letsmeet/navigation_home_screen.dart';
import 'package:letsmeet/screens/loginscreen/login.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:flutter/material.dart';
import 'package:letsmeet/screens/teams/team_detail.dart';
import 'package:letsmeet/screens/teams/components/body.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:letsmeet/screens/teams/components/body_m.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class team_member extends StatefulWidget {
  final List list;
  final int index;

  const team_member({Key key, this.list, this.index}) : super(key: key);

  @override
  _teammemberState createState() => _teammemberState();
}

class _teammemberState extends State<team_member> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String team_name = "";
  String username = "";
  String h_firstname = '';
  String h_lastname = '';
  String status = '';
  void initState() {
    getus();
    // gethost();
    super.initState();
  }

  // Future gethost() async {
  //   final response2 = await http.get(Uri.parse(
  //       "http://${ipconn}/letsmeet/teams/getnamehost.php?team_name=${widget.list[widget.index]['team_name']}"));
  //   var data2 = json.decode(response2.body);
  //   print(data2);
  //   h_firstname = data2[0]['firstname'];
  //   h_lastname = data2[0]['firstname'];
  // }

  void getus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // final response2 = await http.get(Uri.parse(
    //     "http://${ipconn}/letsmeet/teams/getnamehost.php?team_name=${widget.list[widget.index]['team_name']}"));
    // var data2 = json.decode(response2.body);
    // print(data2);
    setState(() {
      username = preferences.getString('fullname');
      status = preferences.getString('status');
      team_name = widget.list[widget.index]['team_name'];
      // h_firstname = data2[0]['firstname'];
      // h_lastname = data2[0]['firstname'];
    });
  }

  //  void gethost() async {
  //     final response2 = await http.get(Uri.parse(
  //         "http://${ipconn}/letsmeet/teams/getnamehost.php?team_name=${widget.list[widget.index]['team_name']}"));
  //     var data2 = json.decode(response2.body);
  //     print(data2);
  //     h_firstname = data2[0]['firstname'];
  //     h_lastname = data2[0]['firstname'];

  // }

  Future<List> getdata() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/teams/viewmember.php?team_name=${team_name}"));
    return json.decode(response.body);
  }

  Future addmember() async {
    var url = "http://${ipconn}/letsmeet/teams/checkstatus.php";
    var response =
        await http.post(Uri.parse(url), body: {"username": username});
    var data = json.decode(response.body);
    if (data == "pass") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Body_menber(data: team_name)));
    } else {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.warning,
            title: "You dont have permission",
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: status == 'Managers'
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () => {addmember()},
                  tooltip: 'Add Member',
                  child: Icon(
                    Icons.add,
                  ),
                ),
              ],
            )
          : Wrap(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Member'),
        backgroundColor: Color(0xFFDCADA3),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: ListView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 100.0,
                    color: Colors.transparent,
                    child: new Container(
                        decoration: new BoxDecoration(
                            color: Colors.deepOrange[200],
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(100.0),
                              topRight: const Radius.circular(100.0),
                            )),
                        child: new Center(
                          child: Text(team_name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 2.2,
                                fontSize: 22,
                                color: Colors.black,
                                letterSpacing: 0.1,
                              )),
                        )),
                  ),

                  // Container(
                  //   child: Text(team_name,
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         height: 2.2,
                  //         fontSize: 22,
                  //         color: Colors.black,
                  //         letterSpacing: 0.1,
                  //       )),
                  // ),
                  SizedBox(
                    height: 30,
                  ),
                  // Wrap(
                  //   children: [
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     ElevatedButton(
                  //         style: ElevatedButton.styleFrom(
                  //             primary: Colors.lightBlue),
                  //         onPressed: () {
                  //           addmember();
                  //         },
                  //         child: Text('+  ' + "Invite")),
                  //   ],
                  // ),
                  // Container(
                  //   width: 370,
                  //   child: Card(
                  //     child: ListTile(
                  //       leading: Icon(Icons.account_box_rounded,
                  //           color: Colors.deepOrangeAccent[200]),
                  //       title: Text(h_firstname + " " + h_lastname,
                  //           style:
                  //               TextStyle(fontSize: 17, color: Colors.black)),
                  //       trailing: Wrap(
                  //         children: [
                  //           Text('Host',
                  //               style:
                  //                   TextStyle(fontSize: 17, color: Colors.blue))
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    height: 500,
                    width: 390,
                    child: new FutureBuilder<List>(
                      future: getdata(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        return snapshot.hasData
                            ? new Itemlist(list: snapshot.data,
                            status : status) 
                            : new Center(
                                child: new CircularProgressIndicator(),
                              );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Itemlist extends StatefulWidget {
  final list;
  final status;
  Itemlist({this.list,this.status});
  @override
  _ItemlistState createState() => _ItemlistState();
}

class _ItemlistState extends State<Itemlist> {
  void deleteData(String username, team_name) {
    var url = Uri.parse("http://$ipconn/letsmeet/teams/deletemem.php");
    http.post(url, body: {'username': username, 'team_name': team_name});
  }

  void confirm(context, String username, String team_name) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: context,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Cancle",
            title: "Are you sure that you want to remove this member?",
            text: "User : ${username}",
            confirmButtonText: "Confirm",
            type: ArtSweetAlertType.warning));

    if (response == null) {
      return;
    }

    if (response.isTapConfirmButton) {
      setState(() {
        deleteData(username, team_name);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => team_member(
                      list: widget.list,
                      index: 0,
                    )));
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.success,
              title: "Successful removed",
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: widget.list == null ? 0 : widget.list.length,
      itemBuilder: (context, i) {
        String username = widget.list[i]['username'];
        String firstname = widget.list[i]['firstname'];
        String lastname = widget.list[i]['lastname'];
        String status = widget.list[i]['status'];
        String team_name = widget.list[i]['team_name'];

        return Container(
          height: 80,
          child: Padding(
            padding: EdgeInsets.only(left: 10, bottom: 5, right: 10, top: 5),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.account_box_rounded,
                    color: Colors.deepOrangeAccent[200]),
                title: Text(
                    widget.list[i]['firstname'] +
                        " " +
                        widget.list[i]['lastname'],
                    style: TextStyle(fontSize: 17, color: Colors.black)),
                trailing: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Text(widget.list[i]['status'],
                          style: TextStyle(fontSize: 17, color: Colors.blue)),
                    ),
                    widget.list[i]['status'] == "Host" 
                        ? SizedBox()
                        : widget.status == "Managers" ?
                         IconButton(
                            color: Colors.red,
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              confirm(context, username, team_name);
                            },
                          ): SizedBox()
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
