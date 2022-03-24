import 'package:letsmeet/navigation_home_screen.dart';
import 'package:letsmeet/screens/loginscreen/login.dart';
import 'package:letsmeet/screens/verify/verify_screen.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:flutter/material.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:letsmeet/screens/verify/components/verify_detail.dart';
import 'package:letsmeet/navigation_verify_screen.dart';

class reject_comment extends StatefulWidget {
  final user_id;
  const reject_comment({Key key, this.user_id}) : super(key: key);

  @override
  _reject_commentState createState() => _reject_commentState();
}

class _reject_commentState extends State<reject_comment> {
  TextEditingController Comment = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  var user_id;

  Future reject() async {
    String reject = "reject";
    final uri = Uri.parse("http://${ipconn}/letsmeet/verify/verify.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = user_id;
    request.fields['check'] = reject;
    request.fields['comment'] = Comment.text;

    var response = await request.send();

    print('reject' + user_id);
    print('reject' + Comment.text);

    if (response.statusCode == 200) {
      print(user_id);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NavigationVerifyScreen()));
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.success, text: "Reject successfully"));
      // Navigator.of(context).restorablePush(_dialogBuilder);
    } else {
      print('Error');
      print(response.statusCode);
    }
    setState(() {});
  }

  @override
  void initState() {
    user_id = widget.user_id;
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reason to reject :',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        TextFormField(
                          controller: Comment,
                          minLines:
                              6, // any number you need (It works as the rows for the textarea)
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: new InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Comment',
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(25.7),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
                ),
                Center(
                    child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NavigationVerifyScreen()),
                        )
                      },
                      color: Colors.white,
                      child: Text(
                        'Back',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      onPressed: () => {reject()},
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
