import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student/core/widgets/app_text_button.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/core/widgets/dialog_message.dart';
import 'package:student/helpers/app_regex.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class JoinButton extends StatelessWidget {
  JoinButton({super.key, required this.codeController});
  final TextEditingController codeController;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth / 1.5,
      child: AppTextButton(
        buttonText: 'انضمام',
        textStyle: TextStyles.font16White600Weight,
        onPressed: () async {
          if (AppRegex.isCodeValid(codeController.text)) {
            final int join = await FireStoreFunctions.groupJoinRequest(
              userId: userId,
              code: codeController.text,
            );
            if (join == 1) {
              // ignore: use_build_context_synchronously
              CustomDialog.showDialog(
                  context: context,
                  type: DialogType.success,
                  title: 'تم الانضمام بنجاح',
                  message:
                      'تم الانضمام بنجاح للمجموعة، يمكنك الان الانتقال لصفحة المواد.',
                  argument: 1);
            } else if (join == 0) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: ColorsManager.mainBlue,
                  content: Center(
                    child: Text(
                      'انت بالفعل منضم لهذه المجموعة.',
                    ),
                  ),
                ),
              );
            } else {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: ColorsManager.coralRed,
                  content: Center(
                    child: Text(
                      'الكود الذي ادخلته غير صحيح، يرجى التأكد من الكود والمحاولة مرة اخرى.',
                    ),
                  ),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: ColorsManager.coralRed,
                content: Center(
                  child: Text(
                    'من فضلك أدخل كود المادة بشكل صحيح',
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
