import 'package:flutter/material.dart';
import 'package:suit_up/models/calendar_item.dart';
import 'package:suit_up/util/calendar_util.dart';

import 'calendar_view.dart';

class CalendarItemWidget extends StatelessWidget {
  final CalendarItem calendarItem;

  CalendarItemWidget(this.calendarItem);

  @override
  Widget build(BuildContext context) {
    final state = CalendarInheritedWidget.of(context).state;

    Color calendarItemTextColor = calendarItem.date.month != state.dayOfCurrantMonth.month
        ? Colors.grey
        : isSameDay(calendarItem.date, state.today) ? Colors.blue : Colors.black;

    return GestureDetector(
      onTap: () => state.setSelectedDay(calendarItem.date),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: isSameDay(calendarItem.date, state.selectedDay) ? Colors.black : Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        elevation: 0.0,
        child: Stack(
          children: <Widget>[
            Center(
              child: Text(
                calendarItem.day.toString(),
                style: TextStyle(
                  color: calendarItemTextColor,
                ),
              ),
            ),
            calendarItem.imageUrl.isNotEmpty
                ? Align(alignment: Alignment.bottomRight, child: Icon(Icons.star, size: 14, color: Colors.yellow))
                : Container()
          ],
        ),
      ),
    );
  }
}
