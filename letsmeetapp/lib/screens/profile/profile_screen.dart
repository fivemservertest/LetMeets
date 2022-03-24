import 'package:flutter/material.dart';
import 'package:letsmeet/screens/booking/checkinvite.dart';
import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  @override
  Widget build(BuildContext context) {
    //checkinvite().getuserinvite(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
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
