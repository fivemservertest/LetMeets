import 'package:letsmeet/screens/loginscreen/login.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'dart:convert';

class SigupScreen extends StatefulWidget {
  const SigupScreen({Key key}) : super(key: key);

  @override
  _SigupScreenState createState() => _SigupScreenState();
}

class _SigupScreenState extends State<SigupScreen> {
  TextEditingController firstname = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController department = TextEditingController();

  String ValuespermissionType;
  List listpermissionType = ['Managers', 'Participant'];
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void validate() {
    if (formkey.currentState.validate()) {
      print('validate');
    } else {
      print('Not validate');
    }
  }

  final picker = ImagePicker();
  File _selectImageFile;

  void getImage() async {
    var selectfile = await picker.getImage(
        source: ImageSource.gallery, maxWidth: 1920, maxHeight: 1080);
    if (selectfile != null) {
      setState(() {
        _selectImageFile = File(selectfile.path);
      });
    }
  }

  Future uploadImage() async {
    final uri = Uri.parse("http://${ipconn}/letsmeet/login_logout/signup.php");
    var request = http.MultipartRequest('POST', uri);
    var pic = await http.MultipartFile.fromPath("image", _selectImageFile.path);

    request.files.add(pic);
    request.fields['email'] = email.text;
    request.fields['firstname'] = firstname.text;
    request.fields['surname'] = surname.text;
    request.fields['username'] = username.text;
    request.fields['password'] = password.text;
    request.fields['age'] = age.text;
    request.fields['permission'] = ValuespermissionType;
    request.fields['department'] = department.text;
    var response = await request.send();
    var resp = await http.Response.fromStream(response);
    var data = json.decode(resp.body);

    if (data == "addmember") {
      print('addmember');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.success, text: "Signup successfully"));
    } else {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              text:
                  "Sorry, This username is already in the system. Please change your Username."));
    }
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
        automaticallyImplyLeading: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                "Sign up",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    // width: MediaQuery.of(context).size.width,
                    width: 100,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xFFF3D3D3),
                          Color(0xFFF3D3D3)
                        ]),
                        borderRadius: BorderRadius.circular(30)),

                    child: Text("Login", style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    // width: MediaQuery.of(context).size.width,
                    width: 100,
                    padding: EdgeInsets.symmetric(vertical: 20),

                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xFFFfffff),
                          Color(0xFFFfffff)
                        ]),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text("Sign Up", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
            _selectImageFile != null
                ? IconButton(
                    icon: Image.file(
                      _selectImageFile,
                      height: 100,
                      width: 100,
                    ),
                    iconSize: 70,
                    onPressed: () {
                      getImage();
                    },
                  )
                : Padding(
                    padding: EdgeInsets.only(left: 15, top: 25),
                    child: IconButton(
                        padding: EdgeInsets.only(
                          right: 20,
                        ),
                        onPressed: () {
                          getImage();
                        },
                        icon: Icon(Icons.camera_alt, color: Colors.black,size: 50,)),
                  ),
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
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(15)),
                              child: DropdownButton(
                                hint: Text("Permission"),
                                dropdownColor: Colors.white,
                                isExpanded: true,
                                underline: SizedBox(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 22),
                                value: ValuespermissionType,
                                onChanged: (newValue) {
                                  setState(() {
                                    ValuespermissionType = newValue;
                                  });
                                },
                                items: listpermissionType.map((valueItem) {
                                  return DropdownMenuItem(
                                    value: valueItem,
                                    child: Text(valueItem),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
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
                    } else if (_selectImageFile == null) {
                      ArtSweetAlert.show(
                          context: context,
                          artDialogArgs: ArtDialogArgs(
                              type: ArtSweetAlertType.warning,
                              text: "Upload Images"));
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
                    child: Text("Sign Up", style: TextStyle(fontSize: 16)),
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
