import 'package:letsmeet/checksum/checksum.dart';
import 'package:letsmeet/screens/addroom.dart';
import 'package:letsmeet/screens/bookinglist/BookingListHistory.dart';
import 'package:letsmeet/screens/bookinglist/BookingListScreen.dart';
import 'package:letsmeet/screens/bookinglist/SelectBooking.dart';
import 'package:letsmeet/screens/bookinglist/invitelist.dart';
import 'package:letsmeet/screens/mainscreen/HomeScreen.dart';
import 'package:letsmeet/screens/profile/profile_screen.dart';
import 'package:letsmeet/screens/teams/components/body.dart';
import 'package:letsmeet/screens/team_participant/components/body_part_t.dart';
import 'app_theme.dart';
import 'package:letsmeet/screens/verify/verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:letsmeet/screens/bookinglist/Bookinghistory.dart';
import 'checksum/checksumtest.dart';
import 'custom_drawer/drawer_user_controller.dart';
import 'custom_drawer/home_drawer.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;

  String username = "";

  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
    });
  }

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = HomeScreenT();
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = HomeScreenT();
        });
      } else if (drawerIndex == DrawerIndex.Add) {
        setState(() {
          screenView = AddroomScreen();
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        // print(username);
        setState(() {
          screenView = SelectBooking();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = ProfileScreen();
        });
      } else if (drawerIndex == DrawerIndex.Teams) {
        setState(() {
          screenView = BodyTeam();
        });
      } else if (drawerIndex == DrawerIndex.Teamsforp) {
        setState(() {
          screenView = BodyTeam();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = InviteList();
        });
      } else if (drawerIndex == DrawerIndex.History) {
        setState(() {
          screenView = his();
        });
      } else if (drawerIndex == DrawerIndex.About) {
        setState(() {
          screenView = Time1();
        });
      } else if (drawerIndex == DrawerIndex.Verify) {
        setState(() {
          screenView = VerifyScreen();
        });
      } else {
        //do in your way......
      }
    }
  }
}
