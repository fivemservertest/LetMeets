import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

class roomuploadfile extends StatefulWidget {
  final reser_id;
  final datein;
  final dateout;
  final room;
  const roomuploadfile(
      {Key key, this.reser_id, this.datein, this.dateout, this.room})
      : super(key: key);

  @override
  _roomuploadfileState createState() => _roomuploadfileState();
}

class _roomuploadfileState extends State<roomuploadfile> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String reser_id = "";
  void initState() {
    reser_id = widget.reser_id;
    super.initState();
  }

  Future<List> getdata() async {
    print("getdata :" + reser_id);
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/room/showfile.php?reser_id=${reser_id}"));

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
    final uri = Uri.parse("http://${ipconn}/letsmeet/room/uploadfile.php");
    var request = http.MultipartRequest('POST', uri);
    var fileup = await http.MultipartFile.fromPath("file", selectfile.path);
    print(selectfile);
    request.files.add(fileup);

    request.fields['reserve_id'] = reser_id;
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () => {upload()},
            tooltip: 'Add file',
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(widget.room,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                  letterSpacing: 0.1,
                                )),
                          ),
                            SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(widget.datein,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  letterSpacing: 0.1,
                                )),
                          ),
                          Center(
                            child: Text(widget.dateout,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  letterSpacing: 0.1,
                                )),
                          ),
                        ],
                      ),
                    ),
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
                                list: snapshot.data, reser_id: reser_id)
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
  final reser_id;
  Itemlist({this.list, this.reser_id});
  @override
  _ItemlistState createState() => _ItemlistState();
}

class _ItemlistState extends State<Itemlist> {
  loadfile(context, String file_name, reser_id) async {
    if (!await launch(
        'http://${ipconn}/letsmeet/room/upload/' + reser_id + '/' + file_name))
      throw 'file error';
    print(reser_id);
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: widget.list == null ? 0 : widget.list.length,
      itemBuilder: (context, i) {
        String file_name = widget.list[i]['room_file'];

        print("list :" + file_name);
        return Container(
          height: 80,
          child: Padding(
            padding: EdgeInsets.only(left: 10, bottom: 5, right: 10, top: 5),
            child: Card(
              child: ListTile(
                title: Text(widget.list[i]['room_file'],
                    style: TextStyle(fontSize: 17, color: Colors.blue)),
                trailing: Wrap(
                  children: [
                    IconButton(
                      color: Colors.red,
                      icon: Icon(Icons.file_download),
                      onPressed: () {
                        loadfile(context, widget.list[i]['room_file'],
                            widget.reser_id);
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
