// import 'package:flutter/material.dart';
// import 'package:letsmeet/screens/advancesearch/roomserach.dart';
// import 'package:letsmeet/src/widgets/Room.dart';
// import '../../navigation_home_screen.dart';

// class result extends StatefulWidget {
//   final seat;
//   final st;
//   final en;
//   final bool data1;
//   final bool data2;
//   final bool data3;
//   final bool data4;
//   final bool data5;

//   result(
//       {this.seat,
//       this.en,
//       this.st,
//       this.data1,
//       this.data2,
//       this.data3,
//       this.data4,
//       this.data5});

//   @override
//   _resultState createState() => _resultState();
// }

// class _resultState extends State<result> {
//   TextEditingController seat = TextEditingController();
//   TextEditingController Searchfield = TextEditingController();
//   TextEditingController timein = TextEditingController();
//   TextEditingController timeout = TextEditingController();
//   bool data1 = false;
//   bool data2 = false;
//   bool data3 = false;
//   bool data4 = false;
//   bool data5 = false;






//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFFCFD7ED),
//         elevation: 0,
//         centerTitle: true,
//         title: Padding(
//           padding: const EdgeInsets.only(top: 10),
//           child: new Text("Search Result"),
//         ),
//         automaticallyImplyLeading: true,
//         // actions: [
//         //   IconButton(
//         //       padding: EdgeInsets.only(
//         //         right: 20,
//         //       ),
//         //       onPressed: () {
//         //         Navigator.push(
//         //             context,
//         //             MaterialPageRoute(
//         //                 builder: (context) => NavigationHomeScreen()));
//         //       },
//         //       icon: Icon(Icons.home, color: Colors.white)) //note_add
//         // ],
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//               colors: [Color(0xFFCFD7ED), Color(0xFFE8D9E6)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//                 height: MediaQuery.of(context).size.height * 0.7,
//                 child: Roomresult(
//                     data1: data1,
//                     data2: data2,
//                     data3: data3,
//                     data4: data4,
//                     data5: data5)),

//             // ElevatedButton(
//             //     // onPressed: () {
//             //     //   Navigator.of(context)
//             //     //       .push(MaterialPageRoute(builder: (context) {
//             //     //     return advance();
//             //     //   }));
//             //     // },
//             //     child: Text(
//             //       "Search",
//             //       style: TextStyle(fontSize: 20),
//             //     )),
//           ],
//         ),
//       ),
//     );
//   }






  
// }
