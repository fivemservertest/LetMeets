import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import '../../ipconn.dart';

class CarendarTeam extends StatefulWidget {
  String team_id;
  CarendarTeam(String team_id) {
    this.team_id = team_id;
  }

  @override
  _CarendarTeamHomeState createState() =>
      _CarendarTeamHomeState(team_id);
}

class _CarendarTeamHomeState extends State<CarendarTeam> {
  String team_id;

  _CarendarTeamHomeState(String team_id) {
    this.team_id = team_id;
  }

  Future<List> getData() async {
    // print('teamddddd'+team_id);
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/room/getroomcarendarteam.php?team_id=${team_id}"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: getData(),
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
    // print(list);
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Container(
            color: Colors.red,
            height: MediaQuery.of(context).size.height * 0.7,
            child: SfCalendar(
              // timeZone: 'th',
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
        subject: 'Room : '+ '  '+list[i]['name'],
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
