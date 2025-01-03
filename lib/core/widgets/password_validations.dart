import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../theming/colors.dart';
import '../../../theming/styles.dart';

class PasswordValidations extends StatelessWidget {
  final bool hasLowerCase;
  final bool hasSpecialCharacters;
  final bool hasNumber;
  final bool hasMinLength;
  const PasswordValidations(
      {super.key,
      required this.hasLowerCase,
      required this.hasSpecialCharacters,
      required this.hasNumber,
      required this.hasMinLength});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: buildValidationRow(
                context,
                'يحتوي على حرف صغير',
                hasLowerCase,
              ),
            ),
            Gap(8.h),
            Expanded(
              child: buildValidationRow(
                context,
                'يحتوي على رمز ',
                hasSpecialCharacters,
              ),
            ),
          ],
        ),
        Gap(5.h),
        Row(
          children: [
            Expanded(
              child: buildValidationRow(
                context,
                'يحتوي على رقم',
                hasNumber,
              ),
            ),
            Gap(8.h),
            Expanded(
              child: buildValidationRow(
                context,
                ' ثمانية احرف على الاقل',
                hasMinLength,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildValidationRow(context, String text, bool hasValidated) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Gap(20.w),
        CircleAvatar(
          radius: 2.5.sp,
          backgroundColor: ColorsManager.gray(context),
        ),
        Gap(6.w),
        Text(
          text,
          style: TextStyles.font15DarkBlue500Weight.copyWith(
            fontSize: 10.5.sp,
            decoration: hasValidated ? TextDecoration.lineThrough : null,
            decorationColor: ColorsManager.mainBlue(context),
            decorationThickness: 2,
            color: hasValidated
                ? ColorsManager.gray(context)
                : ColorsManager.darkBlue(context),
          ),
        )
      ],
    );
  }
}
