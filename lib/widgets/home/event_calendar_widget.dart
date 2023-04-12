import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../data/event_widget_data.dart';

class EventCalendarWidget extends StatefulWidget {
  const EventCalendarWidget({Key? key}) : super(key: key);

  @override
  _EventCalendarWidgetState createState() => _EventCalendarWidgetState();
}

class _EventCalendarWidgetState extends State<EventCalendarWidget> {

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.week,
      showNavigationArrow: false,
      initialDisplayDate: DateTime.now(),
      headerHeight: 0,
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 14)),
      firstDayOfWeek: DateTime.now().weekday,
      selectionDecoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.transparent),
      ),
      timeSlotViewSettings: const TimeSlotViewSettings(
        timelineAppointmentHeight: 100,
        timeInterval: Duration(hours: 1),
        timeIntervalHeight: 0,
        timeIntervalWidth: 0,
        timeRulerSize: 0 ,
      ),
      dataSource: EventDataSource(eventList),

    );
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Map<String, dynamic>> source) {
    appointments = <Appointment>[];
    for (var i = 0; i < source.length; i++) {
      final Map<String, dynamic> data = source[i];
      final DateTime expiry = data['expiry'];
      final DateTime start = data['start'];
      final DateTime now = DateTime.now();
      final Duration remainingTime = expiry.difference(now);
      final int daysRemaining = remainingTime.inDays;
      final int randomIndex = Random(daysRemaining).nextInt(Colors.primaries.length);
      appointments?.add(Appointment(
        startTime: start,
        endTime: expiry,
        subject: data['title'],
        color: Colors.primaries[randomIndex],
      ));
    }
  }
}
