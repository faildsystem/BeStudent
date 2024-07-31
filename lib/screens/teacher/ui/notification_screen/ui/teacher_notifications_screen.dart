import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/theming/colors.dart';

class TeacherNotificationsScreen extends StatefulWidget {
  TeacherNotificationsScreen({Key? key}) : super(key: key);

  @override
  _TeacherNotificationsScreenState createState() =>
      _TeacherNotificationsScreenState();
}

class _TeacherNotificationsScreenState
    extends State<TeacherNotificationsScreen> {
  Map<String, Map<String, String>> notificationsMap = {};
  bool isLoading = true;
  late String teacherId;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      teacherId = currentUser.uid;
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
      List<Map<String, String>> notificationsList =
          await FireStoreFunctions.fetchTeacherNotifications(teacherId);
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

  Future<void> handleAcceptRequest(String notificationId) async {
    await FireStoreFunctions.updateNotificationStatus(
        notificationId, 'accepted');
    setState(() {
      notificationsMap[notificationId]!['status'] = 'accepted';
    });
  }

  Future<void> handleRejectRequest(String notificationId) async {
    await FireStoreFunctions.updateNotificationStatus(
        notificationId, 'rejected');
    setState(() {
      notificationsMap[notificationId]!['status'] = 'rejected';
    });
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
            ? Center(child: CircularProgressIndicator())
            : Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: ListView.builder(
                    itemCount: notificationsMap.length,
                    itemBuilder: (context, index) {
                      final notificationId =
                          notificationsMap.keys.elementAt(index);
                      final request = notificationsMap[notificationId]!;
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
                            leading: CircleAvatar(
                              backgroundImage: request['image'] != ""
                                  ? NetworkImage(request["image"]!)
                                  : null,
                            ),
                            title: Text(
                              request["name"]!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                "يريد الانضمام إلى ${request["groupName"]!}"),
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
                                      'تفاصيل الطالب:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text('اسم الطالب: ${request["name"]!}'),
                                    Text('المجموعة: ${request["groupName"]!}'),
                                    SizedBox(height: 20.h),
                                    if (request['status'] == null) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              handleAcceptRequest(
                                                  notificationId);
                                            },
                                            icon: Icon(Icons.check),
                                            label: const Text('تأكيد'),
                                            style: ElevatedButton.styleFrom(),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              handleRejectRequest(
                                                  notificationId);
                                            },
                                            icon: Icon(Icons.close),
                                            label: const Text('رفض'),
                                            style: ElevatedButton.styleFrom(),
                                          ),
                                        ],
                                      ),
                                    ] else ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            request['status'] == 'accepted'
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            color:
                                                request['status'] == 'accepted'
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            request['status'] == 'accepted'
                                                ? 'تم قبول الطلب'
                                                : 'تم رفض الطلب',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: request['status'] ==
                                                      'accepted'
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
