import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:student/screens/profile/ui/profile_screen.dart';

import 'package:student/screens/settings/ui/settings_screen.dart';
import 'package:student/screens/teacher/screens/teacher_home_screen.dart';
import 'package:student/theming/colors.dart';

// ignore: must_be_immutable
class TeacherNavigator extends StatefulWidget {
  int currentIndex = 0;
  TeacherNavigator({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TeacherNavigatorState createState() => _TeacherNavigatorState();
}

class _TeacherNavigatorState extends State<TeacherNavigator> {
  final List<Widget> _pages = [
    const TeacherHomeScreen(),
    const TeacherHomeScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[widget.currentIndex],
      bottomNavigationBar: GNav(
          selectedIndex: widget.currentIndex,
          onTabChange: (index) {
            setState(() {
              widget.currentIndex = index;
            });
          },
          haptic: true,
          tabBorderRadius: 16,
          gap: 8.w,
          color: ColorsManager.secondaryBlue(context),
          activeColor: ColorsManager.mainBlue(context),
          iconSize: 32.w,
          tabBackgroundColor: ColorsManager.mainBlue(context).withOpacity(0.2),
          padding: EdgeInsets.symmetric(horizontal: 0.03.sw, vertical: 0.01.sh),
          tabMargin: EdgeInsets.all(10.w),
          tabs: const [
            GButton(
              icon: Icons.add_circle,
              text: 'انضمام',
            ),
            GButton(
              icon: Icons.note,
              text: 'موادي',
            ),
            GButton(
              icon: Icons.calendar_today,
              text: 'الجدول',
            ),
            GButton(
              icon: Icons.settings,
              text: 'الحساب',
            ),
          ]),
    );
  }
}
