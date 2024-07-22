import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/core/widgets/app_text_form_field.dart';
import 'package:student/core/widgets/divided_text.dart';

import '../widgets/join_button.dart';
import '../widgets/join_notes.dart';
import '../widgets/scan_button.dart';

class JoinCourseScreen extends StatefulWidget {
  const JoinCourseScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _JoinCourseScreenState createState() => _JoinCourseScreenState();
}

class _JoinCourseScreenState extends State<JoinCourseScreen> {
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyAppBar(title: 'الصفحة الرئيسية'),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(20.h),
              SizedBox(
                width: screenWidth / 1.5,
                child: AppTextFormField(
                  hint: 'أدخل كود المادة',
                  validator: (value) {},
                  controller: codeController,
                ),
              ),
              Gap(20.h),
              const JoinNotes(),
              Gap(20.h),
              JoinButton(codeController: codeController),
              Gap(30.h),
              DividedText(
                text: 'او انضم عن طريق QR Code',
                width: screenWidth / 4,
              ),
              Gap(60.h),
              const ScanButton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }
}
