import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suit_up/models/calendar_item.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage();

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  _CalendarPageState();

  final _weekHeaders = List.unmodifiable(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]);
  final int _numWeekDays = 7;
  final _calendarItems = <CalendarItem>[];
  DateTime _dateTime = DateTime.now();
  int _numItems = 0;
  int _beginMonthPadding = 0;

  @override
  void initState() {
    final firstDayOfMonth = DateTime(_dateTime.year, _dateTime.month, 1);
    _beginMonthPadding = firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;
    final previousMonth =
        _dateTime.month == 1 ? DateTime(_dateTime.year - 1, 12) : DateTime(_dateTime.year, _dateTime.month - 1);
    final numDaysOfPrevMonth = getDaysOfMonth(previousMonth);

    for (int i = numDaysOfPrevMonth - _beginMonthPadding + 1; i <= numDaysOfPrevMonth; i++) {
      _calendarItems.add(CalendarItem(DateTime(previousMonth.year, previousMonth.month, i), i, ""));
    }
    _numItems = getDaysOfMonth(_dateTime);
    print("XXX  ${_calendarItems.length}");

    for (int i = 1; i <= _numItems; i++) {
      if (i == 11) {
        _calendarItems.add(CalendarItem(DateTime(_dateTime.year, _dateTime.month, i), i, "res/images/dress_3.jpg"));
      } else
        _calendarItems.add(CalendarItem(DateTime(_dateTime.year, _dateTime.month, i), i, ""));
    }
    super.initState();
  }

  int getDaysOfMonth(DateTime day) {
    return day.month == 12
        ? DateTime(day.year + 1, 1)
        : DateTime(day.year, day.month + 1).difference(DateTime(day.year, day.month)).inDays;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print("VVV ${_numItems}");

    Widget _buildRow(int index) {
      return Center(
        child: index < 7
            ? Text(
                _weekHeaders[index],
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              )
            : Card(
//                shape: RoundedRectangleBorder(
//                    side: BorderSide(color: Colors.black12),
//                    borderRadius: BorderRadius.all(
//                      Radius.circular(8.0),
//                    )),
                elevation: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Colors.white70,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            _calendarItems[index - 7].day.toString(),
                            style: TextStyle(
                              color:
                                  _calendarItems[index - 7].date.month != _dateTime.month ? Colors.grey : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      _calendarItems[index - 7].imageUrl.isNotEmpty
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                Icons.done,
                                size: 24,
                                color: Colors.black,
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: GridView.builder(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
          itemCount: _weekHeaders.length + _calendarItems.length,
          itemBuilder: (BuildContext context, int i) {
            return _buildRow(i);
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _numWeekDays),
        )
        // Card(
//          child: Row(
//            children: <Widget>[
//            IconButton(
//                icon: Icon(
//                  Icons.chevron_left,
//                  color: Colors.white,
//                ),
//                onPressed: () {}),
//            IconButton(
//                icon: Icon(
//                  Icons.chevron_right,
//                  color: Colors.white,
//                ),
//                onPressed: () {}),
        //   ],
        //  ),
        //     )

        );
  }
}
