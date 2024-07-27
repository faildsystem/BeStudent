import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student/helpers/extensions.dart';
import 'package:student/routing/routes.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.qrScannerScreen);
      },
      child: Container(
        height: screenHeight / 4,
        width: screenWidth / 2,
        decoration: BoxDecoration(
          color: ColorsManager.white(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.expand,
                  size: 120.dg,
                  color: ColorsManager.mainBlue(context),
                ),
                Icon(
                  FontAwesomeIcons.camera,
                  size: 65.dg,
                  color: ColorsManager.mainBlue(context),
                ),
              ],
            ),
            Text(
              'اضغط لفتح الكاميرا',
              style: TextStyles.font14DarkBlue500Weight,
            ),
          ],
        ),
      ),
    );
  }
}
