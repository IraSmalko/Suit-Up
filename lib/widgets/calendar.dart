import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, EventList, WeekdayFormat;
import 'package:suit_up/models/category.dart';
import 'package:suit_up/repository/repository.dart';

import 'items_list.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage();

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  ScrollController _scrollController;
  static final List<Category> _category = Repository.instance.categories;

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
  void initState() {
    _scrollController = new ScrollController();
    _scrollController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CalendarCarousel calendar = buildCalendar();
    print("WWW ${calendar}");

    return Scaffold(
      appBar: null,
      body: Stack(
        children: <Widget>[
          NestedScrollView(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverList(delegate: SliverChildBuilderDelegate((ctx, int) {
                  return int == 0 ? calendar : null;
                }))
              ];
            },
            body: ItemsList(Repository.instance.dress),
          ),
        ],
      ),
    );
  }

  Widget buildCalendar() {
    return CalendarCarousel(
      height: 320,
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
      headerMargin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
      leftButtonIcon: Icon(
        Icons.keyboard_arrow_left,
        color: Colors.black,
      ),
      rightButtonIcon: Icon(
        Icons.keyboard_arrow_right,
        color: Colors.black,
      ),
    );
  }
}
