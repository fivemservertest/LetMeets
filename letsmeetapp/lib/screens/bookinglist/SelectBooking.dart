import 'package:flutter/material.dart';
import 'package:letsmeet/screens/bookinglist/BookingListScreen.dart';
import 'package:letsmeet/screens/bookinglist/PassedMeeting.dart';

class SelectBooking extends StatefulWidget {
  @override
  _SelectBookingState createState() => _SelectBookingState();
}

class _SelectBookingState extends State<SelectBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFCFD7ED),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFCFD7ED), Color(0xFFE8D9E6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return BookingListScreen();
                  }));
                },
                child: Text(
                  "Upcoming Meeting",
                  style: TextStyle(fontSize: 30),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return PassedMeeting();
                  }));
                },
                child: Text(
                  "Past Meeting",
                  style: TextStyle(fontSize: 30),
                ))
          ],
        ),
      ),
    );
  }
}
