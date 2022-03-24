import 'dart:convert';
import 'dart:io';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:letsmeet/navigation_home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:flutter/material.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class AddroomScreen extends StatefulWidget {
  const AddroomScreen({Key key}) : super(key: key);

  @override
  _AddroomScreenState createState() => _AddroomScreenState();
}

class _AddroomScreenState extends State<AddroomScreen> {
  TextEditingController detail = TextEditingController();
  TextEditingController Roomname = TextEditingController();
  TextEditingController Roomprice = TextEditingController();
  TextEditingController Sizeroom = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Object sizeV = null;
  void validate() {
    if (formkey.currentState.validate()) {
      print('validate');
    } else {
      print('Not validate');
    }
  }

  File _image;
  bool _boardandChalk = false;
  bool _ProjectorScreen = false;
  bool _Podium = false;
  bool _MicrophoneSpeaker = false;
  bool _Computer = false;

  Future getImage(ImgSource source) async {
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
  }

  Future uploadRoom() async {
    final uri = Uri.parse("http://${ipconn}/letsmeet/room/roomadd.php");
    var request = http.MultipartRequest('POST', uri);
    var pic = await http.MultipartFile.fromPath("image", _image.path);
    request.files.add(pic);
    request.fields['Roomname'] = Roomname.text;
    request.fields['detail'] = detail.text;
    request.fields['Roomsize'] = Sizeroom.text;
    request.fields['Roomprice'] = Roomprice.text;
    request.fields['whiteboardandchalk'] = _boardandChalk.toString();
    request.fields['projectorandscreen'] = _ProjectorScreen.toString();
    request.fields['podium'] = _Podium.toString();
    request.fields['microphoneandspeaker'] = _MicrophoneSpeaker.toString();
    request.fields['computer'] = _Computer.toString();
    var response = await request.send();
    var resp = await http.Response.fromStream(response);
    var data = json.decode(resp.body);

    if (data == "dup room") {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger,
            title: "Duplicated name",
          ));
    } else if (data == "wanning") {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger,
            title: "Please select facilities",
          ));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFDCADA3),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: 1000,
        height: 1000,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFDCADA3), Color(0xFFE5EAF3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Add Room",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Container(
                  child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter the room name";
                              } else {
                                return null;
                              }
                            },
                            controller: Roomname,
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(fontSize: 20.0),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(
                                left: 10.0,
                                bottom: 10.0,
                                top: 10.0,
                                right: 10,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorStyle: TextStyle(fontSize: 15),
                              hintStyle: TextStyle(fontSize: 20),
                              prefixText: 'Room name : ',
                              prefixStyle:
                                  TextStyle(fontSize: 20, color: Colors.black),
                              labelText: 'Room name : ',
                              labelStyle: TextStyle(color: Colors.black87),
                            ),
                            // controller: password,
                          ),
                          /*TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "กรุณากรอก ราคาห้อง ของท่าน";
                              } else {
                                return null;
                              }
                            },
                            controller: Roomprice,
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(fontSize: 20.0),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(
                                left: 10.0,
                                bottom: 10.0,
                                top: 10.0,
                                right: 10,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorStyle: TextStyle(fontSize: 15),
                              hintStyle: TextStyle(fontSize: 20),
                              prefixText: 'Room price : ',
                              prefixStyle:
                                  TextStyle(fontSize: 20, color: Colors.black),
                              labelText: 'Room price : ',
                              labelStyle: TextStyle(color: Colors.black87),
                            ),
                            // controller: password,
                          ),*/
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.blue,
                            child: Row(
                              children: [
                                _image == null || _image == ""
                                    ? Container(
                                        height: 150,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: IconButton(
                                            iconSize: 150,
                                            onPressed: () {
                                              getImage(ImgSource.Gallery);
                                            },
                                            icon: Icon(Icons.account_circle)))
                                    : Container(
                                        height: 150,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Image.file(
                                          _image,
                                          fit: BoxFit.fill,
                                        )),
                                Container(
                                  height: 150,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  color: Colors.amber,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 10, 10, 10),
                                    child: Container(
                                      color: Colors.white,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: Sizeroom,
                                        onChanged: (v) {
                                          /*setState(() {
                          search = v;
                        });*/
                                        },
                                        decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 32.0,
                                                    vertical: 14.0),
                                            hintText: "Total seats",
                                            border: InputBorder.none
                                            // prefixIcon: Icon(Icons.search),
                                            ),
                                      ),
                                    ),
                                    /*ListView(
                                      children: [
                                        Container(
                                          color: Colors.red,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.33,
                                          child: Row(
                                            children: [
                                              Radio(
                                                  value: 1,
                                                  groupValue: sizeV,
                                                  onChanged: (v) {
                                                    sizeV = v;
                                                    setState(() {});
                                                    print(sizeV);
                                                  }),
                                              Text(
                                                "10",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          color: Colors.red,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.33,
                                          child: Row(
                                            children: [
                                              Radio(
                                                  value: 2,
                                                  groupValue: sizeV,
                                                  onChanged: (v) {
                                                    sizeV = v;
                                                    setState(() {});
                                                    print(sizeV);
                                                  }),
                                              Text(
                                                "20",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          color: Colors.red,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.33,
                                          child: Row(
                                            children: [
                                              Radio(
                                                  value: 3,
                                                  groupValue: sizeV,
                                                  onChanged: (v) {
                                                    sizeV = v;
                                                    setState(() {});
                                                    print(sizeV);
                                                  }),
                                              Text(
                                                "30",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          color: Colors.red,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.33,
                                          child: Row(
                                            children: [
                                              Radio(
                                                  value: 4,
                                                  groupValue: sizeV,
                                                  onChanged: (v) {
                                                    sizeV = v;
                                                    setState(() {});
                                                    print(sizeV);
                                                  }),
                                              Text(
                                                "50+",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),*/
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                              height: 230,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black)),
                              child: ListView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        'Facilities',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  CheckboxListTile(
                                      title: Text("Whiteboard and Chalk"),
                                      value: _boardandChalk,
                                      onChanged: (bool valor) {
                                        setState(() {
                                          _boardandChalk = valor;
                                        });
                                      }),
                                  CheckboxListTile(
                                      title: Text("Projector and Screen"),
                                      value: _ProjectorScreen,
                                      onChanged: (bool valor) {
                                        setState(() {
                                          _ProjectorScreen = valor;
                                        });
                                      }),
                                  CheckboxListTile(
                                      title: Text("Podium"),
                                      value: _Podium,
                                      onChanged: (bool valor) {
                                        setState(() {
                                          _Podium = valor;
                                        });
                                      }),
                                  CheckboxListTile(
                                      title: Text("Microphone and Speaker"),
                                      value: _MicrophoneSpeaker,
                                      onChanged: (bool valor) {
                                        setState(() {
                                          _MicrophoneSpeaker = valor;
                                        });
                                      }),
                                  CheckboxListTile(
                                      title: Text("Computer"),
                                      value: _Computer,
                                      onChanged: (bool valor) {
                                        setState(() {
                                          _Computer = valor;
                                        });
                                      }),
                                  //               RaisedButton(
                                  // child: Text(
                                  //   "Salvar",
                                  //   style: TextStyle(fontSize: 20),
                                  // ),
                                  // onPressed: () {
                                  //   print("Comida Brasileira: " +
                                  //       _comidaBrasileira.toString() +
                                  //       " Comida Mexicana " +
                                  //       _comidaMexicana.toString()+
                                  //       " Comida Mexicana1 " +
                                  //       _comidaMexicana1.toString()+
                                  //       " Comida Mexicana2 " +
                                  //       _comidaMexicana2.toString()+
                                  //       " Comida Mexicana3 " +
                                  //       _comidaMexicana3.toString());
                                  // })
                                ],
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter the room name";
                              } else {
                                return null;
                              }
                            },
                            controller: detail,
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(fontSize: 20.0),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(
                                left: 10.0,
                                bottom: 10.0,
                                top: 10.0,
                                right: 10,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorStyle: TextStyle(fontSize: 15),
                              hintStyle: TextStyle(fontSize: 20),
                              prefixText: 'Description :',
                              prefixStyle:
                                  TextStyle(fontSize: 20, color: Colors.black),
                              labelText: 'Description : ',
                              labelStyle: TextStyle(color: Colors.black87),
                            ),
                            // controller: password,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (Roomname.text == '') {
                                  validate();
                                } else if (_image == null) {
                                  ArtSweetAlert.show(
                                      context: context,
                                      artDialogArgs: ArtDialogArgs(
                                        type: ArtSweetAlertType.danger,
                                        title: "Please insert Picture",
                                      ));
                                } else if (Sizeroom.text == '' ||
                                    Sizeroom.text == null) {
                                  ArtSweetAlert.show(
                                      context: context,
                                      artDialogArgs: ArtDialogArgs(
                                        type: ArtSweetAlertType.danger,
                                        title: "Please fill the information",
                                      ));
                                } else {
                                  uploadRoom();
                                }
                              },
                              child: Text('Add Room')),
                        ],
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
