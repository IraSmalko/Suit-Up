import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, EventList, WeekdayFormat;

class CalendarPage extends StatefulWidget {
  CalendarPage();

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  _CalendarPageState();

  DateTime _currentDate = DateTime.now();

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      DateTime(2019, 6, 16): [
        Event(
          date: DateTime(2019, 6, 6),
          title: 'Event 1',
          icon: Icon(Icons.thumb_up),
        ),
        Event(
          date: DateTime(2019, 6, 12),
          title: 'Event 2',
          icon: Icon(Icons.thumb_up),
        ),
      ],
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: CalendarCarousel(
        selectedDateTime: _currentDate,
        daysHaveCircularBorder: true,
        markedDatesMap: _markedDateMap,
        onDayPressed: (DateTime date, List list) {
          this.setState(() => _currentDate = date);
        },
        todayTextStyle: TextStyle(color: Colors.black),
        todayBorderColor: Colors.black,
        todayButtonColor: Colors.transparent,
        thisMonthDayBorderColor: Colors.transparent,
        selectedDayButtonColor: Colors.black87,
        selectedDayBorderColor: Colors.transparent,
        weekDayFormat: WeekdayFormat.short,
        weekendTextStyle: TextStyle(color: Colors.black),
        weekdayTextStyle: TextStyle(
          color: Colors.black,
          fontStyle: FontStyle.italic,
        ),
        headerTextStyle: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w600,
        ),
        leftButtonIcon: Icon(
          Icons.keyboard_arrow_left,
          color: Colors.black,
        ),
        rightButtonIcon: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.black,
        ),
      ),
    );
  }
}
