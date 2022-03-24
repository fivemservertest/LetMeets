import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/sendmail/sendmail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class checkinvite {
  Future getuserinvite(BuildContext context) async {
    print("check");
    String _username = "";
    SharedPreferences preferences = await SharedPreferences.getInstance();

    _username = preferences.getString('username');
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/participant/getinvite.php?user_id=${_username}"));
    var data = json.decode(response.body);

    if (data != "Error") {
      final response2 = await http.get(Uri.parse(
          "http://${ipconn}/letsmeet/participant/getinviter.php?inmeeting_id=${data[0]['inmeeting_id']}"));
      var data2 = json.decode(response2.body);
      final response3 = await http.get(Uri.parse(
          "http://${ipconn}/letsmeet/participant/getinmeetcount.php?reserve_id=${data[0]['reserve_id']}"));
      var data3 = json.decode(response3.body);
      DateTime datein =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(data[0]['datein']);
      DateTime dateout =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(data[0]['dateout']);
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                child: Center(
                    child: AlertDialog(
                  title: Text("${data2[0]['inviter']} have invite you"),
                  content: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${data[0]['name']}"),
                        Text("${data3 + 1} Participants incall"),
                        Row(
                          children: [
                            Icon(Icons.access_alarm),
                            Text(
                                "${DateFormat('HH:mm').format(datein)} - ${DateFormat('HH:mm').format(dateout)}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          responseinvite(data[0]['inmeeting_id'], "1",
                              hostlist: data2, userlist: data);
                          Navigator.pop(context);
                        },
                        child: Text("Accept")),
                    ElevatedButton(
                        onPressed: () {
                          responseinvite(data[0]['inmeeting_id'], "2");
                          Navigator.pop(context);
                        },
                        child: Text("Decline")),
                  ],
                )),
              ),
            );
          });
    } else {}
  }

  Future<void> responseinvite(String id, String status,
      {List userlist, List hostlist}) async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/participant/responseinvite.php?id=${id}&response=${status}"));

    if (status == "1") {
      sendmail().sendmailer(
          name: hostlist[0]['inviter'],
          email: hostlist[0]['email'],
          subject:
              "${userlist[0]['firstname']} ${userlist[0]['lastname']} just accect your invite",
          body:
              "${userlist[0]['firstname']} ${userlist[0]['lastname']} just accect your invite");
    }
  }
}
