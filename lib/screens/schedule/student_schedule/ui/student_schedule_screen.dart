import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bar.dart';
import '../widgets/appointment.dart';

class StudentScheduleScreen extends StatelessWidget {
  const StudentScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: MyAppBar(title: 'الجدول الدراسي'),
      body: const AppointmentTimeTextFormat(),
    ));
  }
}
