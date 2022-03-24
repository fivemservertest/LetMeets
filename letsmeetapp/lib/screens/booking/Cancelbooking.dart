import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'detailroom.dart';

class Cancelbooking extends StatefulWidget {
  final List list;
  final int index;
  const Cancelbooking({Key key, this.list, this.index}) : super(key: key);

  @override
  _CancelbookingState createState() => _CancelbookingState();
}

class _CancelbookingState extends State<Cancelbooking> {
  String username;
  String status;

  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
      status = preferences.getString('status');
    });
  }

  Future<List> getData() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/booking/getbookingmeet.php?room_id=${widget.list[widget.index]['room_id']}"));
    return json.decode(response.body);
  }

  Future<List> getData1() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/booking/getbookingmeetuser.php?room_id=${widget.list[widget.index]['room_id']}&user_id=${username}"));
    return json.decode(response.body);
  }

  Future<List> getData2() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/booking/getbookingmeetmanager.php?room_id=${widget.list[widget.index]['room_id']}&user_id=${username}"));
    return json.decode(response.body);
  }

  @override
  void initState() {
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list[widget.index]['name']),
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
        child: FutureBuilder(
          future: status == "Participant"
              ? getData1()
              : status == "Managers"
                  ? getData2()
                  : getData(),
          builder: (context, data) {
            if (data.hasError) {
              print(data.error);
            }
            return data.hasData
                ? showcancelbooklist(
                    list: data.data,
                    roomlist: widget.list,
                    roomindex: widget.index,
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}

class showcancelbooklist extends StatefulWidget {
  final List list;
  final List roomlist;
  final int roomindex;
  const showcancelbooklist({Key key, this.list, this.roomlist, this.roomindex})
      : super(key: key);

  @override
  _showcancelbooklistState createState() => _showcancelbooklistState();
}

class _showcancelbooklistState extends State<showcancelbooklist> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: widget.list.length,
          itemBuilder: (context, index) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
                child: Material(
                  elevation: 8,
                  child: ListTile(
                    title: Column(
                      children: [
                        Text(widget.roomlist[widget.roomindex]['name']),
                        Text("From ${widget.list[index]['datein']}"),
                        Text("To ${widget.list[index]['dateout']}"),
                      ],
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => detailroom(
                                list: widget.list[index],
                                host: widget.list[index]['user_id'],
                                reserve_id: widget.list[index]['reserve_id'])));
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
