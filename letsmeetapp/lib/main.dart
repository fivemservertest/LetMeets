import 'package:flutter/material.dart';
import 'package:letsmeet/navigation_home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'letsmeet',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NavigationHomeScreen());
  }
}
