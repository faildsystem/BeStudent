import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../core/classes/subject.dart';
import '../../../../core/widgets/firestore_functions.dart';

// Function to get the color for a given subject
Color getColorForSubject(String subject) {
  return Subject.subjects[subject] ??
      Colors.grey; // Default color if subject not found
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

Future<DataSource> getAllAppointments(String studentId) async {
  final studentGroups = await FireStoreFunctions.fetchStudentGroups(studentId);
  // log(studentGroups.toString());
  final List<Appointment> appointments = <Appointment>[];

  for (final group in studentGroups) {
    final String untilDate = calculateUntilDate(
        group.creationDate, 100); // Assuming 6 weeks duration
    final Color groupColor = getColorForSubject(group.subjectName);

    appointments.add(
      Appointment(
        startTime: group.creationDate.toDate(),
        endTime:
            group.creationDate.toDate().add(Duration(hours: group.duration)),
        subject: group.subjectName,
        color: groupColor,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=${group.groupDay};UNTIL=$untilDate;',
      ),
    );
  }

  return DataSource(appointments);
}

String calculateUntilDate(Timestamp creationDate, int durationInWeeks) {
  final DateTime endDate =
      creationDate.toDate().add(Duration(days: 7 * durationInWeeks));
  return endDate.toUtc().toIso8601String().split('T').first.replaceAll('-', '');
}
