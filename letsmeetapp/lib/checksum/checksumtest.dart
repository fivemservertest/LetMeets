import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letsmeet/checksum/checksum.dart';

class Time1 extends StatefulWidget {
  @override
  _Time1State createState() => _Time1State();
}

class _Time1State extends State<Time1> with SingleTickerProviderStateMixin {
  bool pickerIsExpanded = false;
  int _pickerYear = DateTime.now().year;
  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  dynamic _pickerOpen = false;

  void switchPicker() {
    setState(() {
      _pickerOpen ^= true;
    });
  }

  List<Widget> generateRowOfMonths(from, to) {
    List<Widget> months = [];
    for (int i = from; i <= to; i++) {
      DateTime dateTime = DateTime(_pickerYear, i, 1);
      final backgroundColor = dateTime.isAtSameMomentAs(_selectedMonth)
          ? Theme.of(context).backgroundColor
          : Color(0xFFCFD7ED);
      months.add(
        AnimatedSwitcher(
          duration: kThemeChangeDuration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: TextButton(
            key: ValueKey(backgroundColor),
            onPressed: () {
              setState(() {
                _selectedMonth = dateTime;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: CircleBorder(),
            ),
            child: Text(DateFormat('MMM').format(dateTime),
                style: TextStyle(color: Colors.black)),
          ),
        ),
      );
    }
    return months;
  }

  List<Widget> generateMonths() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(1, 6),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(7, 12),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // var datefo = DateFormat('yyyy-MM-dd').parse(widget.list['datein']);
    String datemeet = DateFormat.yMMMM().format(_selectedMonth);
    print(datemeet);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: new Text("Meeting Summary"),
        ),
        backgroundColor: Color(0xFFCFD7ED),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Theme.of(context).cardColor,
            child: AnimatedSize(
              curve: Curves.easeInOut,
              vsync: this,
              duration: Duration(milliseconds: 300),
              child: Container(
                height: _pickerOpen ? null : 0.0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _pickerYear = _pickerYear - 1;
                            });
                          },
                          icon: Icon(Icons.navigate_before_rounded),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              _pickerYear.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _pickerYear = _pickerYear + 1;
                            });
                          },
                          icon: Icon(Icons.navigate_next_rounded),
                        ),
                      ],
                    ),
                    ...generateMonths(),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: switchPicker,
            label: Text(
              datemeet.toString(),
              style: TextStyle(color: Colors.black),
            ),
            icon: const Icon(Icons.date_range, color: Colors.black),
            style: ElevatedButton.styleFrom(
                primary: Colors.grey[200],
                padding:
                    const EdgeInsets.symmetric(horizontal: 120, vertical: 10),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: checksum(search: datemeet)),
        ],
      ),
    );
  }
}
