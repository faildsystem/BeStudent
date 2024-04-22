import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.attribute,
    required this.value,
  });
  final String attribute;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 3.dg,
          backgroundColor: ColorsManager.white(context),
        ),
        Gap(5.w),
        Text(
          '$attribute: $value',
          style: TextStyles.font14White600Weight,
        ),
      ],
    );
  }
}
