import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:suit_up/models/calendar_item.dart';
import 'package:suit_up/util/calendar_util.dart';

import 'calendar_item.dart';

class CalendarView extends StatefulWidget {
  final Function(double height) onHeightChanged;

  CalendarView({this.onHeightChanged});

  @override
  _CalendarViewState createState() => _CalendarViewState(onHeightChanged);
}

class CalendarInheritedWidget extends InheritedWidget {
  final _CalendarViewState state;

  CalendarInheritedWidget({
    Key key,
    @required this.state,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(CalendarInheritedWidget old) => true;

  static CalendarInheritedWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(CalendarInheritedWidget);
  }
}

class _CalendarViewState extends State<CalendarView> {
  final List<String> _weekHeaders = List.unmodifiable(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]);
  final int _numWeekDays = 7;
  final _calendarItems = <CalendarItem>[];
  final Function(double height) onHeightChanged;
  final DateTime _today = DateTime.now();
  DateTime _dayOfCurrantMonth = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateFormat _localeDate;
  double _headerHeight = 48;
  double _calendarViewHeight;
  String locale = "en";
  PageController _controller;
  double _currentPageValue = 0.0;

  DateTime get dayOfCurrantMonth => _dayOfCurrantMonth;

  DateTime get selectedDay => _selectedDay;

  DateTime get today => _today;

  _CalendarViewState(this.onHeightChanged);

  setSelectedDay(DateTime selectedDay) => setState(() => _selectedDay = selectedDay);

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
    addDaysOfPreviousMonth(_calendarItems, _dayOfCurrantMonth);
    addDaysOfCurrentMonth(_calendarItems, _dayOfCurrantMonth);
    addDaysOfFutureMonth(_calendarItems, _dayOfCurrantMonth);

    var size = MediaQuery.of(context).size;
    final horizontalPadding = MediaQuery.of(context).padding.horizontal;
    final itemWidth = (size.width - horizontalPadding) / 7;
    final itemHeight = itemWidth / 1.5;

    double weekHeadersHeight = itemHeight * (_weekHeaders.length ~/ 7);
    double calendarViewHeight = itemHeight * (_calendarItems.length ~/ 7) + weekHeadersHeight + _headerHeight;
    if (calendarViewHeight != _calendarViewHeight) {
      _calendarViewHeight = calendarViewHeight;
      WidgetsBinding.instance.addPostFrameCallback((_) => onHeightChanged(_calendarViewHeight));
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
                    icon: Icon(Icons.chevron_left, color: Colors.black, size: 24.0),
                    onPressed: () => setState(() => _dayOfCurrantMonth = getPreviousMonth(_dayOfCurrantMonth))),
                Text(
                  "${_localeDate.format(this._dayOfCurrantMonth)}",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: Colors.black, size: 24.0),
                  onPressed: () => setState(() => _dayOfCurrantMonth = getNextMonth(_dayOfCurrantMonth)),
                ),
              ],
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          childAspectRatio: (itemWidth / itemHeight),
          children: _weekHeaders.map((String item) {
            return Container(
              alignment: Alignment.center,
              height: itemHeight,
              child: Text(item, textAlign: TextAlign.center, style: TextStyle(color: Colors.black)),
            );
          }).toList(),
          crossAxisCount: _numWeekDays,
        ),
        Container(
          height: _calendarViewHeight - weekHeadersHeight - _headerHeight,
          child: PageView.builder(
            onPageChanged: (i) {
              if (i > _currentPageValue)
                setState(() {
                  _currentPageValue = i.toDouble();
                  _dayOfCurrantMonth = getNextMonth(_dayOfCurrantMonth);
                });
              else
                setState(() {
                  _currentPageValue = i.toDouble();
                  _dayOfCurrantMonth = getPreviousMonth(_dayOfCurrantMonth);
                });
            },
            controller: _controller,
            itemBuilder: (context, position) {
              return Transform(
                transform: Matrix4.identity()..rotateX(_currentPageValue - position),
                child: GridView.count(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  childAspectRatio: (itemWidth / itemHeight),
                  children: _calendarItems.map((CalendarItem item) {
                    return CalendarInheritedWidget(
                      child: CalendarItemWidget(item),
                      state: this,
                    );
                  }).toList(),
                  crossAxisCount: _numWeekDays,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
