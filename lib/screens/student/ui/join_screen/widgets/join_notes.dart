import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class JoinNotes extends StatelessWidget {
  const JoinNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildNotesRow(
              context, 'اطلب من معلمك كود المادة لتتمكن من الانضمام.'),
          Gap(10.h),
          _buildNotesRow(context,
              'الكود يجب أن يحتوي على ٦ أحرف على الأقل بدون مسافات او رموز.'),
        ],
      ),
    );
  }

  Widget _buildNotesRow(context, String text) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        CircleAvatar(
          radius: 3,
          backgroundColor: ColorsManager.gray(context),
        ),
        Gap(5.w),
        Text(
          text,
          style: TextStyles.font12DarkBlue600Weight,
        )
      ],
    );
  }
}
