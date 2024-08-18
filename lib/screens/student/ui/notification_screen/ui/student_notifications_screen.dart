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
    // log('Notifications loading...');

    try {
      List<Map<String, String>> notificationsList =
          await FireStoreFunctions.fetchStudentNotifications(studentId);
      notificationsMap = {
        for (var notification in notificationsList)
          if (notification['seen'] != 'true')
            notification['notificationId']!: notification
      };
      // log('Notifications: $notificationsMap');
    } catch (e) {
      log('Error fetching notifications: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      isLoading = true;
    });
    await fetchNotifications();
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
            : RefreshIndicator(
                onRefresh: _refreshNotifications,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: ListView.builder(
                      itemCount: notificationsMap.length,
                      itemBuilder: (context, index) {
                        final notificationId =
                            notificationsMap.keys.elementAt(index);
                        final notification = notificationsMap[notificationId]!;

                        // Determine the icon, color, and status text based on the notification's status
                        IconData statusIcon;
                        Color iconColor;
                        String statusText;
                        TextStyle statusTextStyle = TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp,
                          color: ColorsManager.black(context),
                        );

                        if (notification['status'] == 'accepted') {
                          statusIcon = Icons.check_circle; // Accepted icon
                          iconColor = Colors.green;
                          statusText = 'تم قبول الطلب';
                          statusTextStyle = statusTextStyle.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          );
                        } else if (notification['status'] == 'rejected') {
                          statusIcon = Icons.cancel; // Rejected icon
                          iconColor = Colors.red;
                          statusText = 'تم رفض الطلب';
                          statusTextStyle = statusTextStyle.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          );
                        } else {
                          statusIcon = Icons.info; // Default info icon
                          iconColor = Colors.blue;
                          statusText = 'قيد الانتظار';
                        }

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
                              leading: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 25.r,
                                    backgroundImage: NetworkImage(
                                      notification['image'] ?? '',
                                    ),
                                    backgroundColor: Colors.grey[200],
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Icon(
                                      statusIcon,
                                      color: iconColor,
                                      size: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                'المعلم: ${notification["name"]!}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle:
                                  Text(statusText, style: statusTextStyle),
                              onExpansionChanged: (expanded) {
                                if (expanded) {
                                  FireStoreFunctions
                                      .markStudentNotificationAsSeen(
                                          notificationId);
                                }
                              },
                              childrenPadding: EdgeInsets.zero,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 10.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'تفاصيل الإشعار:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp),
                                      ),
                                      SizedBox(height: 10.h),
                                      _buildNotificationDetail(
                                          'المعلم', notification['name']),
                                      _buildNotificationDetail(
                                          'مجموعة', notification['groupName']),
                                      _buildNotificationDetail(
                                          'التاريخ',
                                          notification['timestamp']
                                                  ?.split(' ')
                                                  .first ??
                                              ''),
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
      ),
    );
  }

  Widget _buildNotificationDetail(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Text(
        '$label: ${value ?? "غير متوفر"}',
        style: TextStyle(fontSize: 14.sp),
      ),
    );
  }
}
