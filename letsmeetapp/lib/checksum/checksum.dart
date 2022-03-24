// ignore_for_file: missing_return, unused_import, camel_case_types

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:letsmeet/checksum/seemore.dart';
import 'package:letsmeet/checksum/seemore2.dart';
import 'package:letsmeet/ipconn.dart';
import 'dart:async';

class checksum extends StatefulWidget {
  final String search;
  const checksum({Key key, this.search}) : super(key: key);
  @override
  _checksumState createState() => _checksumState();
}

class _checksumState extends State<checksum> {
  @override
  void initState() {
    print(widget.search);
    //checkinvite().getuserinvite(context);
    super.initState();
  }

  Future<List> getData2() async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/checksum/getroom.php?search=${widget.search}"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List>(
      future: getData2(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? Roomlist(
                list: snapshot.data,
                search: widget.search,
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    ));
  }
}

class Roomlist extends StatefulWidget {
  final List list;
  final search;
  const Roomlist({Key key, this.list, this.search}) : super(key: key);
  @override
  _RoomlistState createState() => _RoomlistState();
}

class _RoomlistState extends State<Roomlist> {
  Future<int> getData(String roomid, String search) async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/checksum/bookingcount.php?room_id=${roomid}&search=${search}"));

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: ListView.builder(
          itemCount: widget.list.length,
          itemBuilder: (context, i) {
            return Container(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    //height: 500,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Room size : ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              widget.list[i]['size'],
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        FutureBuilder<int>(
                            future: getData(
                                widget.list[i]['room_id'], widget.search),
                            builder: (context, data) {
                              if (data.hasError) {
                                print(data.error);
                              }
                              return data.hasData
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'booking count :' +
                                              data.data.toString(),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.blue.shade800)),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          seemorecahrt(
                                                            
                                                            room_id:
                                                                widget.list[i]
                                                                    ['room_id'],
                                                            name: widget.list[i]
                                                                ['name'],
                                                            size: widget.list[i]
                                                                ['size'],
                                                          )));
                                            },
                                            child: Text("View graph")),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder:
                                                      (BuildContext context) {
                                                return SeeMore2(
                  
                                                  room_id: widget.list[i]
                                                      ['room_id'],
                                                  name: widget.list[i]['name'],
                                                  datein: widget.list[i]['datein'],
                                                 
                                                );
                                              }));
                                            },
                                            child: Text("See more")),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          'booking count : ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        CircularProgressIndicator(),
                                      ],
                                    );
                            }),

                        // FutureBuilder<int>(
                        //     future: getsumData(widget.list[i]['room_id']),
                        //     builder: (context, data) {
                        //       if (data.hasError) {
                        //         print(data.error);
                        //       }
                        //       //print(data.data);
                        //       return data.hasData
                        //           ? Row(
                        //               children: [
                        //                 Text("Meeting member count : "),
                        //                 Text(data.data.toString()),
                        //               ],
                        //             )
                        //           : Row(
                        //               children: [
                        //                 Text("Meeting member count : "),
                        //                 CircularProgressIndicator(),
                        //               ],
                        //             );
                        //     })
                      ],
                    ),
                  ),
                  Positioned(
                      left: 17,
                      top: -5,
                      child: Container(
                        padding: EdgeInsets.all(5),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        //color: Colors.red,
                        child: Row(
                          children: [
                            Text(
                              'Room : ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              widget.list[i]['name'],
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            );
          }),
    );
  }
}
