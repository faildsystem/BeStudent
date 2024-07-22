import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student/core/widgets/qr_code_generator.dart';

class QrCodeScreen extends StatelessWidget {
  QrCodeScreen({super.key});
  final String studentId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    // final group = ModalRoute.of(context)!.settings.arguments as Group;
    return SafeArea(
      child: Scaffold(
        // appBar: MyAppBar(title: 'انشاء الكود الخاص بك'),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                ' الكود الخاص بك لحضور مجموعة',
                style: TextStyle(fontSize: 20.sp),
                textAlign: TextAlign.center,
              ),
            ),
            QrCodeWidget(
              data: studentId,
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}
