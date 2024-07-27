import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/core/classes/group.dart';
import 'package:student/theming/colors.dart';

import '../widgets/student_group_component.dart';

class StudentGroupsScreen extends StatefulWidget {
  const StudentGroupsScreen({Key? key}) : super(key: key);

  @override
  State<StudentGroupsScreen> createState() => _StudentGroupsScreenState();
}

class _StudentGroupsScreenState extends State<StudentGroupsScreen> {
  final String studentId = FirebaseAuth.instance.currentUser!.uid;
  late List<Group> studentGroups;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStudentGroups();
  }

  Future<void> _fetchStudentGroups() async {
    setState(() {
      isLoading = true;
    });
    studentGroups = await FireStoreFunctions.fetchStudentGroups(studentId);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshStudentGroups() async {
    await _fetchStudentGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'مجموعاتي'),
      body: RefreshIndicator(
        onRefresh: _refreshStudentGroups,
        child: Container(
          color: ColorsManager.white(context).withOpacity(0.92),
          child: isLoading
              ? Center(
                  child: LoadingAnimationWidget.bouncingBall(
                    color: ColorsManager.mainBlue(context),
                    size: 90,
                  ),
                )
              : studentGroups.isEmpty
                  ? Center(
                      child: Text(
                        "لا توجد مجموعات",
                        style: TextStyle(color: ColorsManager.black(context)),
                      ),
                    )
                  : ListView.builder(
                      itemCount: studentGroups.length,
                      itemBuilder: (context, index) {
                        final group = studentGroups[index];
                        return Padding(
                          padding: EdgeInsets.all(3.h),
                          child: StudentGroupComponent(
                            studentId: studentId,
                            group: group,
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
