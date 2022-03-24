import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:letsmeet/navigation_home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:letsmeet/ipconn.dart';
import 'package:flutter/material.dart';
import 'package:letsmeet/screens/booking/checkinvite.dart';
import 'package:letsmeet/screens/booking/invite.dart';
import 'package:letsmeet/sendmail/sendmail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBookingScreen extends StatefulWidget {
  final List list;
  final int index;
  final team_id;
  const AddBookingScreen({this.list, this.index, this.team_id});

  @override
  _AddBookingScreenState createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  TextEditingController Roomname = TextEditingController();
  TextEditingController Roomsize = TextEditingController();
  TextEditingController Roomprice = TextEditingController();
  TextEditingController Roomdetail = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String username = "";
  String team_id = null;
  Object sizeV = null;
  void validate() {
    if (formkey.currentState.validate()) {
      print('validate');
    } else {
      print('Not validate');
    }
  }

  DateTime now = DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
  String start = DateFormat('HH:mm').format(DateTime.now());
  String end =
      DateFormat('HH:mm').format(DateTime.now().add(const Duration(hours: 1)));
  //List Dateroom = [];
  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
    });
  }

  Future get() async {
    if (widget.team_id != null) {
      setState(() {
        team_id = widget.team_id;

        print('' + team_id);
      });
    }
  }

  bool Loading = true;

  /*Future getAvailableTime() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/room/getAvailableTime.php?room_id=${widget.list[widget.index]['room_id']}"));
    var data = json.decode(response.body);
    setState(() {
      Dateroom = data;
      Loading = false;
    });
    checkAvailableTime();
    return json.decode(response.body);
  }*/

  DateTime bookdate = DateTime.now();
  Future uploadRoom() async {
    DateTime bookingin = DateTime.now();
    DateTime bookingout = DateTime.now();
    DateTime getstart = DateFormat('HH:mm').parse(start);
    DateTime getend = DateFormat('HH:mm').parse(end);
    bookingin = DateTime(bookdate.year, bookdate.month, bookdate.day,
        getstart.hour, getstart.minute);
    bookingout = DateTime(bookdate.year, bookdate.month, bookdate.day,
        getend.hour, getend.minute);
    /*if (sizeV == 1) {
      bookingin = DateTime(bookdate.year, bookdate.month, bookdate.day, 9);
      //bookdate.add(const Duration(hours: 9));
      bookingout = DateTime(bookdate.year, bookdate.month, bookdate.day, 11);
    } else if (sizeV == 2) {
      bookingin = DateTime(bookdate.year, bookdate.month, bookdate.day, 13);
      bookingout = DateTime(bookdate.year, bookdate.month, bookdate.day, 15);
    } else if (sizeV == 3) {
      bookingin = DateTime(bookdate.year, bookdate.month, bookdate.day, 16);
      bookingout = DateTime(bookdate.year, bookdate.month, bookdate.day, 18);
    } else if (sizeV == 4) {
      bookingin = DateTime(bookdate.year, bookdate.month, bookdate.day, 19);
      bookingout = DateTime(bookdate.year, bookdate.month, bookdate.day, 21);
    }*/

    //DateTime stday = new DateFormat('dd/MM/yyyy').parse(startday);
    String st = DateFormat('yyyy-MM-dd HH:mm:ss').format(bookingin).toString();

    //DateTime enday = new DateFormat('dd/MM/yyyy').parse(endday);
    String en = DateFormat('yyyy-MM-dd HH:mm:ss').format(bookingout).toString();

    final uri = Uri.parse("http://${ipconn}/letsmeet/booking/bookingadd.php");
    var request = await http.post(
      uri,
      body: {
        'team_id': team_id.toString(),
        'room_id': widget.list[widget.index]['room_id'],
        'user_id': username,
        'bookingin': st,
        'bookingout': en
      },
    );
    print(request.body);
    if (json.decode(request.body) == "Error") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  "Someone have booked in this time, Please change your time for booking"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("ok"))
              ],
            );
          });
    } else if (json.decode(request.body) == "timeout") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Sorry, The limit of booking is not more than 23:59"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("ok"))
              ],
            );
          });
    } else {
      final response2 = await http.get(Uri.parse(
          "http://${ipconn}/letsmeet/profile/profile.php?user_id=${username}"));
      var data2 = json.decode(response2.body);
      sendmail().sendmailer(
          name: data2[0]['firstname'],
          email: data2[0]['email'],
          subject: "Booking meeting room",
          body:
              "${data2[0]['firstname']} ${data2[0]['lastname']} have booking the meeting room ${widget.list[widget.index]['name']} in ${DateFormat('dd MMMM yyy').format(DateTime(bookdate.year, bookdate.month, bookdate.day))} at ${DateFormat('HH:mm').format(bookingin).toString()} - ${DateFormat('HH:mm').format(bookingout).toString()}");
      var data = json.decode(request.body);
      print(data);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return InvitePage(
          list: data,
          index: 0,
        );
      }));
    }

    /*Navigator.push(context,
        MaterialPageRoute(builder: (context) => NavigationHomeScreen()));*/
  }

  List<DateTime> getdate = [];
  /*Future checkAvailableTime() async {
    getdate = [];
    sizeV = null;
    for (int i = 0; i < Dateroom.length; i++) {
      DateTime get =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(Dateroom[i]["datein"]);
      print(get);
      getdate.add(get);
      setState(() {});
      print(getdate.toString());
    }
  }*/

  @override
  void initState() {
    getEmail();
    Roomname = TextEditingController(text: widget.list[widget.index]['name']);
    Roomsize = TextEditingController(text: widget.list[widget.index]['size']);
    //getAvailableTime();
    get();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFDCADA3),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFDCADA3), Color(0xFFE5EAF3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Booking",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Container(
                  child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            readOnly: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter the room name";
                              } else {
                                return null;
                              }
                            },
                            controller: Roomname,
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
                              prefixText: 'Room name : ',
                              prefixStyle:
                                  TextStyle(fontSize: 20, color: Colors.black),
                              //labelText: 'Room name : ',
                              //labelStyle: TextStyle(color: Colors.black87),
                            ),
                            // controller: password,
                          ),
                          /*TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "กรุณากรอก ราคาห้อง ของท่าน";
                              } else {
                                return null;
                              }
                            },
                            controller: Roomprice,
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
                              prefixText: 'Room price : ',
                              prefixStyle:
                                  TextStyle(fontSize: 20, color: Colors.black),
                              labelText: 'Room price : ',
                              labelStyle: TextStyle(color: Colors.black87),
                            ),
                            // controller: password,
                          ),*/
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.blue,
                            child: Row(
                              children: [
                                Container(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: Column(
                                      children: [
                                        IconButton(
                                            iconSize: 50,
                                            onPressed: () {},
                                            icon: Icon(Icons.ac_unit)),
                                        Container(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.black),
                                            /*borderRadius:
                                                  BorderRadius.circular(30)*/
                                          ),
                                          child: Center(
                                            child: Text(
                                              widget.list[widget.index]['size'],
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                Container(
                                  //height: 150,
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  color: Colors.amber,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 10, 10),
                                    child: Center(
                                      child: Container(
                                        height: 150,
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Text("  From  "),
                                            DateTimePicker(
                                              type: DateTimePickerType.time,
                                              dateMask: 'HH:mm',
                                              initialValue: start,
                                              firstDate: DateTime.now(),
                                              //lastDate: DateTime(2100),
                                              //icon: Icon(Icons.event),
                                              //dateLabelText: 'Date',
                                              //timeLabelText: "Hour",
                                              /*selectableDayPredicate: (date) {
                                                // Disable weekend days to select from the calendar
                                                if (date.weekday == 6 ||
                                                    date.weekday == 7) {
                                                  return false;
                                                }

                                                return true;
                                              },*/
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
                                            Text("  To  "),
                                            DateTimePicker(
                                              type: DateTimePickerType.time,
                                              dateMask: 'HH:mm',
                                              initialValue: end,
                                              firstDate: DateTime.now(),
                                              //lastDate: DateTime(2100),
                                              // icon: Icon(Icons.event),
                                              // dateLabelText: 'Date',
                                              // timeLabelText: "Hour",
                                              /*selectableDayPredicate: (date) {
                                                // Disable weekend days to select from the calendar
                                                if (date.weekday == 6 ||
                                                    date.weekday == 7) {
                                                  return false;
                                                }

                                                return true;
                                              },*/
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
                                          ],
                                        ),
                                      ),
                                    ),
                                    /*child: Loading
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : ListView(
                                            children: [
                                              Container(
                                                color: Colors.red,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.33,
                                                child: Row(
                                                  children: [
                                                    Radio(
                                                        value: 1,
                                                        groupValue: sizeV,
                                                        onChanged: (v) {
                                                          if (getdate.contains(
                                                              DateTime(
                                                                  bookdate.year,
                                                                  bookdate
                                                                      .month,
                                                                  bookdate.day,
                                                                  9))) {
                                                            print('yes');
                                                          } else {
                                                            sizeV = v;
                                                            setState(() {});
                                                            print(sizeV);
                                                          }
                                                        }),
                                                    getdate.contains(DateTime(
                                                            bookdate.year,
                                                            bookdate.month,
                                                            bookdate.day,
                                                            9))
                                                        ? Text(
                                                            "9:00 - 11:00",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          )
                                                        : Text(
                                                            "9:00 - 11:00",
                                                          ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                color: Colors.red,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.33,
                                                child: Row(
                                                  children: [
                                                    Radio(
                                                        value: 2,
                                                        groupValue: sizeV,
                                                        onChanged: (v) {
                                                          if (getdate.contains(
                                                              DateTime(
                                                                  bookdate.year,
                                                                  bookdate
                                                                      .month,
                                                                  bookdate.day,
                                                                  13))) {
                                                            print('yes');
                                                          } else {
                                                            sizeV = v;
                                                            setState(() {});
                                                            print(sizeV);
                                                          }
                                                        }),
                                                    getdate.contains(DateTime(
                                                            bookdate.year,
                                                            bookdate.month,
                                                            bookdate.day,
                                                            13))
                                                        ? Text(
                                                            "13:00 - 15:00",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          )
                                                        : Text(
                                                            "13:00 - 15:00",
                                                          ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                color: Colors.red,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.33,
                                                child: Row(
                                                  children: [
                                                    Radio(
                                                        value: 3,
                                                        groupValue: sizeV,
                                                        onChanged: (v) {
                                                          if (getdate.contains(
                                                              DateTime(
                                                                  bookdate.year,
                                                                  bookdate
                                                                      .month,
                                                                  bookdate.day,
                                                                  16))) {
                                                            print('yes');
                                                          } else {
                                                            sizeV = v;
                                                            setState(() {});
                                                            print(sizeV);
                                                          }
                                                        }),
                                                    getdate.contains(DateTime(
                                                            bookdate.year,
                                                            bookdate.month,
                                                            bookdate.day,
                                                            16))
                                                        ? Text(
                                                            "16:00 - 18:00",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          )
                                                        : Text(
                                                            "16:00 - 18:00",
                                                          ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                color: Colors.red,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.33,
                                                child: Row(
                                                  children: [
                                                    Radio(
                                                        value: 4,
                                                        groupValue: sizeV,
                                                        onChanged: (v) {
                                                          if (getdate.contains(
                                                              DateTime(
                                                                  bookdate.year,
                                                                  bookdate
                                                                      .month,
                                                                  bookdate.day,
                                                                  19))) {
                                                            print('yes');
                                                          } else {
                                                            sizeV = v;
                                                            setState(() {});
                                                            print(sizeV);
                                                          }
                                                        }),
                                                    getdate.contains(DateTime(
                                                            bookdate.year,
                                                            bookdate.month,
                                                            bookdate.day,
                                                            19))
                                                        ? Text(
                                                            "19:00 - 21:00",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          )
                                                        : Text(
                                                            "19:00 - 21:00",
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),*/
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black)),
                            child: CalendarDatePicker(
                                initialDate:
                                    DateTime(now.year, now.month, now.day),
                                firstDate:
                                    DateTime(now.year, now.month, now.day),
                                lastDate: DateTime(
                                    now.year + 9999, now.month, now.day),
                                onDateChanged: (v) {
                                  bookdate = v;
                                  setState(() {});
                                  print(bookdate);
                                  //checkAvailableTime();
                                }),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (Roomname.text == '') {
                                  validate();
                                } /*else if (sizeV == '' || sizeV == null) {
                                  validate();
                                }*/
                                /* else if (DateFormat == '' || sizeV == null) {
                                }*/
                                else {
                                  uploadRoom();
                                }
                                //uploadRoom();
                              },
                              child: Text('Book Meeting')),
                        ],
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
