import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import '../ipconn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarendarPageMyAppHome extends StatefulWidget {
  String id_roomsrg;
  CarendarPageMyAppHome(String id_roomsrg) {
    this.id_roomsrg = id_roomsrg;
  }

  @override
  _CarendarPageMyAppHomeHomeState createState() =>
      _CarendarPageMyAppHomeHomeState(id_roomsrg);
}

class _CarendarPageMyAppHomeHomeState extends State<CarendarPageMyAppHome> {
  String id_roomsrg;

  _CarendarPageMyAppHomeHomeState(String id_roomsrg) {
    this.id_roomsrg = id_roomsrg;
  }
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
    //print(id_roomsrg);
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/room/getroomcarendar.php?room_id=${id_roomsrg}"));
    return json.decode(response.body);
  }

  Future<List> getData1() async {
    //print(id_roomsrg);
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/room/getroomcarendauser.php?room_id=${id_roomsrg}&user_id=${username}"));
    return json.decode(response.body);
  }

  Future<List> getData2() async {
    //print(id_roomsrg);
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/room/getroomcarendamanager.php?room_id=${id_roomsrg}&user_id=${username}"));
    return json.decode(response.body);
  }

  @override
  void initState() {
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: status == "Participant"
          ? getData1()
          : status == "Managers"
              ? getData2()
              : getData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? CarendarPage(
                list: snapshot.data,
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}

class CarendarPage extends StatelessWidget {
  final List list;
  CarendarPage({this.list});

  @override
  Widget build(BuildContext context) {
    print(list);
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Container(
            color: Colors.red,
            height: MediaQuery.of(context).size.height * 0.7,
            child: SfCalendar(
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
        resourceIds: [list[i]],
        startTime: inputDatein,
        endTime: inputDateout,
        subject: list[i]['firstname'],
        color: Color(0xFFFF0000),
        startTimeZone: '',
        endTimeZone: '',
      ));
    }
    return AppointmentDataSource(appointments);
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
