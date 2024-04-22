import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theming/styles.dart';

class TermsAndConditionsText extends StatelessWidget {
  const TermsAndConditionsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'بتسجيلك، فإنك توافق على',
            style: TextStyles.font11MediumLightShadeOfGray400Weight,
          ),
          TextSpan(
            text: ' الشروط والأحكام',
            style: TextStyles.font12DarkBlue600Weight,
          ),
          TextSpan(
            text: ' و',
            style: TextStyles.font11MediumLightShadeOfGray400Weight
                .copyWith(height: 4.h),
          ),
          TextSpan(
            text: ' سياسة الخصوصية',
            style: TextStyles.font12DarkBlue600Weight,
          ),
        ],
      ),
    );
  }
}
