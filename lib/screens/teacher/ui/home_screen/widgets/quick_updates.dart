import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickUpdatesBox extends StatelessWidget {
  const QuickUpdatesBox({super.key, required this.imageUrl});

  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      height: 20.h,
      margin: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        // color: Colors.red,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
