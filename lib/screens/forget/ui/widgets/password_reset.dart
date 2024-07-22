import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/app_text_button.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../helpers/app_regex.dart';
import '../../../../theming/styles.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          emailField(),
          Gap(30.h),
          resetButton(context),
        ],
      ),
    );
  }

  AppTextButton resetButton(BuildContext context) {
    return AppTextButton(
      buttonText: 'اعادة تعيين',
      textStyle: TextStyles.font16White600Weight,
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          try {
            await FirebaseAuth.instance
                .sendPasswordResetEmail(email: emailController.text);
            if (!context.mounted) return;

            AwesomeDialog(
              context: context,
              dialogType: DialogType.info,
              animType: AnimType.bottomSlide,
              title: 'اعادة تعيين',
              desc: 'تم ارسال رابط لانشاء كلمة سر الى حسابك ',
            ).show();
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: 'خطأ',
                desc: 'هذا الحساب ليس موجود',
              ).show();
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: 'خطأ',
                desc: e.message,
              ).show();
            }
          }
        }
      },
    );
  }

  AppTextFormField emailField() {
    return AppTextFormField(
      hint: 'البريد الالكتروني',
      validator: (value) {
        if (value == null || value.isEmpty || !AppRegex.isEmailValid(value)) {
          return 'من فضلك ادخل بريد صحيح';
        }
      },
      controller: emailController,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
