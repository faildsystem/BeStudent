import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/screens/teacher/ui/home_screen/widgets/our_services_box.dart';
import 'package:student/screens/teacher/ui/home_screen/widgets/quick_updates.dart';
import 'package:student/theming/colors.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'الصفحة الرئيسية'),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10.h),
            width: double.infinity,
            height: 140.h,
            decoration: BoxDecoration(
              color: ColorsManager.mainBlue(context),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(1000),
                bottomRight: Radius.circular(1000),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 0.10,
                ),
              ],
            ),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Name: John Doe',
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'ID: 123456',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Button',
                    style: TextStyle(color: Colors.black, fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.h),
            width: double.infinity,
            height: 20.h,
            child: Text(
              'Quick Updates',
              style: TextStyle(fontSize: 17.sp),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 110.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                QuickUpdatesBox(imageUrl: 'assets/images/quiz.png'),
                QuickUpdatesBox(imageUrl: 'assets/images/quiz.png'),
                QuickUpdatesBox(imageUrl: 'assets/images/quiz.png'),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.34,
              width: MediaQuery.of(context).size.width * 0.95,
              margin: EdgeInsets.only(top: 10.h),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Icon(Icons.remove, size: 30.h, color: Colors.black),
                      Text('Our Services', style: TextStyle(fontSize: 18.h)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ServiceBox(
                              icon: Icons.menu_book_outlined,
                              title: 'الواجبات المنزلية',
                              color: ColorsManager.mainBlue(context)),
                          ServiceBox(
                              icon: Icons.menu_book_outlined,
                              title: 'الواجبات المنزلية',
                              color: ColorsManager.mainBlue(context)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ServiceBox(
                              icon: Icons.menu_book_outlined,
                              title: 'Homework',
                              color: ColorsManager.mainBlue(context)),
                          ServiceBox(
                              icon: Icons.menu_book_outlined,
                              title: 'Homework',
                              color: ColorsManager.mainBlue(context)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
