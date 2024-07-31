import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/theming/colors.dart';

class StudentNotificationsScreen extends StatefulWidget {
  const StudentNotificationsScreen({Key? key}) : super(key: key);

  @override
  _StudentNotificationsScreenState createState() =>
      _StudentNotificationsScreenState();
}

class _StudentNotificationsScreenState
    extends State<StudentNotificationsScreen> {
  Map<String, Map<String, String>> notificationsMap = {};
  bool isLoading = true;
  late String studentId;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      studentId = currentUser.uid;
      fetchNotifications();
    } else {
      log('User is not authenticated');
      setState(() {
        isLoading = false;
      });
      // Handle the unauthenticated state, e.g., navigate to the login screen
    }
  }

  Future<void> fetchNotifications() async {
    log('Notifications loading...');

    try {
      log('jfdalsj ');
      List<Map<String, String>> notificationsList =
          await FireStoreFunctions.fetchStudentNotifications(
              'Y4sgYMbZpxQLSZJFxA6kUHDrPx13');
      notificationsMap = {
        for (var notification in notificationsList)
          notification['notificationId']!: notification
      };
      log('Notifications: $notificationsMap');
    } catch (e) {
      log('Error fetching notifications: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'الإشعارات',
            style: TextStyle(
              color: ColorsManager.black(context),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: ColorsManager.white(context),
          elevation: 0,
        ),
        backgroundColor: ColorsManager.white(context),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: ListView.builder(
                    itemCount: notificationsMap.length,
                    itemBuilder: (context, index) {
                      final notificationId =
                          notificationsMap.keys.elementAt(index);
                      final notification = notificationsMap[notificationId]!;
                      return Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        decoration: BoxDecoration(
                          color: ColorsManager.white(context),
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            leading: const Icon(
                              Icons.notification_important,
                            ),
                            title: Text(
                              notification["title"]!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(notification["body"]!),
                            onExpansionChanged: (expanded) {
                              if (expanded) {
                                FireStoreFunctions.notificationSeen(
                                    notificationId);
                              }
                            },
                            childrenPadding: EdgeInsets.zero,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 10.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'تفاصيل الإشعار:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text('العنوان: ${notification["title"]!}'),
                                    Text('المحتوى: ${notification["body"]!}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
