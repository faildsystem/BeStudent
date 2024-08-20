import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/core/widgets/app_text_button.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../widgets/theme_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key, required this.isTeacher}) : super(key: key);
  final bool isTeacher;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _launchWhatsappGroup() async {
    // final Uri whatsappUrl =
    //     Uri.parse('https://wa.me/+201011309251/?text=Hello bitch');

    // if (await canLaunchUrl(whatsappUrl)) {
    //   await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    // } else {
    //   throw 'Could not launch $whatsappUrl';
    // }

    String url = 'https://chat.whatsapp.com/CzHBGdJsKD67u21O0NhLGf';

    // ignore: deprecated_member_use
    launch(url);
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
                    onTap: _launchWhatsappGroup, // Navigate to whatsapp group
                    icons: FontAwesomeIcons.whatsapp,
                    iconStyle: IconStyle(
                      backgroundColor: ColorsManager.green,
                    ),
                    title: 'تواصل معنا',
                  ),
                  SettingsItem(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Center(child: Text('حول التطبيق')),
                            content: Text(
                              'تطبيق يساعد الطلاب والمعلمين على إدارة الدروس والواجبات والامتحانات بسهولة وراحة. \n\n يمكنكم الانضمام إلى مجموعتنا على الواتساب للحصول على المزيد من الدعم والموارد.',
                              style: TextStyles.font15DarkBlue500Weight,
                              textDirection: TextDirection.rtl,
                            ),
                            actions: [
                              Center(
                                child: AppTextButton(
                                  buttonText: 'حسنا',
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  textStyle: TextStyles.font16White600Weight,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icons: Icons.info_outline,
                    iconStyle: IconStyle(
                      backgroundColor: ColorsManager.secondaryBlue(context),
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
