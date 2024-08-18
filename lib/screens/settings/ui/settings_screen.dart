import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/theme_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key, required this.isTeacher}) : super(key: key);
  final bool isTeacher;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _launchTelegramGroup() async {
    final Uri telegramUrl = Uri.parse(
        'https://t.me/+mSkZBcW5tuExZTQ0'); // Replace with your Telegram group link

    if (await canLaunchUrl(telegramUrl)) {
      await launchUrl(telegramUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $telegramUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white(context).withOpacity(.94),
      appBar: MyAppBar(
        title: "اعدادات التطبيق",
        isProfileOrSettings: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
          child: ListView(
            children: [
              SettingsGroup(
                settingsGroupTitle: "المظهر",
                settingsGroupTitleStyle: TextStyles.font17DarkBlue700Weight,
                items: [
                  SettingsItem(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ThemeDialog(isTeacher: widget.isTeacher);
                        },
                      );
                    },
                    icons: Icons.dark_mode_rounded,
                    iconStyle: IconStyle(
                      iconsColor: ColorsManager.white(context),
                      withBackground: true,
                      backgroundColor: ColorsManager.darkBlue(context),
                    ),
                    title: 'تغيير المظهر',
                  ),
                ],
              ),
              SettingsGroup(
                settingsGroupTitle: 'معلومات ',
                settingsGroupTitleStyle: TextStyles.font17DarkBlue700Weight,
                items: [
                  SettingsItem(
                    onTap: _launchTelegramGroup, // Navigate to Telegram group
                    icons: Icons.help_outlined,
                    iconStyle: IconStyle(
                      backgroundColor: ColorsManager.purple(context),
                    ),
                    title: 'مساعدة',
                  ),
                  SettingsItem(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('حول التطبيق'),
                            content: Text(
                              'تطبيق يساعد الطلاب و المعلمين علي ادارة الدروس و الواجبات و الامتحانات بشكل سهل و مريح و يمكنكم الانضمام الي مجموعتنا علي تليجرام للمزيد من المساعدة',
                              style: TextStyles.font15DarkBlue500Weight,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'اغلاق',
                                  style: TextStyles.font15DarkBlue500Weight,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icons: Icons.info_outline,
                    iconStyle: IconStyle(
                      backgroundColor: ColorsManager.purple(context),
                    ),
                    title: 'حول التطبيق',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
