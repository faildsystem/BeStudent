import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student/theming/colors.dart';

class TeacherNotificationsScreen extends StatefulWidget {
  const TeacherNotificationsScreen({Key? key}) : super(key: key);

  @override
  _TeacherNotificationsScreenState createState() =>
      _TeacherNotificationsScreenState();
}

class _TeacherNotificationsScreenState
    extends State<TeacherNotificationsScreen> {
  final List<Map<String, String>> studentRequests = [
    {"name": "أحمد", "image": "assets/images/logo.jpg", "group": "مجموعة 1"},
    {"name": "أحمد", "image": "assets/images/logo.jpg", "group": "مجموعة 1"},
    {"name": "أحمد", "image": "assets/images/logo.jpg", "group": "مجموعة 1"},
    // Additional items...
    {"name": "فاطمة", "image": "assets/images/quiz.png", "group": "مجموعة 2"},
  ];

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
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: ListView.builder(
              itemCount: studentRequests.length,
              itemBuilder: (context, index) {
                final request = studentRequests[index];
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
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(request["image"]!),
                      ),
                      title: Text(
                        request["name"]!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("يريد الانضمام إلى ${request["group"]!}"),
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
                              Text('المجموعة: ${request["group"]!}'),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _showConfirmationDialog(
                                        context: context,
                                        title: 'تأكيد',
                                        content: 'هل أنت متأكد من قبول الطلب؟',
                                        onConfirm: () {
                                          // Handle confirmation logic
                                        },
                                      );
                                    },
                                    child: const Text('تأكيد'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showConfirmationDialog(
                                        context: context,
                                        title: 'تنبيه',
                                        content: 'هل أنت متأكد من رفض الطلب؟',
                                        onConfirm: () {
                                          // Handle decline logic
                                        },
                                      );
                                    },
                                    child: const Text('رفض'),
                                  ),
                                ],
                              ),
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

  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
}
