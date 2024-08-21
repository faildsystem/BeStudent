import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/core/widgets/app_text_form_field.dart';
import 'package:student/helpers/extensions.dart';
import 'package:student/routing/routes.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

import '../../../core/widgets/firestore_functions.dart';
import '../widgets/avatar_name_email.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.isTeacher = false});
  final bool isTeacher;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white(context).withOpacity(.94),
      appBar: MyAppBar(
        title: 'الحساب',
        isProfile: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
        child: ListView(
          children: [
            const ProfileAvatar(),
            Directionality(
              textDirection: TextDirection.rtl,
              child: SettingsGroup(
                settingsGroupTitle: "الحساب",
                settingsGroupTitleStyle: TextStyles.font17DarkBlue700Weight,
                items: [
                  SettingsItem(
                    icons: FontAwesomeIcons.edit,
                    title: "تغيير كلمة المرور",
                    onTap: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.question,
                        animType: AnimType.bottomSlide,
                        title: 'إعادة تعيين كلمة المرور',
                        desc:
                            'سيتم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.',
                        btnCancelText: 'إلغاء',
                        btnCancelOnPress: () {},
                        btnOkText: 'تأكيد',
                        btnOkOnPress: () {
                          try {
                            var _auth = FirebaseAuth.instance;
                            FirebaseAuth.instance.sendPasswordResetEmail(
                                email: _auth.currentUser!.email!);
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.bottomSlide,
                              title: 'تم إرسال الرابط',
                              desc:
                                  'قم بفحص بريدك الإلكتروني لإعادة تعيين كلمة المرور.',
                            ).show();
                          } catch (e) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.bottomSlide,
                              title: 'خطأ في  إرسال الرابط',
                              desc: 'حدث خطأ أثناء إرسال الرابط.',
                            ).show();
                          }
                        },
                      ).show();
                    },
                  ),
                  SettingsItem(
                    icons: Icons.exit_to_app_rounded,
                    title: "تسجيل الخروج",
                    onTap: () async {
                      await AwesomeDialog(
                        context: context,
                        dialogType: DialogType.question,
                        animType: AnimType.bottomSlide,
                        title: 'تأكيد تسجيل الخروج',
                        desc: 'هل أنت متأكد من تسجيل الخروج؟',
                        btnCancelText: 'إلغاء',
                        btnCancelOnPress: () {},
                        btnOkText: 'تأكيد',
                        btnOkOnPress: () async {
                          try {
                            GoogleSignIn().disconnect();
                            FirebaseAuth.instance.signOut();
                            context.pushNamedAndRemoveUntil(
                              Routes.loginScreen,
                              predicate: (route) => false,
                            );
                          } catch (e) {
                            await AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.bottomSlide,
                              title: 'خطأ في تسجيل الخروج',
                              desc: e.toString(),
                            ).show();
                          }
                        },
                      ).show();
                    },
                  ),
                  SettingsItem(
                    icons: CupertinoIcons.delete_solid,
                    title: "حذف الحساب",
                    titleStyle: const TextStyle(
                      color: ColorsManager.coralRed,
                      fontWeight: FontWeight.bold,
                    ),
                    onTap: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) return;

                      final TextEditingController passwordController =
                          TextEditingController();

                      // Show password dialog
                      await AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.bottomSlide,
                        title: 'إعادة المصادقة مطلوبة',
                        desc:
                            'يرجى إدخال كلمة المرور الخاصة بك لمتابعة حذف الحساب.',
                        body: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Column(
                            children: [
                              const Text('يرجى إدخال كلمة المرور الخاصة بك'),
                              SizedBox(height: 10.h),
                              AppTextFormField(
                                controller: passwordController,
                                hint: 'كلمة المرور',
                                validator: (_) {},
                                isObscureText: true,
                              )
                            ],
                          ),
                        ),
                        btnOkText: 'تأكيد',
                        btnCancelText: 'إلغاء',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
                          final password = passwordController.text.trim();
                          if (password.isEmpty) {
                            // Show error if password is empty
                            await AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.bottomSlide,
                              title: 'خطأ',
                              desc: 'كلمة المرور لا يمكن أن تكون فارغة.',
                              btnCancelOnPress: () {},
                              btnCancelText: 'إلغاء',
                            ).show();
                            return;
                          }

                          try {
                            // Reauthenticate with password
                            final credential = EmailAuthProvider.credential(
                              email: user.email!,
                              password: password,
                            );
                            await user.reauthenticateWithCredential(credential);

                            // Delete user and move data
                            int result =
                                await FireStoreFunctions.deleteUserAndMoveData(
                                    user.uid);
                            log('result: $result');
                            if (result == 1) {
                              context.pushNamedAndRemoveUntil(
                                Routes.loginScreen,
                                predicate: (route) => false,
                              );
                            } else if (result == 0) {
                              // User not found in Firestore
                              await AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.bottomSlide,
                                title: 'خطأ',
                                desc: 'لم يتم العثور على المستخدم في النظام.',
                              ).show();
                            } else if (result == -1) {
                              // User not found in Auth
                              await AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.bottomSlide,
                                title: 'خطأ',
                                desc:
                                    'لم يتم العثور على المستخدم في النظام. يرجى تسجيل الدخول مرة أخرى.',
                              ).show();
                            } else {
                              // Transaction failed
                              await AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.bottomSlide,
                                title: 'فشل الحذف',
                                desc:
                                    'فشل في حذف الحساب. يرجى المحاولة مرة أخرى.',
                              ).show();
                            }
                          } catch (e) {
                            // Handle reauthentication errors
                            await AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.bottomSlide,
                              title: 'خطأ',
                              desc:
                                  'فشل في إعادة المصادقة. يرجى التحقق من كلمة المرور والمحاولة مرة أخرى.',
                            ).show();
                          }
                        },
                      ).show();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
