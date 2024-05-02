import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:student/screens/schedule/student_schedule/ui/student_schedule_screen.dart';
import 'package:student/screens/student/ui/join_screen/ui/join_group_screen.dart';
import 'package:student/screens/student/ui/groups_screen/ui/student_groups_screen.dart';
import 'package:student/screens/teacher/ui/group_students_screen/ui/show_all_students_screen.dart';
import 'package:student/theming/colors.dart';

import '../../settings/ui/settings_screen.dart';

// ignore: must_be_immutable
class StudentNavigator extends StatefulWidget {
  late int currentIndex;
  final String studentId = FirebaseAuth.instance.currentUser!.uid;

  StudentNavigator({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _StudentNavigatorState createState() => _StudentNavigatorState();
}

class _StudentNavigatorState extends State<StudentNavigator> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          const JoinCourseScreen(),
          const StudentGroupsScreen(),
          StudentScheduleScreen(studentId: widget.studentId),
          // ProfileScreen(),
          const SettingsScreen(),
          // AllStudentsScreen()
          // CreateGroupScreen(),
        ],
        onPageChanged: (index) {
          widget.currentIndex = index;
        },
      ),
      bottomNavigationBar: GNav(
        selectedIndex: widget.currentIndex,
        onTabChange: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
        backgroundColor: ColorsManager.lightShadeOfGray(context),
        tabBorderRadius: 12,
        gap: 8.w,
        color: ColorsManager.secondaryBlue(context),
        activeColor: ColorsManager.mainBlue(context),
        iconSize: 32.w,
        tabBackgroundColor: ColorsManager.mainBlue(context).withOpacity(0.2),
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
