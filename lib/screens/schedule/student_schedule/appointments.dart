import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

_DataSource getDataSource() {
  final List<Appointment> appointments = <Appointment>[];
  appointments.add(Appointment(
    startTime: DateTime.now().add(const Duration(hours: 4)),
    endTime: DateTime.now().add(const Duration(hours: 5)),
    subject: 'اول مهمة',
    color: Colors.red,
  ));
  appointments.add(Appointment(
    startTime: DateTime.now().add(const Duration(days: -2, hours: 4)),
    endTime: DateTime.now().add(const Duration(days: -2, hours: 5)),
    subject: 'Development Meeting   New York, U.S.A',
    color: const Color(0xFFf527318),
  ));
  appointments.add(Appointment(
    startTime: DateTime.now().add(const Duration(days: -2, hours: 3)),
    endTime: DateTime.now().add(const Duration(days: -2, hours: 4)),
    subject: 'Project Plan Meeting   Kuala Lumpur, Malaysia',
    color: const Color(0xFFfb21f66),
  ));
  appointments.add(Appointment(
    startTime: DateTime.now().add(const Duration(days: -2, hours: 3)),
    endTime: DateTime.now().add(const Duration(days: -2, hours: 4)),
    subject: 'Project Plan Meeting   Kuala Lumpur, Malaysia',
    color: const Color(0xFFfb21f66),
  ));
  appointments.add(Appointment(
    startTime: DateTime.now().add(const Duration(days: -2, hours: 3)),
    endTime: DateTime.now().add(const Duration(days: -2, hours: 4)),
    subject: 'Project Plan Meeting   Kuala Lumpur, Malaysia',
    color: const Color(0xFFfb21f66),
  ));
  appointments.add(Appointment(
    startTime: DateTime.now().add(const Duration(days: -2, hours: 3)),
    endTime: DateTime.now().add(const Duration(days: -2, hours: 4)),
    subject: 'Project Plan Meeting   Kuala Lumpur, Malaysia',
    color: const Color(0xFFfb21f66),
  ));
  appointments.add(Appointment(
    startTime: DateTime.now().add(const Duration(days: -2, hours: 2)),
    endTime: DateTime.now().add(const Duration(days: -2, hours: 3)),
    subject: 'Support - Web Meeting   Dubai, UAE',
    color: const Color(0xFFf3282b8),
  ));
  appointments.add(Appointment(
    startTime: DateTime.now().add(const Duration(days: -2, hours: 1)),
    endTime: DateTime.now().add(const Duration(days: -2, hours: 2)),
    subject: 'Project Release Meeting   Istanbul, Turkey',
    color: const Color(0xFFf2a7886),
  ));
  appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 4, days: -1)),
      endTime: DateTime.now().add(const Duration(hours: 5, days: -1)),
      subject: 'Release Meeting',
      color: Colors.lightBlueAccent,
      isAllDay: true));
  appointments.add(Appointment(
    startTime: DateTime.now().add(const Duration(hours: 2, days: -4)),
    endTime: DateTime.now().add(const Duration(hours: 4, days: -4)),
    subject: 'Performance check',
    color: Colors.amber,
  ));
  appointments.add(Appointment(
    startTime: DateTime.now().add(const Duration(hours: 11, days: -2)),
    endTime: DateTime.now().add(const Duration(hours: 12, days: -2)),
    subject: 'Customer Meeting   Tokyo, Japan',
    color: const Color(0xFFffb8d62),
  ));
  appointments.add(Appointment(
    startTime: DateTime.now().add(const Duration(hours: 6, days: 2)),
    endTime: DateTime.now().add(const Duration(hours: 7, days: 2)),
    subject: 'Retrospective',
    color: Colors.purple,
  ));

  return _DataSource(appointments);
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
