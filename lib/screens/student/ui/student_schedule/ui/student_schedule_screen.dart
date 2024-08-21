import 'package:flutter/material.dart';
import 'package:student/theming/colors.dart';
import '../../../../../core/widgets/app_bar.dart';
import '../appointments.dart';
import '../widgets/schedule.dart';

class StudentScheduleScreen extends StatelessWidget {
  const StudentScheduleScreen({super.key, required this.studentId});
  final String studentId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: 'الجدول الدراسي'),
        body: FutureBuilder<DataSource>(
          future: getAllAppointments(studentId),
          builder: (BuildContext context, AsyncSnapshot<DataSource> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('حدث خطأ ما'),
              );
            }
            if (snapshot.data == null || snapshot.data!.appointments!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.calendar_today,
                      size: 100,
                      color: ColorsManager.mainBlueColor,
                    ),
                    Text(
                      'لا يوجد جدول دراسي',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              );
            }

            return StudentSchedule(appointments: snapshot.data!);
          },
        ),
      ),
    );
  }
}
