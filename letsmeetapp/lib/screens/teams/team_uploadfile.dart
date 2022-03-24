import 'dart:convert';
import 'dart:io';

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

class teamupload extends StatefulWidget {
  final List list;
  final int index;
  const teamupload({Key key, this.list, this.index}) : super(key: key);

  @override
  _teamuploadState createState() => _teamuploadState();
}

class _teamuploadState extends State<teamupload> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String team_name = "";
  void initState() {
    team_name = widget.list[widget.index]['team_name'];
    super.initState();
  }

  Future<List> getdata() async {
    print("getdata :" + team_name);
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/teams/showfile.php?team_name=${team_name}"));

    return json.decode(response.body);
    //  print(data);
  }

  File selectfile;
  Future upload() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectfile = File(result.files.single.path);
      });
      showfile();
    }
  }

  Future showfile() async {
    final uri = Uri.parse("http://${ipconn}/letsmeet/teams/uploadfile.php");
    var request = http.MultipartRequest('POST', uri);
    var fileup = await http.MultipartFile.fromPath("file", selectfile.path);
    print(selectfile);
    request.files.add(fileup);

    request.fields['team_name'] = team_name;
    var response = await request.send();

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Documents'),
        backgroundColor: Color(0xFFDCADA3),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      floatingActionButton: 
           Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () => {upload()},
                  tooltip: 'Add Member',
                  child: Icon(
                    Icons.add,
                  ),
                ),
              ],
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
                  //   child: Text("Documents",
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         height: 2.2,
                  //         fontSize: 22,
                  //         color: Colors.black,
                  //         letterSpacing: 0.1,
                  //       )),
                  // ),
                  // Wrap(
                  //   children: [
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     ElevatedButton(
                  //         style: ElevatedButton.styleFrom(
                  //             primary: Colors.lightBlue),
                  //         onPressed: () {
                  //           upload();
                  //         },
                  //         child: Text("+ Add File")),
                  //   ],
                  // ),
                  Container(
                    height: 500,
                    width: 390,
                    child: new FutureBuilder<List>(
                      future: getdata(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        return snapshot.hasData
                            ? new Itemlist(
                                list: snapshot.data, team_name: team_name)
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
  final team_name;
  Itemlist({this.list, this.team_name});
  @override
  _ItemlistState createState() => _ItemlistState();
}

class _ItemlistState extends State<Itemlist> {
  loadfile(context, String file_name, team_name) async {
    if (!await launch('http://${ipconn}/letsmeet/teams/upload/' +
        team_name +
        '/' +
        file_name)) throw 'file error';
    print(team_name);
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: widget.list == null ? 0 : widget.list.length,
      itemBuilder: (context, i) {
        String file_name = widget.list[i]['file_name'];

        print("list :" + file_name);
        return Container(
          height: 80,
          child: Padding(
            padding: EdgeInsets.only(left: 10, bottom: 5, right: 10, top: 5),
            child: Card(
              child: ListTile(
                title: Text(widget.list[i]['file_name'],
                    style: TextStyle(fontSize: 17, color: Colors.blue)),
                trailing: Wrap(
                  children: [
                    IconButton(
                      color: Colors.red,
                      icon: Icon(Icons.file_download),
                      onPressed: () {
                        loadfile(context, widget.list[i]['file_name'],
                            widget.team_name);
                      },
                    ),
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
