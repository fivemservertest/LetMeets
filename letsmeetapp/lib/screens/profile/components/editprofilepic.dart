import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../../../app_theme.dart';
import '../../../ipconn.dart';
import '../../../main.dart';

class editprofilepic extends StatefulWidget {
  List list;
  int index;
  editprofilepic({this.index, this.list});

  @override
  _editprofilepicState createState() => _editprofilepicState();
}

class _editprofilepicState extends State<editprofilepic> {
  File _image;

  /*Future getImage(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    setState(() {
      _image = File(image.path);
    });
  }*/

  Future editPic(String id) async {
    final uri =
        Uri.parse("http://${ipconn}/hotelpro/profile/updateProfilePic.php");
    var request = http.MultipartRequest('POST', uri);
    var pic = await http.MultipartFile.fromPath("image", _image.path);
    request.files.add(pic);
    request.fields['id'] = id;
    request.fields['user_type'] = widget.list[0]['user_type'];
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image Uploded');
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    } else {
      print('Image Not Uploded');
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.nearlyWhite,
        appBar: new AppBar(
          backgroundColor: Color(0xFFCFD7ED),
          title: new Text("Edit profile picture"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              //ProfilePic(),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _image == null
                        ? Center(
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: AppTheme.grey.withOpacity(0.6),
                                      offset: const Offset(4.0, 8.0),
                                      blurRadius: 8),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100.0)),
                                child: widget.list[0]['user_type'] == "user"
                                    ? Image.network(
                                        'http://${ipconn}/hotelpro/upload/user/${widget.list[0]['user_pic']}')
                                    : Image.network(
                                        'http://${ipconn}/hotelpro/upload/admin/${widget.list[0]['user_pic']}'),
                              ),
                            ),
                          )
                        /*Icon(
                        Icons.photo,
                        color: Colors.blueAccent,
                        size: 300,
                      ),*/

                        : Center(
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: AppTheme.grey.withOpacity(0.6),
                                      offset: const Offset(4.0, 8.0),
                                      blurRadius: 8),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100.0)),
                                child: Image.file(_image),
                              ),
                            ),
                          ),
                    SizedBox(height: 20),
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          // getImage(ImgSource.Gallery);
                        },
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        color: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'Uploading',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          editPic(widget.list[widget.index]['user_id']);
                        },
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        color: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
