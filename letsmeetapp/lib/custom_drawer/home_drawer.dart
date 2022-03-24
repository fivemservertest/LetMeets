import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:letsmeet/screens/loginscreen/login.dart';
import 'package:letsmeet/src/widgets/username.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../app_theme.dart';

class HomeDrawer extends StatefulWidget {
  final List list;

  HomeDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex,
      this.list})
      : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  List<DrawerList> drawerListManagers;
  List<DrawerList> drawerListAdmin;
  List<DrawerList> drawerListnologin;

  String username = "";
  String permission = "";
  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
    });
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/profile/profile.php?user_id=${username}"));

    var data = json.decode(response.body);
    setState(() {
      permission = data[0]['permission'];
    });
  }

  @override
  void initState() {
    getEmail();
    setDrawerListArrayadmin();
    setDrawerListArray();
    setDrawerListArrayManagers();
    setDrawerListArrayNoLogin();
    super.initState();
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: 'Meeting List',
        icon: Icon(Icons.list),
      ),
      DrawerList(
        index: DrawerIndex.FeedBack,
        labelName: 'Profile',
        icon: Icon(Icons.person_rounded),
      ),
      DrawerList(
        index: DrawerIndex.History,
        labelName: 'Meeting History',
        icon: Icon(Icons.av_timer),
      ),
      DrawerList(
        index: DrawerIndex.Invite,
        labelName: 'Invitation List',
        icon: Icon(Icons.ac_unit),
      ),
      DrawerList(
        index: DrawerIndex.Teams,
        labelName: 'Teams',
        icon: Icon(Icons.supervisor_account_rounded),
      ),
    ];
  }

  void setDrawerListArrayManagers() {
    drawerListManagers = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: 'Meeting List',
        icon: Icon(Icons.list),
      ),
      DrawerList(
        index: DrawerIndex.FeedBack,
        labelName: 'Profile',
        icon: Icon(Icons.person_rounded),
      ),
      DrawerList(
        index: DrawerIndex.History,
        labelName: 'Meeting History',
        icon: Icon(Icons.av_timer),
      ),
      DrawerList(
        index: DrawerIndex.Teams,
        labelName: 'Teams',
        icon: Icon(Icons.supervisor_account_rounded),
      ),
    ];
  }

  void setDrawerListArrayadmin() {
    drawerListAdmin = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Add,
        labelName: 'Add Room',
        icon: Icon(Icons.add_business),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: 'Meeting List',
        icon: Icon(Icons.list),
      ),
      DrawerList(
        index: DrawerIndex.FeedBack,
        labelName: 'Profile',
        icon: Icon(Icons.person_rounded),
      ),
      DrawerList(
        index: DrawerIndex.History,
        labelName: 'Meeting History',
        icon: Icon(Icons.av_timer),
      ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: 'Meeting Summary',
        icon: Icon(Icons.av_timer),
      ),
      DrawerList(
        index: DrawerIndex.Verify,
        labelName: 'Verify account',
        icon: Icon(Icons.av_timer),
      ),
    ];
  }

  void setDrawerListArrayNoLogin() {
    drawerListnologin = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: Icon(Icons.home),
      ),
      /*DrawerList(
        index: DrawerIndex.Promotion,
        labelName: 'โปรโมชั่น',
        icon: Icon(Icons.person_rounded),
      ),*/
    ];
  }

  Future<Null> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          username == null
              ? SizedBox(
                  height: 60,
                )
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        /*AnimatedBuilder(
                          animation: widget.iconAnimationController,
                          builder: (BuildContext context, Widget child) {
                            return ScaleTransition(
                              scale: AlwaysStoppedAnimation<double>(1.0 -
                                  (widget.iconAnimationController.value) * 0.2),
                              child: RotationTransition(
                                  turns: AlwaysStoppedAnimation<double>(
                                      Tween<double>(begin: 0.0, end: 24.0)
                                              .animate(CurvedAnimation(
                                                  parent: widget
                                                      .iconAnimationController,
                                                  curve: Curves.fastOutSlowIn))
                                              .value /
                                          360),
                                  child: HomeAvatar()),
                            );
                          },
                        ),*/
                        Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: HomeUsername()),
                      ],
                    ),
                  ),
                ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          username == null
              ? Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(0.0),
                    itemCount: drawerListnologin.length,
                    itemBuilder: (BuildContext context, int index) {
                      return inkwell(drawerListnologin[index]);
                    },
                  ),
                )
              : permission == "Admin"
                  ? Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(0.0),
                        itemCount: drawerListAdmin.length,
                        itemBuilder: (BuildContext context, int index) {
                          return inkwell(drawerListAdmin[index]);
                        },
                      ),
                    )
                  : permission == "Managers"
                      ? Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(0.0),
                            itemCount: drawerListManagers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return inkwell(drawerListManagers[index]);
                            },
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(0.0),
                            itemCount: drawerList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return inkwell(drawerList[index]);
                            },
                          ),
                        ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              username == null
                  ? ListTile(
                      title: Text(
                        'Login',
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppTheme.darkText,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      trailing: Icon(
                        Icons.power_settings_new,
                        color: Colors.green,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                    )
                  : ListTile(
                      title: Text(
                        'Sign Out',
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppTheme.darkText,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      // trailing: Icon(
                      //   Icons.power_settings_new,
                      //   color: Colors.red,
                      // ),
                      onTap: () {
                        logout();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                    ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  void onTapped() {
    print('Doing Something...'); // Print to console.
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? Colors.blue
                                  : AppTheme.nearlyBlack),
                        )
                      : Icon(listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? Colors.blue
                              : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  FeedBack,
  Add,
  Help,
  Share,
  About,
  Invite,
  Invitelist,
  History,
  Testing,
  Teams,
  Teamsforp,
  Verify
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
