import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../theming/colors.dart';

class QrCodeGenerator extends StatelessWidget {
  const QrCodeGenerator({
    super.key,
    required this.data,
    required this.width,
    required this.height,
  });
  final String data;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: width.w,
        height: height.h,
        child: PrettyQrView.data(
          data: data,
          // errorCorrectLevel: QrErrorCorrectLevel.H,
          decoration: const PrettyQrDecoration(
              image: PrettyQrDecorationImage(
                image: AssetImage('assets/images/quiz.png'),
              ),
              shape: PrettyQrSmoothSymbol(color: ColorsManager.mainBlueColor)),
        ),
      ),
    );
  }
}
