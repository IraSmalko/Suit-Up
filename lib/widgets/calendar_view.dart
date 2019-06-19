import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:suit_up/models/calendar_item.dart';

class CalendarView extends StatefulWidget {
  final Function(double height) onHeightChanged;

  CalendarView({this.onHeightChanged});

  @override
  _CalendarViewState createState() => _CalendarViewState(onHeightChanged);
}

class _CalendarViewState extends State<CalendarView> {
  final List<String> _weekHeaders = List.unmodifiable(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]);
  final int _numWeekDays = 7;
  final _calendarItems = <CalendarItem>[];
  final Function(double height) onHeightChanged;
  final DateTime _today = DateTime.now();
  DateTime _dateTime = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateFormat _localeDate;
  double _headerHeight = 48;
  double _calendarViewHeight;
  String locale = "en";
  PageController _controller;
  double _currentPageValue = 0.0;

  _CalendarViewState(this.onHeightChanged);

  _addDaysOfPreviousMonth(List<CalendarItem> list) {
    final firstDayOfMonth = DateTime(_dateTime.year, _dateTime.month, 1);
    final beginMonthPadding = firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;
    final previousMonth = _previousMonth(_dateTime);
    final numDaysOfPrevMonth = _getDaysOfMonth(previousMonth);

    for (int i = numDaysOfPrevMonth - beginMonthPadding + 1; i <= numDaysOfPrevMonth; i++) {
      list.add(CalendarItem(DateTime(previousMonth.year, previousMonth.month, i), i, ""));
    }
  }

  _addDaysOfCurrentMonth(List<CalendarItem> list) {
    final _daysOfMonth = _getDaysOfMonth(_dateTime);
    for (int i = 1; i <= _daysOfMonth; i++) {
      if (i == 19) {
        list.add(CalendarItem(DateTime(_dateTime.year, _dateTime.month, i), i, "res/images/dress_3.jpg"));
      } else
        list.add(CalendarItem(DateTime(_dateTime.year, _dateTime.month, i), i, ""));
    }
  }

  _addDaysOfFutureMonth(List<CalendarItem> list) {
    final lastDayOfMonth = DateTime(_dateTime.year, _dateTime.month, _getDaysOfMonth(_dateTime));
    final endMonthPadding = lastDayOfMonth.weekday == 7 ? 0 : lastDayOfMonth.weekday;
    final futureMonth = _nextMonth(_dateTime);

    for (int i = 1; i <= 6 - endMonthPadding; i++) {
      list.add(CalendarItem(DateTime(futureMonth.year, futureMonth.month, i), i, ""));
    }
  }

  int _getDaysOfMonth(DateTime day) {
    return (day.month == 12
            ? DateTime(day.year + 1, 1).difference(DateTime(day.year, day.month)).inHours / 24
            : DateTime(day.year, day.month + 1, 1).difference(DateTime(day.year, day.month, 1)).inHours / 24)
        .round();
  }

  DateTime _nextMonth(DateTime dateTime) {
    return dateTime.month == 12 ? DateTime(dateTime.year + 1, 1) : DateTime(dateTime.year, _dateTime.month + 1);
  }

  DateTime _previousMonth(DateTime dateTime) {
    return dateTime.month == 1 ? DateTime(dateTime.year - 1, 12) : DateTime(dateTime.year, dateTime.month - 1);
  }

  bool _isSameDay(DateTime dateTime1, DateTime dateTime2) {
    return dateTime1.year == dateTime2.year && dateTime1.month == dateTime2.month && dateTime1.day == dateTime2.day;
  }

  @override
  initState() {
    super.initState();
    initializeDateFormatting();
    _localeDate = DateFormat.yMMM(locale);

    _controller = PageController()
      ..addListener(() {
        setState(() {
          _currentPageValue = _controller.page;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    _calendarItems.clear();
    _addDaysOfPreviousMonth(_calendarItems);
    _addDaysOfCurrentMonth(_calendarItems);
    _addDaysOfFutureMonth(_calendarItems);

    var size = MediaQuery.of(context).size;
    final horizontalPadding = MediaQuery.of(context).padding.horizontal;
    final itemWidth = (size.width - horizontalPadding) / 7;
    final itemHeight = itemWidth / 1.5;

    double calendarViewHeight = itemHeight * ((_calendarItems.length + _weekHeaders.length) ~/ 7) + _headerHeight;
    if (calendarViewHeight != _calendarViewHeight) {
      _calendarViewHeight = calendarViewHeight;
      WidgetsBinding.instance.addPostFrameCallback((_) => onHeightChanged(_calendarViewHeight));
    }

    List<Widget> buildListOfWidgets() {
      List<Widget> list = List();

      list.addAll(_weekHeaders.map((String item) {
        return Container(
          alignment: Alignment.center,
          height: itemHeight,
          child: Text(
            item,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
        );
      }));

      list.addAll(_calendarItems.map((CalendarItem item) {
        Color calendarItemTextColor = item.date.month != _dateTime.month
            ? Colors.grey
            : _isSameDay(item.date, _today) ? Colors.blue : Colors.black;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = item.date;
            });
          },
          child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: _isSameDay(item.date, _selectedDay) ? Colors.black : Colors.transparent),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                )),
            elevation: 0.0,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text(
                    item.day.toString(),
                    style: TextStyle(
                      color: calendarItemTextColor,
                    ),
                  ),
                ),
                item.imageUrl.isNotEmpty
                    ? Align(alignment: Alignment.bottomRight, child: Icon(Icons.star, size: 14, color: Colors.yellow))
                    : Container()
              ],
            ),
          ),
        );
      }));
      return list;
    }

    return PageView.builder(
      onPageChanged: (i) {
        if (i > _currentPageValue)
          setState(() {
            _currentPageValue = i.toDouble();
            _dateTime = _nextMonth(_dateTime);
          });
        else
          setState(() {
            _currentPageValue = i.toDouble();
            _dateTime = _previousMonth(_dateTime);
          });
      },
      controller: _controller,
      itemBuilder: (context, position) {
        return Transform(
          transform: Matrix4.identity()..rotateX(_currentPageValue - position),
          child: Column(
            children: <Widget>[
              Container(
                height: _headerHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: Colors.black,
                            size: 24.0,
                          ),
                          onPressed: () {
                            setState(() {
                              _dateTime = _previousMonth(_dateTime);
                            });
                          }),
                      Text(
                        "${_localeDate.format(this._dateTime)}",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.chevron_right, color: Colors.black, size: 24.0),
                          onPressed: () {
                            setState(() {
                              _dateTime = _nextMonth(_dateTime);
                            });
                          }),
                    ],
                  ),
                ),
              ),
              Container(
                height: _calendarViewHeight - _headerHeight,
                child: GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  childAspectRatio: (itemWidth / itemHeight),
                  children: buildListOfWidgets(),
                  crossAxisCount: _numWeekDays,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
