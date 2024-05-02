import 'package:flutter/material.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

Future<DataSource> getAllAppointments(String studentId) async {
  final studentGroups = await FireStoreFunctions.fetchStudentGroups(studentId);

  final List<Appointment> appointments = <Appointment>[];

  for (final group in studentGroups) {
    appointments.add(
      Appointment(
        startTime: group.creationDate.toDate(),
        endTime:
            group.creationDate.toDate().add(Duration(hours: group.duration)),
        subject: group.subjectName,
        color: Colors.red,
        recurrenceRule:
            // 'FREQ=WEEKLY;BYDAY=${group.groupDay};UNTIL=20240520T183000Z;',
            'FREQ=WEEKLY;BYDAY=${group.groupDay};',
      ),
    );
  }

  return DataSource(appointments);
}
