import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:student/screens/profile/ui/profile_screen.dart';

import 'package:student/screens/settings/ui/settings_screen.dart';
import 'package:student/screens/student/ui/join_screen/ui/join_group_screen.dart';
import 'package:student/screens/student/ui/groups_screen/ui/student_groups_screen.dart';
import 'package:student/theming/colors.dart';

// ignore: must_be_immutable
class StudentNavigator extends StatefulWidget {
  late int currentIndex;
  StudentNavigator({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StudentNavigatorState createState() => _StudentNavigatorState();
}

class _StudentNavigatorState extends State<StudentNavigator> {
  final List<Widget> _pages = [
    const JoinCourseScreen(),
    const StudentCourseScreen(),
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
          backgroundColor: ColorsManager.lightShadeOfGray,
          tabBorderRadius: 12,
          gap: 8.w,
          color: ColorsManager.secondaryBlue,
          activeColor: ColorsManager.mainBlue,
          iconSize: 32.w,
          tabBackgroundColor: ColorsManager.mainBlue.withOpacity(0.2),
          padding: EdgeInsets.symmetric(horizontal: 0.03.sw, vertical: 0.01.sh),
          tabMargin: EdgeInsets.all(5.w),
          tabs: const [
            GButton(
              icon: Icons.add_circle,
              text: 'انضمام',
            ),
            GButton(
              icon: Icons.note,
              text: 'مجموعاتك',
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
