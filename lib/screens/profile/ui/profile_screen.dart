import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/helpers/extensions.dart';
import 'package:student/routing/routes.dart';
import 'package:student/screens/profile/widgets/avatar_name_email.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white(context).withOpacity(.94),
      appBar: MyAppBar(
        title: 'الحساب',
        isProfileOrSettings: true,
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
                    onTap: () {},
                    icons: CupertinoIcons.repeat,
                    title: "تغيير البريد الالكتروني",
                  ),
                  SettingsItem(
                    icons: Icons.exit_to_app_rounded,
                    title: "تسجيل الخروج",
                    onTap: () async {
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
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.delete_solid,
                    title: "حذف الحساب",
                    titleStyle: const TextStyle(
                      color: ColorsManager.coralRed,
                      fontWeight: FontWeight.bold,
                    ),
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
