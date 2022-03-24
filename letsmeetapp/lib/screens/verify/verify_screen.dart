import 'package:flutter/material.dart';
import 'package:letsmeet/screens/booking/checkinvite.dart';
import 'components/body.dart';
import 'package:letsmeet/navigation_home_screen.dart';

class VerifyScreen extends StatelessWidget {
  static String routeName = "/verify";

  @override
  Widget build(BuildContext context) {
    //checkinvite().getuserinvite(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify account"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFCFD7ED),
        elevation: 0,
      
      ),
      body: Container(
          width: 1000,
          height: 1000,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFCFD7ED), Color(0xFFE8D9E6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: HomeBody()),
    );
  }
}
