import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/core/widgets/classes/group.dart';
import 'package:student/screens/teacher/ui/groups_screen/widgets/teacher_group_component.dart';
import 'package:student/theming/colors.dart';

class TeacherGroupsScreen extends StatefulWidget {
  const TeacherGroupsScreen({Key? key}) : super(key: key);

  @override
  State<TeacherGroupsScreen> createState() => _TeacherGroupsScreenState();
}

class _TeacherGroupsScreenState extends State<TeacherGroupsScreen> {
  final String teacherId = FirebaseAuth.instance.currentUser!.uid;
  late List<Group> teacherGroups;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTeacherGroups();
  }

  Future<void> _fetchTeacherGroups() async {
    setState(() {
      isLoading = true;
    });
    teacherGroups = await FireStoreFunctions.fetchTeacherGroups(teacherId);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshTeacherGroups() async {
    await _fetchTeacherGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'مجموعاتي', isTeacher: true),
      body: RefreshIndicator(
        onRefresh: _refreshTeacherGroups,
        child: Container(
          color: ColorsManager.white(context).withOpacity(0.92),
          child: isLoading
              ? Center(
                  child: LoadingAnimationWidget.bouncingBall(
                    color: ColorsManager.mainBlue(context),
                    size: 90,
                  ),
                )
              : teacherGroups.isEmpty
                  ? Center(
                      child: Text(
                        "لا توجد مجموعات",
                        style: TextStyle(color: ColorsManager.black(context)),
                      ),
                    )
                  : ListView.builder(
                      itemCount: teacherGroups.length,
                      itemBuilder: (context, index) {
                        final group = teacherGroups[index];
                        return TeacherGroupComponent(
                          teacherId: teacherId,
                          group: group,
                        );
                      },

                      // kjkdjlkafjlksjl
                      // fdjajldfkjalkjdfla
                    ),
        ),
      ),
    );
  }
}
