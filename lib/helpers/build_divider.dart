import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/colors.dart';

class BuildDivider {
  

  static Widget buildDivider(context, {required double width}) {
    return Expanded(
      child: Container(
        width: width.w,
        height: 3.h,
        decoration: ShapeDecoration(
          color: ColorsManager.gray(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
