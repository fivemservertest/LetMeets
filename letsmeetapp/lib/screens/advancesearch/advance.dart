import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letsmeet/screens/advancesearch/Recommended.dart';
import 'package:letsmeet/screens/advancesearch/roomserach.dart';
import '../../navigation_home_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';

class advance extends StatefulWidget {
  @override
  _advanceState createState() => _advanceState();
}

class _advanceState extends State<advance> {
  TextEditingController seat = TextEditingController();
  // TextEditingController Searchfield = TextEditingController();
  TextEditingController timein = TextEditingController();
  TextEditingController timeout = TextEditingController();
  DateTime now = DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
  String start = DateFormat('HH:mm').format(DateTime.now());
  String end =
      DateFormat('HH:mm').format(DateTime.now().add(const Duration(hours: 1)));
  String seats = "";
  String _valueChanged = '';
  String _valueToValidate = '';
  bool data1 = false;
  bool data2 = false;
  bool data3 = false;
  bool data4 = false;
  bool data5 = false;

  DateTime bookdate = DateTime.now();
  Future uploadRoom() async {
    DateTime booking = DateTime.now();
    DateTime bookingin = DateTime.now();
    DateTime bookingout = DateTime.now();
    DateTime getstart = DateFormat('HH:mm').parse(start);
    DateTime getend = DateFormat('HH:mm').parse(end);
    bookingin = DateTime(bookdate.year, bookdate.month, bookdate.day,
        getstart.hour, getstart.minute);
    bookingout = DateTime(bookdate.year, bookdate.month, bookdate.day,
        getend.hour, getend.minute);

    String st = DateFormat('yyyy-MM-dd HH:mm:ss').format(bookingin).toString();
    String en = DateFormat('yyyy-MM-dd HH:mm:ss').format(bookingout).toString();
    String booking1 = DateFormat('yyyy-MM-dd').format(booking);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Roomresult(
                seat: seats,
                date: booking1,
                start: st,
                end: en,
                data1: data1,
                data2: data2,
                data3: data3,
                data4: data4,
                data5: data5)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFCFD7ED),
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: new Text("Advance Search"),
        ),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              padding: EdgeInsets.only(
                right: 20,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavigationHomeScreen()));
              },
              icon: Icon(Icons.home, color: Colors.white)) //note_add
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFCFD7ED), Color(0xFFE8D9E6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter your username";
                } else {
                  return null;
                }
              },
              controller: seat,
              onChanged: (v) {
                setState(() {
                  seats = v;
                });
              },
              keyboardType: TextInputType.visiblePassword,
              style: TextStyle(fontSize: 20.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.only(
                  left: 10.0,
                  bottom: 10.0,
                  top: 10.0,
                  right: 10,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorStyle: TextStyle(fontSize: 15),
                hintStyle: TextStyle(fontSize: 20),
                prefixText: 'Total Seat :',
                prefixStyle: TextStyle(fontSize: 20, color: Colors.black),
                labelText: 'Total Seat : ',
                labelStyle: TextStyle(color: Colors.black87),
              ),
              // controller: password,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 180,
              color: Colors.white,
              child: CalendarDatePicker(
                  initialDate: DateTime(now.year, now.month, now.day),
                  firstDate: DateTime(now.year, now.month, now.day),
                  lastDate: DateTime(now.year + 9999, now.month, now.day),
                  onDateChanged: (v) {
                    bookdate = v;
                    setState(() {});
                    print(bookdate);
                  }),
            ),
            Container(
              height: 150,
              color: Colors.white,
              child: Column(
                children: [
                  Text("  From  "),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: DateTimePicker(
                      type: DateTimePickerType.time,
                      dateMask: 'HH:mm',
                      initialValue: start,
                      firstDate: DateTime.now(),
                      onChanged: (val) {
                        print(val);
                        setState(() {
                          start = val;
                        });
                        print(start);
                      },
                      validator: (val) {
                        print(val);
                        return null;
                      },
                      onSaved: (val) => print(val),
                    ),
                  ),
                  Text("  To  "),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: DateTimePicker(
                      type: DateTimePickerType.time,
                      dateMask: 'HH:mm',
                      initialValue: end,
                      firstDate: DateTime.now(),
                      onChanged: (val) {
                        print(val);
                        setState(() {
                          end = val;
                        });
                        print(end);
                      },
                      validator: (val) {
                        print(val);
                        return null;
                      },
                      onSaved: (val) => print(val),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: 230,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black)),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Facilities',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                    CheckboxListTile(
                        value: data1,
                        title: Text("Whiteboard and Chalk"),
                        onChanged: (value) {
                          setState(() => this.data1 = value);
                          this.setState(() {});
                        }),
                    CheckboxListTile(
                      value: data2,
                      title: Text("Projector and Screen"),
                      onChanged: (value) {
                        setState(() {
                          data2 = value;
                          this.setState(() {});
                        });
                      },
                    ),
                    CheckboxListTile(
                      value: data3,
                      title: Text("Podium"),
                      onChanged: (value) {
                        setState(() {
                          data3 = value;
                          this.setState(() {});
                        });
                      },
                    ),
                    CheckboxListTile(
                      value: data4,
                      title: Text("Microphone and Speaker"),
                      onChanged: (value) {
                        setState(() {
                          data4 = value;
                          this.setState(() {});
                        });
                      },
                    ),
                    CheckboxListTile(
                      value: data5,
                      title: Text("Computer"),
                      onChanged: (value) {
                        setState(() {
                          data5 = value;
                          this.setState(() {});
                        });
                      },
                    ),
                  ],
                )),
            ElevatedButton(
                onPressed: () {
                  uploadRoom();
                },
                child: Text(
                  "Search",
                  style: TextStyle(fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }
}
