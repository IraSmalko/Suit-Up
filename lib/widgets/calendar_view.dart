import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  DateTime _dateTime = DateTime.now();
  double _headerHeight = 48;
  double _calendarViewHeight;

  _CalendarViewState(this.onHeightChanged);

  @override
  void initState() {
    _addDaysOfPrevMonth(_calendarItems);
    _addDaysOfCurrentMonth(_calendarItems);
    _addDaysOfFutureMonth(_calendarItems);

    WidgetsBinding.instance.addPostFrameCallback((_) => onHeightChanged(_calendarViewHeight));
    super.initState();
  }

  _addDaysOfPrevMonth(List<CalendarItem> list) {
    final firstDayOfMonth = DateTime(_dateTime.year, _dateTime.month, 1);
    final beginMonthPadding = firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;
    final previousMonth =
        _dateTime.month == 1 ? DateTime(_dateTime.year - 1, 12) : DateTime(_dateTime.year, _dateTime.month - 1);
    final numDaysOfPrevMonth = _getDaysOfMonth(previousMonth);

    for (int i = numDaysOfPrevMonth - beginMonthPadding + 1; i <= numDaysOfPrevMonth; i++) {
      list.add(CalendarItem(DateTime(previousMonth.year, previousMonth.month, i), i, ""));
    }
  }

  _addDaysOfCurrentMonth(List<CalendarItem> list) {
    final _daysOfMonth = _getDaysOfMonth(_dateTime);
    for (int i = 1; i <= _daysOfMonth; i++) {
      if (i == 22) {
        list.add(CalendarItem(DateTime(_dateTime.year, _dateTime.month, i), i, "res/images/dress_3.jpg"));
      } else
        list.add(CalendarItem(DateTime(_dateTime.year, _dateTime.month, i), i, ""));
    }
  }

  _addDaysOfFutureMonth(List<CalendarItem> list) {
    final lastDayOfMonth = DateTime(_dateTime.year, _dateTime.month, _getDaysOfMonth(_dateTime));
    final endMonthPadding = lastDayOfMonth.weekday == 7 ? 0 : lastDayOfMonth.weekday;
    final futureMonth =
        _dateTime.month == 12 ? DateTime(_dateTime.year + 1, 1) : DateTime(_dateTime.year, _dateTime.month + 1);

    for (int i = endMonthPadding + 1; i <= 6; i++) {
      list.add(CalendarItem(DateTime(futureMonth.year, futureMonth.month, i), i, ""));
    }
  }

  int _getDaysOfMonth(DateTime day) {
    return day.month == 12
        ? DateTime(day.year + 1, 1)
        : DateTime(day.year, day.month + 1).difference(DateTime(day.year, day.month)).inDays;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final horizontalPadding = MediaQuery.of(context).padding.horizontal;
    final itemWidth = (size.width - horizontalPadding) / 7;
    final itemHeight = itemWidth / 1.5;
    _calendarViewHeight = itemHeight * ((_calendarItems.length + _weekHeaders.length) ~/ 7) + _headerHeight;

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
        return Card(
          elevation: 0.0,
          child: Stack(
            children: <Widget>[
              Center(
                child: Text(
                  item.day.toString(),
                  style: TextStyle(
                    color: item.date.month != _dateTime.month ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              item.imageUrl.isNotEmpty
                  ? Align(alignment: Alignment.bottomRight, child: Icon(Icons.star, size: 14, color: Colors.yellow))
                  : Container()
            ],
          ),
        );
      }));
      return list;
    }

    return Column(
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
                    onPressed: () {}),
                IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    onPressed: () {}),
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
    );
  }
}
