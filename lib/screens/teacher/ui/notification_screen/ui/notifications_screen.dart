import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/screens/teacher/ui/notification_screen/widgets/custom1.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class TeacherNotificationsScreen extends StatelessWidget {
  TeacherNotificationsScreen({Key? key}) : super(key: key);
  final List requests = ["liked", "follow"];
  final List todayItem = ["follow", "liked", "liked"];

  final List oldesItem = ["follow", "follow", "liked", "liked"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          title: "الاشعارات",
        ),
        backgroundColor: ColorsManager.white(context),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("طلبات الانضمام", style: TextStyles.font18DarkBlue700Weight),
                Gap(10.h),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CustomFollowNotifcation(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
