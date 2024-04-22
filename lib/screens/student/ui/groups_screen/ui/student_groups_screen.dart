import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/core/widgets/classes/group.dart';
import 'package:student/screens/student/ui/groups_screen/widgets/group_component.dart';
import 'package:student/theming/colors.dart';

class StudentCourseScreen extends StatefulWidget {
  const StudentCourseScreen({Key? key}) : super(key: key);

  @override
  State<StudentCourseScreen> createState() => _StudentCourseScreenState();
}

class _StudentCourseScreenState extends State<StudentCourseScreen> {
  final String studentId = FirebaseAuth.instance.currentUser!.uid;
  late Stream<List<Group>> studentGroupsStream =
      FireStoreFunctions.fetchStudentGroups(studentId);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'مجموعاتي'),
      body: Container(
        color: ColorsManager.white.withOpacity(0.92),
        child: StreamBuilder<List<Group>>(
          stream: studentGroupsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.bouncingBall(
                  color: ColorsManager.mainBlue,
                  size: 90,
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'حدث خطأ اثناء التحميل',
                  style: TextStyle(color: ColorsManager.kTextBlackColor),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text(
                "لا توجد مجموعات",
                style: TextStyle(color: ColorsManager.kTextBlackColor),
              ));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final group = snapshot.data![index];
                  return Padding(
                    padding: EdgeInsets.all(3.h),
                    child: GroupComponent(studentId: studentId, group: group),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
