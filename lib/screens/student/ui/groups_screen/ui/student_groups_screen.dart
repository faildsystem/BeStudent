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
  late List<Group> filteredGroups;
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStudentGroups();
    searchController.addListener(_filterGroups);
  }

  Future<void> _fetchStudentGroups() async {
    setState(() {
      isLoading = true;
    });
    studentGroups = await FireStoreFunctions.fetchStudentGroups(studentId);
    filteredGroups = studentGroups;
    setState(() {
      isLoading = false;
    });
  }

  void _filterGroups() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredGroups = studentGroups.where((group) {
        return group.groupName.toLowerCase().contains(query) ||
            group.subjectName.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _refreshStudentGroups() async {
    await _fetchStudentGroups();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'مجموعاتي'),
      body: RefreshIndicator(
        onRefresh: _refreshStudentGroups,
        child: Container(
          color: ColorsManager.white(context).withOpacity(0.92),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(12),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ابحث عن مجموعة',
                        suffixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16.0),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: isLoading
                    ? Center(
                        child: LoadingAnimationWidget.bouncingBall(
                          color: ColorsManager.mainBlue(context),
                          size: 90,
                        ),
                      )
                    : filteredGroups.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.group_off,
                                  color: ColorsManager.mainBlue(context),
                                  size: 100,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "لا توجد مجموعات",
                                  style: TextStyle(
                                      color: ColorsManager.black(context),
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredGroups.length,
                            itemBuilder: (context, index) {
                              final group = filteredGroups[index];
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
            ],
          ),
        ),
      ),
    );
  }
}
