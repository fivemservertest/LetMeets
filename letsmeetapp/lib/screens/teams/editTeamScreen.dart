import 'package:letsmeet/navigation_home_screen.dart';
import 'package:letsmeet/screens/loginscreen/login.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:flutter/material.dart';
import 'package:letsmeet/screens/teams/team_detail.dart';
import 'package:letsmeet/screens/teams/components/body.dart';

class EditData extends StatefulWidget {
  final List list;
  final int index;
  const EditData({Key key, this.list, this.index}) : super(key: key);

  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  TextEditingController team_name = TextEditingController();
  TextEditingController team_description = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String oldteam_name = "";
  void validate() {
    if (formKey.currentState.validate()) {
      print('validate');
    } else {
      print('Not validate');
    }
  }

  @override
  void initState() {
    team_name =
        TextEditingController(text: widget.list[widget.index]['team_name']);
    team_description = TextEditingController(
        text: widget.list[widget.index]['team_description']);

    oldteam_name = widget.list[widget.index]['team_name'];
    super.initState();
  }

  Future delete() async {
    final uri = Uri.parse("http://${ipconn}/letsmeet/teams/deleteteam.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['team_name'] = oldteam_name;
    var response = await request.send();
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
      );
      print("Success");
    } else {
      print("empty");
    }
  }

  Future edit() async {
    final uri = Uri.parse("http://${ipconn}/letsmeet/teams/editteam.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['oldteam_name'] = oldteam_name;
    request.fields['newteam_name'] = team_name.text;
    request.fields['team_description'] = team_description.text;

    print("old :" + oldteam_name);
    print("new name :" + team_name.text);
    print("description : " + team_description.text);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
    // );

    var response = await request.send();

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
      );
      print("Success");
    } else {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeDetail()),
      // );
      print("empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("old" + oldteam_name);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Team'),
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
                          child: Text(oldteam_name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 2.2,
                          fontSize: 22,
                          color: Colors.black,
                          letterSpacing: 0.1,
                        )),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Text("Team name",
                                      style: TextStyle(
                                        height: 2.2,
                                        fontSize: 16,
                                        color: Colors.black.withOpacity(0.6),
                                        letterSpacing: 0.1,
                                      )),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 60, right: 60, top: 10, bottom: 10),
                            child: TextFormField(
                              controller: team_name,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Text("Team description",
                                      style: TextStyle(
                                        height: 2.2,
                                        fontSize: 16,
                                        color: Colors.black.withOpacity(0.6),
                                        letterSpacing: 0.1,
                                      )),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 60, right: 60, bottom: 10),
                            child: Card(
                                color: Colors.grey[200],
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: team_description,
                                    // maxLength: 1000,
                                    maxLines: 4,
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 60, right: 60, bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  height: 50,
                                  width: 120,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    // background
                                    textColor: Colors.blue, // foreground
                                    onPressed: () {
                                      delete();
                                    },
                                    child: Text('Delete'),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  height: 50,
                                  width: 120,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    // background
                                    textColor: Colors.blue, // foreground
                                    onPressed: () {
                                      if (team_name.text == '') {
                                        validate();
                                      } else {
                                        edit();
                                      }
                                    },
                                    child: Text('edit'),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
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
