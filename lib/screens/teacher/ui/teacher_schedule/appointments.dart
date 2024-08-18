import 'package:flutter/material.dart';
import 'package:student/core/classes/subject.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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

Future<DataSource> getAllAppointments(String teacherId) async {
  final studentGroups = await FireStoreFunctions.fetchTeacherGroups(teacherId);
  final List<Appointment> appointments = <Appointment>[];
  final termEndDate = await FireStoreFunctions.fetchTermEndDate();
  for (final group in studentGroups) {
    // final String untilDate = calculateUntilDate(
    //     group.creationDate, 100); // Assuming 6 weeks duration
    final Color subjectColor = getColorForSubject(group.subjectName);

    appointments.add(
      Appointment(
        startTime: group.creationDate.toDate(),
        endTime:
            group.creationDate.toDate().add(Duration(hours: group.duration)),
        subject: group.subjectName,
        color: subjectColor,
        recurrenceRule:
            'FREQ=WEEKLY;BYDAY=${group.groupDay};UNTIL=$termEndDate;',
      ),
    );
  }

  return DataSource(appointments);
}

// String calculateUntilDate(Timestamp creationDate, int durationInWeeks) {
//   final DateTime endDate =
//       creationDate.toDate().add(Duration(days: 7 * durationInWeeks));
//   return endDate.toUtc().toIso8601String().split('T').first.replaceAll('-', '');

// }
