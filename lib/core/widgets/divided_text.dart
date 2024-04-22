import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../theming/styles.dart';
import '../../helpers/build_divider.dart';

class DividedText extends StatelessWidget {
  final String text;
  final double width;
  const DividedText({
    super.key,
    required this.text,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        BuildDivider.buildDivider(width: width),
        Gap(5.w),
        Text(
          text,
          style: TextStyles.font14Grey400Weight,
        ),
        Gap(5.w),
        BuildDivider.buildDivider(width: width),
      ],
    );
  }
}
