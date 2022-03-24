import 'dart:convert';
import 'dart:io';
import 'package:letsmeet/navigation_home_screen.dart';
import 'package:letsmeet/screens/loginscreen/login.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:flutter/material.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:letsmeet/navigation_profile_screen.dart';

class EditData extends StatefulWidget {
  final List list;
  final int index;
  const EditData({Key key, this.list, this.index}) : super(key: key);

  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  TextEditingController firstname = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController department = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String _valueChanged = '';
  String _valueToValidate = '';

  File _images = null;

  void validate() {
    if (formkey.currentState.validate()) {
      print('validate');
    } else {
      print('Not validate');
    }
  }

  void Getimage(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      cameraIcon: Icon(Icons.add),
    );
    setState(() {
      _images = File(image.path);
    });
  }

  @override
  void initState() {
    firstname =
        TextEditingController(text: widget.list[widget.index]['firstname']);
    surname =
        TextEditingController(text: widget.list[widget.index]['lastname']);
    username =
        TextEditingController(text: widget.list[widget.index]['username']);
    password =
        TextEditingController(text: widget.list[widget.index]['password']);
    email = TextEditingController(text: widget.list[widget.index]['email']);
    age = TextEditingController(text: widget.list[widget.index]['age']);

    super.initState();
  }

  Future uploadImage() async {
    final uri =
        Uri.parse("http://${ipconn}/letsmeet/profile/updateprofile.php");
    var request = http.MultipartRequest('POST', uri);

    if (_images != null) {
      var pic = await http.MultipartFile.fromPath("image", _images.path);
      request.files.add(pic);
      request.fields['email'] = email.text;
      request.fields['firstname'] = firstname.text;
      request.fields['surname'] = surname.text;
      request.fields['username'] = username.text;
      request.fields['password'] = password.text;
      request.fields['age'] = age.text;
      request.fields['department'] = department.text;
      request.fields['user_id'] = widget.list[widget.index]['user_id'];
      var response = await request.send();
      if (response.statusCode == 200) {
        print('edit Uploaded');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NavigationProfileScreen()));
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success, text: "Edit successfully"));
      }
    } else {
      request.fields['email'] = email.text;
      request.fields['firstname'] = firstname.text;
      request.fields['surname'] = surname.text;
      request.fields['username'] = username.text;
      request.fields['password'] = password.text;
      request.fields['age'] = age.text;
      request.fields['department'] = department.text;
      request.fields['user_id'] = widget.list[widget.index]['user_id'];
      var response = await request.send();
      if (response.statusCode == 200) {
        print('edit Uploaded');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NavigationProfileScreen()));
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success, text: "Edit successfully"));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFDCADA3),
        elevation: 0,
        automaticallyImplyLeading: true,
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
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(8),
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child:
                              new Stack(fit: StackFit.loose, children: <Widget>[
                            _images == null
                                ? Container(
                                    width: 170,
                                    height: 170,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4, color: Colors.white),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            color:
                                                Colors.black.withOpacity(0.1))
                                      ],
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            'http://$ipconn/letsmeet/login_logout/upload/${widget.list[widget.index]['image']}'),
                                      ),
                                    ),
                                  )
                                : Container(
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: FileImage(_images),
                                    ),
                                    width: 170,
                                    height: 170,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4,
                                      ),
                                      color: Colors.orange[600]),
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    iconSize: 25,
                                    icon: Icon(Icons.edit),
                                    color: Colors.white,
                                    onPressed: () {
                                      Getimage(ImgSource.Gallery);
                                    },
                                  ),
                                )),
                          ]),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your username";
                            } else {
                              return null;
                            }
                          },
                          controller: username,
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
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.black87),
                          ),
                          // controller: password,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your password";
                            } else {
                              return null;
                            }
                          },
                          controller: password,
                          obscureText: true,
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
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black87),
                          ),
                          // controller: password,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your name";
                            } else {
                              return null;
                            }
                          },
                          controller: firstname,
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
                            labelText: 'Name',
                            labelStyle: TextStyle(color: Colors.black87),
                          ),
                          // controller: password,
                        ), //ชื่อนามสกุล
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your surname";
                            } else {
                              return null;
                            }
                          },
                          controller: surname,
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
                            labelText: 'Surname',
                            labelStyle: TextStyle(color: Colors.black87),
                          ),
                          // controller: password,
                        ), //ชื่อนามสกุล
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your department";
                            } else {
                              return null;
                            }
                          },
                          controller: department,
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
                            labelText: 'Department',
                            labelStyle: TextStyle(color: Colors.black87),
                          ),
                          // controller: password,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your age";
                            } else {
                              return null;
                            }
                          },
                          controller: age,
                          keyboardType: TextInputType.number,
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
                            labelText: 'Age',
                            labelStyle: TextStyle(color: Colors.black87),
                          ),
                          // controller: password,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your email";
                            } else {
                              return null;
                            }
                          },
                          controller: email,
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
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.black87),
                          ),
                          // controller: password,
                        ), //อีเมล
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (firstname.text == '') {
                      validate();
                    } else if (username.text == '') {
                      validate();
                    } else if (password.text == '') {
                      validate();
                    } else if (surname.text == '') {
                      validate();
                    } else if (email.text == '') {
                      validate();
                    } else {
                      uploadImage();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    // width: MediaQuery.of(context).size.width,
                    width: 250,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xFFF3D3D3),
                          Color(0xFFF3D3D3)
                        ]),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text("Confirm", style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
