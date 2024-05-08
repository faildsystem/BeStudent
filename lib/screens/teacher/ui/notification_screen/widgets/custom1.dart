import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class CustomFollowNotifcation extends StatefulWidget {
  const CustomFollowNotifcation({Key? key}) : super(key: key);

  @override
  State<CustomFollowNotifcation> createState() =>
      _CustomFollowNotifcationState();
}

class _CustomFollowNotifcationState extends State<CustomFollowNotifcation> {
  bool accepted = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25.w,
          backgroundImage: const AssetImage("assets/images/user.png"),
        ),
        Gap(10.w),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "حمادة",
              style: TextStyles.font14Grey400Weight,
            ),
            Gap(5.h),
            Text(
              "يريد الانضمام لمجموعتك",
              style: TextStyles.font13Grey400Weight,
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  accepted = !accepted;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accepted == false
                    ? ColorsManager.mainBlue(context)
                    : ColorsManager.white(context),
                foregroundColor: accepted == false
                    ? ColorsManager.white(context)
                    : ColorsManager.mainBlue(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("تأكيد"),
            ),
          ],
        ),
      ],
    );
  }
}
