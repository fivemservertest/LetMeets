import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/carendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PassedMeeting extends StatefulWidget {
  @override
  _PassedMeetingState createState() => _PassedMeetingState();
}

class _PassedMeetingState extends State<PassedMeeting> {
  String username = "";
  String permission = "";
  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
    });
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/profile/profile.php?user_id=${username}"));
    var data = json.decode(response.body);
    setState(() {
      permission = data[0]['permission'];
    });
  }

  Future<List> getData() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/booking/getbookingpass.php?user_id=${username}"));
    return json.decode(response.body);
  }

  Future<List> getData2() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/booking/getbookingpassparticipant.php?user_id=${username}"));
    return json.decode(response.body);
  }

  /*
  Future<List> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
    });
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/booking/getbookingpass.php?user_id=${username}"));
    return json.decode(response.body);
  }*/
  @override
  void initState() {
    getEmail();
    //checkinvite().getuserinvite(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFCFD7ED),
        automaticallyImplyLeading: true,
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
        child: permission == "Participant"
            ? FutureBuilder<List>(
                future: getData2(),
                builder: (context, data) {
                  if (data.hasError) {
                    print(data.error);
                  }
                  //print(data.data);
                  return data.hasData
                      ? CarendarPage(
                          list: data.data,
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              )
            : FutureBuilder<List>(
                future: getData(),
                builder: (context, data) {
                  if (data.hasError) {
                    print(data.error);
                  }
                  //print(data.data);
                  return data.hasData
                      ? CarendarPage(
                          list: data.data,
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

class CarendarPage extends StatelessWidget {
  final List list;
  CarendarPage({this.list});

  @override
  Widget build(BuildContext context) {
    //print(list);
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Container(
            color: Colors.red,
            height: MediaQuery.of(context).size.height * 0.7,
            child: SfCalendar(
              maxDate: DateTime.now(),
              //timeZone: 'th',
              headerHeight: 40,
              view: CalendarView.month,
              dataSource: getCalendarDataSource(),

              //viewHeaderHeight: 2,
              monthViewSettings: const MonthViewSettings(
                agendaViewHeight: 200,
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                showAgenda: true,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  AppointmentDataSource getCalendarDataSource() {
    int daysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inHours / 24).round();
    }

    List<Appointment> appointments = <Appointment>[];
    var inputFormat = DateFormat('yyyy-MM-dd');
    /*appointments.add(Appointment(
      startTime: inputDate2,
      endTime: inputDate3,
      subject: 'วันที่เลือกไว้',
      color: Colors.green,
      startTimeZone: '',
      endTimeZone: '',
    ));*/

    for (int i = 0; i < list.length; i++) {
      var inputFormat = DateFormat('yyyy-MM-dd hh:mm');
      var inputDatein =
          inputFormat.parse('${list[i]['datein']}'); // <-- Incoming date
      var inputDateout = inputFormat.parse('${list[i]['dateout']}');
      appointments.add(Appointment(
        //recurrenceId: 1,
        resourceIds: [],
        startTime: inputDatein,
        endTime: inputDateout,
        subject: list[i]['name'],
        color: Color(0xFFFF0000),
        startTimeZone: '',
        endTimeZone: '',
      ));
    }
    return AppointmentDataSource(appointments);
  }
}
