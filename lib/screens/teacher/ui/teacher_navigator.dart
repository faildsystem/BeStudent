import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:student/theming/colors.dart';

import '../../profile/widgets/avatar_name_email.dart';
import '../../settings/ui/settings_screen.dart';
import 'groups_screen/ui/teacher_groups_screen.dart';
import 'home_screen/ui/teacher_home_screen.dart';

// ignore: must_be_immutable
class TeacherNavigator extends StatefulWidget {
  late int currentIndex;

  TeacherNavigator({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _TeacherNavigatorState createState() => _TeacherNavigatorState();
}

class _TeacherNavigatorState extends State<TeacherNavigator> {
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
          TeacherHomeScreen(),
          TeacherGroupsScreen(),
          ProfileAvatar(),
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
            duration: const Duration(milliseconds: 200),
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
