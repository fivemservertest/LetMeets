import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'Detailmeet.dart';

class Seemore extends StatefulWidget {
  final team_id;
  final team_name;
  const Seemore({Key key, this.team_id, this.team_name}) : super(key: key);

  @override
  _SeemoreState createState() => _SeemoreState();
}

class _SeemoreState extends State<Seemore> {
  String username = "";
  String team_name = "";
  Future<List> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
    });
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/teams/getmetshowdelete.php?team_id=${widget.team_id}"));
    return json.decode(response.body);
  }

  Future getnameteam() async {
    final response2 = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/teams/getteamname.php?team_id=${widget.team_id}"));
    var data2 = json.decode(response2.body);
    setState(() {
      team_name = data2[0]['team_name'];
    });
  }

  @override
  void initState() {
    getData();
    getnameteam();
    if (widget.team_name != "" || widget.team_name != null) {
      team_name = widget.team_name;
    }
    //checkinvite().getuserinvite(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Team: ' + ' ' + team_name,
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
                ? new showcancelbooklist(
                    list: snapshot.data, team_name: team_name)
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
  final team_name;
  showcancelbooklist({this.list, this.i, this.team_name});

  @override
  _showcancelbooklistState createState() => _showcancelbooklistState();
}

class _showcancelbooklistState extends State<showcancelbooklist> {
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
                        Text('Room :' + '  ' + widget.list[i]['name']),
                        Text("From ${widget.list[i]['datein']}"),
                        Text("To ${widget.list[i]['dateout']}"),
                      ],
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => detailmeet(
                                team_name: widget.team_name,
                                list: widget.list[i],
                                host: widget.list[i]['user_id'],
                                reserve_id: widget.list[i]['reserve_id'])));
                      },
                      child: Text("Seemore"),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
