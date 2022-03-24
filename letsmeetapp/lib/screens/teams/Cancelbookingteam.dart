import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';


class Cancelbookingteam extends StatefulWidget {
  final team_id;
  final team_name;
  const Cancelbookingteam({Key key, this.team_id , this.team_name}) : super(key: key);

  @override
  _CancelbookingteamState createState() => _CancelbookingteamState();
}

class _CancelbookingteamState extends State<Cancelbookingteam> {
  String username = "";
  Future<List> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
    });
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/teams/getmetshowdelete.php?user_id=${username}&team_id=${widget.team_id}"));
    return json.decode(response.body);
  }

  @override
  void initState() {
    getData();
    //checkinvite().getuserinvite(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: 
           Text(
            'Team : '+'  '+widget.team_name,
            style: GoogleFonts.playfairDisplay(
                color: Colors.black, fontSize: 25.6, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Color(0xFFCFD7ED),
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFCFD7ED), Color(0xFFE8D9E6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new showcancelbooklist(list: snapshot.data)
                : new Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}

class showcancelbooklist extends StatefulWidget {
  final list;
  final i;
  showcancelbooklist({this.list, this.i});

  @override
  _showcancelbooklistState createState() => _showcancelbooklistState();
}

class _showcancelbooklistState extends State<showcancelbooklist> {
  void daleteData(String meeting_id) {
    print(meeting_id);
    var url = "http://${ipconn}/letsmeet/booking/bookingcancal.php";
    http.post(Uri.parse(url), body: {'meeting_id': meeting_id});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: widget.list.length,
          itemBuilder: (context, i) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
                child: Material(
                  elevation: 8,
                  child: ListTile(
                    title: Column(
                      children: [
                        Text('Room : '+'  '+widget.list[i]['name']),
                        Text("From ${widget.list[i]['datein']}"),
                        Text("To ${widget.list[i]['dateout']}"),
                      ],
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    "Do you need to cancal meeting at ${widget.list[i]['name']} ?"),
                                content: Text(
                                    "in ${widget.list[i]['datein']} - ${widget.list[i]['dateout']} "),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      daleteData(widget.list[i]['reserve_id']);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Ok"),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.green),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Text("cancel"),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
