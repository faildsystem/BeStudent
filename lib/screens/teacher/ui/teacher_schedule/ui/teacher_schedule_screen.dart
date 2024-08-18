import 'package:flutter/material.dart';
import '../../../../../core/widgets/app_bar.dart';
import '../appointments.dart';
import '../widgets/schedule.dart';

class TeacherScheduleScreen extends StatelessWidget {
  const TeacherScheduleScreen({super.key, required this.teacherId});
  final String teacherId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: 'الجدول الدراسي'),
        body: FutureBuilder<DataSource>(
          future: getAllAppointments(teacherId),
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
                child: Text('لا توجد مواعيد'),
              );
            }

            return TeacherSchedule(appointments: snapshot.data!);
          },
        ),
      ),
    );
  }
}
