import 'dart:convert';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/signupscreen/signup.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/navigation_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var username = preferences.getString('username');
  var password = preferences.getString('password');
  runApp(MaterialApp(
      home: username == null && password == null
          ? LoginScreen()
          : NavigationHomeScreen()));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void validate() {
    if (formkey.currentState.validate()) {
      print('validate');
    } else {
      print('Not validate');
    }
  }

  Future login() async {
    var url = "http://${ipconn}/letsmeet/login_logout/login.php";
    var response = await http.post(Uri.parse(url), body: {
      "username": username.text,
      "password": password.text,
    });
    var data = json.decode(response.body);

    if (data != "Error") {
      if (data[0]['verify_account'] == "1") {
        print('pass');
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('username', data[0]['user_id']);
        preferences.setString('fullname', data[0]['username']);
        preferences.setString('status', data[0]['permission']);
        

        // preferences.setString('username', data);
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationHomeScreen(),
            ),
          );
        });
      } else if (data[0]['verify_account'] == "2") {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.warning,
                title: "Rejected account",
                text: "Reason :" + data[0]['comment']));
      } else {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.warning,
                title: "Access Denied",
                text: "waiting for review"));
      }
    } else {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.warning,
              title: "Access Denied",
              text: "Please check your username and password"));
    }
  }

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFDCADA3),
        elevation: 0,
        automaticallyImplyLeading: true,
        /*actions: [
          IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavigationHomeScreen()));
              })
        ],*/
      ),
      body: ListView(
        children: [
          Container(
            width: 1000,
            height: 1000,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFDCADA3), Color(0xFFE5EAF3)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        child: Text("Login", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SigupScreen()));
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
                        child: Text("Sign Up", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
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
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                GestureDetector(
                  onTap: () {
                    validate();
                    login();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    // width: MediaQuery.of(context).size.width,
                    width: 250,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xFFFfffff),
                          Color(0xFFFfffff)
                        ]),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text("Sign In", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
