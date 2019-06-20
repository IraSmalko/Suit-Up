import 'package:suit_up/models/calendar_item.dart';

addDaysOfPreviousMonth(List<CalendarItem> list, DateTime dayOfCurrantMonth) {
  final firstDayOfMonth = DateTime(dayOfCurrantMonth.year, dayOfCurrantMonth.month, 1);
  final beginMonthPadding = firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;
  final previousMonth = getPreviousMonth(dayOfCurrantMonth);
  final numDaysOfPrevMonth = getDaysOfMonth(previousMonth);

  for (int i = numDaysOfPrevMonth - beginMonthPadding + 1; i <= numDaysOfPrevMonth; i++) {
    list.add(CalendarItem(DateTime(previousMonth.year, previousMonth.month, i), i, ""));
  }
}

addDaysOfCurrentMonth(List<CalendarItem> list, DateTime dayOfCurrantMonth) {
  final _daysOfMonth = getDaysOfMonth(dayOfCurrantMonth);
  for (int i = 1; i <= _daysOfMonth; i++) {
    if (i == 19) {
      list.add(CalendarItem(DateTime(dayOfCurrantMonth.year, dayOfCurrantMonth.month, i), i, "res/images/dress_3.jpg"));
    } else
      list.add(CalendarItem(DateTime(dayOfCurrantMonth.year, dayOfCurrantMonth.month, i), i, ""));
  }
}

addDaysOfFutureMonth(List<CalendarItem> list, DateTime dayOfCurrantMonth) {
  final lastDayOfMonth = DateTime(dayOfCurrantMonth.year, dayOfCurrantMonth.month, getDaysOfMonth(dayOfCurrantMonth));
  final endMonthPadding = lastDayOfMonth.weekday == 7 ? 0 : lastDayOfMonth.weekday;
  final futureMonth = getNextMonth(dayOfCurrantMonth);

  for (int i = 1; i <= 6 - endMonthPadding; i++) {
    list.add(CalendarItem(DateTime(futureMonth.year, futureMonth.month, i), i, ""));
  }
}

int getDaysOfMonth(DateTime day) {
  return (day.month == 12
          ? DateTime(day.year + 1, 1).difference(DateTime(day.year, day.month)).inHours / 24
          : DateTime(day.year, day.month + 1, 1).difference(DateTime(day.year, day.month, 1)).inHours / 24)
      .round();
}

DateTime getNextMonth(DateTime dateTime) {
  return dateTime.month == 12 ? DateTime(dateTime.year + 1, 1) : DateTime(dateTime.year, dateTime.month + 1);
}

DateTime getPreviousMonth(DateTime dateTime) {
  return dateTime.month == 1 ? DateTime(dateTime.year - 1, 12) : DateTime(dateTime.year, dateTime.month - 1);
}

bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
  return dateTime1.year == dateTime2.year && dateTime1.month == dateTime2.month && dateTime1.day == dateTime2.day;
}
