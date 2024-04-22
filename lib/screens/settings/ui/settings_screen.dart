import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool isDark;
  @override
  Widget build(BuildContext context) {
    isDark = EasyDynamicTheme.of(context).themeMode == ThemeMode.dark;

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
                    onTap: () {},
                    icons: Icons.dark_mode_rounded,
                    iconStyle: IconStyle(
                      iconsColor: ColorsManager.white(context),
                      withBackground: true,
                      backgroundColor: ColorsManager.darkBlue(context),
                    ),
                    title: 'تفعيل الوضع الليلي',
                    subtitle: "",
                    trailing: Switch.adaptive(
                      value: isDark,
                      onChanged: (value) {
                        setState(() {
                          isDark = value;
                          EasyDynamicTheme.of(context).changeTheme();
                        });
                      },
                    ),
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.pencil_outline,
                    iconStyle: IconStyle(),
                    title: 'الخطوط',
                    subtitle: "حجم و نوع الخط",
                  ),
                ],
              ),
              SettingsGroup(
                settingsGroupTitle: 'معلومات ',
                settingsGroupTitleStyle: TextStyles.font17DarkBlue700Weight,
                items: [
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.help_outlined,
                    iconStyle: IconStyle(
                      backgroundColor: ColorsManager.purple(context),
                    ),
                    title: 'مساعدة',
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.info_rounded,
                    iconStyle: IconStyle(
                      backgroundColor: ColorsManager.purple(context),
                    ),
                    title: 'عن التطبيق',
                    subtitle: "المزيد عن التطبيق",
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
