import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:student/screens/profile/ui/profile_screen.dart';
import 'package:student/screens/settings/ui/settings_screen.dart';
import 'package:student/screens/student/ui/join_screen/ui/join_group_screen.dart';
import 'package:student/screens/student/ui/groups_screen/ui/student_groups_screen.dart';
import 'package:student/theming/colors.dart';

class StudentNavigator extends StatefulWidget {
  late int currentIndex;

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
        children: const [
          JoinCourseScreen(),
          StudentGroupsScreen(),
          ProfileScreen(),
          SettingsScreen(),
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
