import 'package:letsmeet/navigation_home_screen.dart';
import 'package:letsmeet/screens/loginscreen/login.dart';
import 'package:letsmeet/screens/verify/verify_screen.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:flutter/material.dart';
import 'package:letsmeet/screens/verify/components/reject_coment.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:letsmeet/navigation_verify_screen.dart';

class verify_detail extends StatefulWidget {
  final List list;
  final int index;
  const verify_detail({Key key, this.list, this.index}) : super(key: key);

  @override
  _verify_detailState createState() => _verify_detailState();
}

class _verify_detailState extends State<verify_detail> {
  TextEditingController firstname = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController department = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future verify() async {
    String verify = "verify";
    String user_id = widget.list[widget.index]['user_id'];
    final uri = Uri.parse("http://${ipconn}/letsmeet/verify/verify.php");
    var request = http.MultipartRequest('POST', uri);

    request.fields['user_id'] = user_id;
    request.fields['check'] = verify;

    var response = await request.send();

    if (response.statusCode == 200) {
      print(user_id);
      print(verify);
      // print('Image Uploaded');

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NavigationVerifyScreen()));
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.success, text: "Verify successfully"));
    } else {
      print('Error');
      print(response.statusCode);
    }
    setState(() {});
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
    department =
        TextEditingController(text: widget.list[widget.index]['department']);
    email = TextEditingController(text: widget.list[widget.index]['email']);
    age = TextEditingController(text: widget.list[widget.index]['age']);

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
                        Container(
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(width: 4, color: Colors.white),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    'http://$ipconn/letsmeet/login_logout/upload/${widget.list[widget.index]['image']}'),
                              ),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          readOnly: true,
                          controller: username,
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
                          readOnly: true,
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
                          readOnly: true,
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
                          readOnly: true,
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
                          readOnly: true,
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
                        ), //ชื่อนามสกุล
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          readOnly: true,
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
                          readOnly: true,
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
                Center(
                    child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      onPressed: () => {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Are you Sure'),
                            content: const Text(
                                'Please review the information carefully before verify confirmation.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('back'),
                              ),
                              TextButton(
                                onPressed: () => {verify()},
                                child: const Text('Confirm verify'),
                              ),
                            ],
                          ),
                        ),
                      },
                      color: Colors.green,
                      child: Text(
                        'Verify',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => reject_comment(
                                    user_id: widget.list[widget.index]
                                        ['user_id'])));
                      },
                      color: Colors.red,
                      child: Text(
                        'Reject',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )),
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
