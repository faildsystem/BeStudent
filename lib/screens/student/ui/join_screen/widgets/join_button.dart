import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student/core/widgets/app_text_button.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/helpers/app_regex.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class JoinButton extends StatelessWidget {
  JoinButton({super.key, required this.codeController});
  final TextEditingController codeController;
  final String studentId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth / 1.5,
      child: AppTextButton(
        buttonText: 'انضمام',
        textStyle: TextStyles.font16White600Weight,
        onPressed: () async {
          log('Join button pressed');
          final group = await FireStoreFunctions.getDoc(
              collection: 'group',
              field: 'groupCode',
              value: codeController.text);
          log('Fetched group: $group');

          if (AppRegex.isCodeValid(codeController.text) && group != null) {
            log('Group code is valid and group exists');
            final joinState =
                await FireStoreFunctions.sendJoinRequestNotification(
                    group['creatorId'],
                    group.id,
                    studentId,
                    group['groupName']);
            log('Join state: $joinState');

            if (joinState == 1) {
              log('Join request successful');
              if (context.mounted) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  animType: AnimType.bottomSlide,
                  btnOkOnPress: () {},
                  btnOkText: 'حسنا',
                  title: 'تم ارسال طلب الانضمام بنجاح',
                  desc:
                      'تم ارسال طلب الانضمام بنجاح، سيتم اعلامك بالرد عليه في اقرب وقت ممكن.',
                ).show();
              }
            } else if (joinState == 0) {
              log('Join request is pending');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: ColorsManager.mainBlue(context),
                    content: const Center(
                      child: Text('طلب الانضمام قيد الانتظار.'),
                    ),
                  ),
                );
              }
            } else if (joinState == 2) {
              log('Already joined this group');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: ColorsManager.mainBlue(context),
                    content: const Center(
                      child: Text('انت بالفعل منضم لهذه المجموعة.'),
                    ),
                  ),
                );
              }
            } else {
              log('Join request failed');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: ColorsManager.coralRed,
                    content: Center(
                      child: Text(
                          'حدث خطأ أثناء إرسال طلب الانضمام، يرجى المحاولة مرة أخرى.'),
                    ),
                  ),
                );
              }
            }
          } else {
            log('Invalid group code or group not found');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: ColorsManager.coralRed,
                  content: Center(
                    child: Text('من فضلك أدخل كود المادة بشكل صحيح'),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
