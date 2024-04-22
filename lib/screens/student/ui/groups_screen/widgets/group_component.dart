import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student/core/widgets/classes/group.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/helpers/extensions.dart';
import 'package:student/screens/student/ui/groups_screen/widgets/group_info_row.dart';
import 'package:student/screens/student/ui/groups_screen/widgets/qr_code_dialog.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class GroupComponent extends StatelessWidget {
  const GroupComponent(
      {super.key, required this.group, required this.studentId});
  final String studentId;
  final Group group;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
            color: ColorsManager.secondaryBlue,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1.5,
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ]),
        margin: EdgeInsets.symmetric(horizontal: 5.h),
        padding: EdgeInsets.all(10.h),
        child: Column(
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
                      group.groupSubjectName,
                      style: TextStyles.font16White600Weight,
                    ),
                    Gap(5.h),
                    Text(
                      group.teacherName,
                      style: TextStyles.font14Grey76400Weight,
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
                              return QrDialog(group: group);
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.share,
                          color: ColorsManager.white,
                        )),
                    IconButton(
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.question,
                          animType: AnimType.bottomSlide,
                          btnOk: TextButton(
                            onPressed: () async {
                              context.pop();
                              await FireStoreFunctions.unrollGroup(
                                  studentId, group.groupCode);
                            },
                            child: const Text('نعم'),
                          ),
                          btnCancel: TextButton(
                            onPressed: () async {
                              context.pop();
                            },
                            child: const Text(
                              'لا',
                              style: TextStyle(color: ColorsManager.coralRed),
                            ),
                          ),
                          title: 'تأكيد',
                          desc: 'هل تريد مغادرة هذه المجموعة؟',
                        ).show();
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: ColorsManager.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Gap(8.h),
            InfoRow(attribute: 'المجموعة', value: group.groupName),
            InfoRow(
                attribute: 'الميعاد',
                value: '${group.groupDay} الساعة  ${group.groupTime}'),
          ],
        ),
      ),
    );
  }
}
