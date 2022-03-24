import 'dart:convert';
import 'dart:ui';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/booking/checkmeet.dart';
import 'package:letsmeet/screens/mainscreen/HomeScreen.dart';
import 'package:letsmeet/src/widgets/Participants.dart';
import 'package:letsmeet/screens/teams/teams_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/screens/teams/addm_screen.dart';
import 'package:letsmeet/navigation_team_screen.dart';
import 'BookingListHistory.dart';
import 'package:date_time_picker/date_time_picker.dart';

class his extends StatefulWidget {
  @override
  _hisState createState() => _hisState();
}

class _hisState extends State<his> {
  final _pageController = PageController(viewportFraction: 0.877);

  TextEditingController Searchfield = TextEditingController();
  String search = "";
  bool isChecked = false;
  String _valueChanged = '';
  String _valueToValidate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: new Text("Meeting History"),
        backgroundColor: Color(0xFFCFD7ED),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFCFD7ED), Color(0xFFE5EAF3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: PageView(
            children: [
              Column(
                children: [
                  // custom Navigation Drawer and Search Button
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 150, right: 150),
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        dateMask: 'dd/MM/yyyy',
                        controller: Searchfield,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                        calendarTitle: 'Select:day/month/year',
                        dateLabelText: 'Select:day/month/year',
                        validator: (val) {
                          setState(() => _valueToValidate = val ?? '');
                          return null;
                        },
                        onChanged: (v) {
                          setState(() {
                            search = v;
                            print(search);
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: BookingListHistory(search: search)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
