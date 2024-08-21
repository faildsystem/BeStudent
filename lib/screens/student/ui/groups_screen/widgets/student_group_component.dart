import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student/core/classes/days.dart';
import 'package:student/core/classes/group.dart';

import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

import 'group_info_row.dart';
import '../../../../../core/widgets/qr_code_dialog.dart';

class StudentGroupComponent extends StatelessWidget {
  const StudentGroupComponent(
      {super.key, required this.group, required this.studentId});
  final String studentId;
  final Group group;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: ColorsManager.secondaryBlue(context),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 5.h),
        padding: EdgeInsets.all(10.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30.w,
                      backgroundImage: group.teacherImage.isNotEmpty
                          ? NetworkImage(group.teacherImage)
                          : const AssetImage(
                              'assets/images/user.png',
                            ) as ImageProvider,
                    ),
                    Gap(8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.subjectName,
                          style: TextStyles.font16White600Weight,
                        ),
                        Gap(5.h),
                        Text(
                          group.teacherName,
                          style: TextStyles.font14Grey76400Weight,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return GroupQrCode(group: group);
                            },
                          );
                        },
                        icon: Icon(
                          Icons.share,
                          color: ColorsManager.white(context),
                        )),
                  ],
                ),
              ],
            ),
            Gap(8.h),
            InfoRow(attribute: 'المجموعة', value: group.groupName),
            InfoRow(
                attribute: 'الميعاد',
                value:
                    '${Days.translateDayToArabic(group.groupDay)} الساعة  ${group.groupTime}'),
          ],
        ),
      ),
    );
  }
}
