import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student/core/widgets/classes/group.dart';
import 'package:student/helpers/extensions.dart';
import 'package:student/screens/student/ui/groups_screen/widgets/group_info_row.dart';
import 'package:student/screens/student/ui/groups_screen/widgets/qr_code_dialog.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

import '../../../../../routing/routes.dart';

class TeacherGroupComponent extends StatelessWidget {
  const TeacherGroupComponent(
      {super.key, required this.group, required this.teacherId});
  final String teacherId;
  final Group group;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: ColorsManager.secondaryBlue(context),
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    group.groupName,
                    style: TextStyles.font18DarkBlue700Weight,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: ColorsManager.white(context),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return QrDialog(group: group);
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_forever,
                          // color: ColorsManager.white(context),
                        ),
                        onPressed: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.question,
                            animType: AnimType.bottomSlide,
                            btnOk: TextButton(
                              onPressed: () async {
                                context.pop();
                                // await FireStoreFunctions.unrollGroup(
                                //     studentId, group.groupCode);
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
                            desc: 'هل تريد حذف هذه المجموعة؟',
                          ).show();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Gap(8.h),
              InfoRow(
                  attribute: 'الميعاد',
                  value: '${group.groupDay} الساعة  ${group.groupTime}'),
            ],
          ),
        ),
        onTap: () {
          context.pushNamed(
            Routes.allStudentsScreen,
            arguments: group,
          );
          log('group tapped');
        },
      ),
    );
  }
}
