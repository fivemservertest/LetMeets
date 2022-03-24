import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letsmeet/screens/booking/checkinvite.dart';
import '../../navigation_team_screen.dart';
import 'components/body.dart';
import 'components/body_detail.dart';

class team_detail extends StatefulWidget {
  final teamname;

  const team_detail({Key key, this.teamname}) : super(key: key);

  @override
  _team_detailState createState() => _team_detailState();
}

class _team_detailState extends State<team_detail> {
  String team_name = "";
  void initState() {
    //checkinvite().getuserinvite(context);
    getname();
    print("team :" + widget.teamname);
    super.initState();
  }

  void getname() async {
    setState(() {
      team_name = widget.teamname;
    });
  }

  @override
  Widget build(BuildContext context) {
    //checkinvite().getuserinvite(context);
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0xFFDCADA3),
      //   elevation: 0,
      //   automaticallyImplyLeading: true,
      // ),
       appBar: AppBar(
        title: Text(""),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.arrow_turn_down_left),
         onPressed: () {
            Navigator.pop(context);
            
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFDCADA3),
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
          child: HomeDetail(teamname: team_name)),
    );
  }
}
