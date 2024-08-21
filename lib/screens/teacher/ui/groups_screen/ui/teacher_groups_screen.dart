import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/core/widgets/app_text_form_field.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/core/classes/group.dart';
import 'package:student/theming/colors.dart';

import '../../create_group_screen/ui/create_course_screen.dart';
import '../widgets/teacher_group_component.dart';

class TeacherGroupsScreen extends StatefulWidget {
  const TeacherGroupsScreen({Key? key}) : super(key: key);

  @override
  State<TeacherGroupsScreen> createState() => _TeacherGroupsScreenState();
}

class _TeacherGroupsScreenState extends State<TeacherGroupsScreen> {
  final String teacherId = FirebaseAuth.instance.currentUser!.uid;
  late List<Group> teacherGroups;
  late List<Group> filteredGroups;
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTeacherGroups();
    searchController.addListener(_filterGroups);
  }

  Future<void> _fetchTeacherGroups() async {
    setState(() {
      isLoading = true;
    });
    teacherGroups = await FireStoreFunctions.fetchTeacherGroups(teacherId);
    filteredGroups = teacherGroups;
    setState(() {
      isLoading = false;
    });
  }

  void _filterGroups() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredGroups = teacherGroups.where((group) {
        return group.groupName.toLowerCase().contains(query) ||
            group.subjectName.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _refreshTeacherGroups() async {
    await _fetchTeacherGroups();
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const CreateGroupScreen();
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'مجموعاتي', isTeacher: true),
      body: RefreshIndicator(
        onRefresh: _refreshTeacherGroups,
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
                    child: AppTextFormField(
                      controller: searchController,
                      hint: 'ابحث عن مجموعة',
                      suffixIcon: const Icon(Icons.search),
                      validator: (value) => {},
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
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: _fetchTeacherGroups,
                                  child: Text(
                                    "إعادة تحميل",
                                    style: TextStyle(
                                        color: ColorsManager.mainBlue(context),
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredGroups.length,
                            itemBuilder: (context, index) {
                              final group = filteredGroups[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Material(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(12),
                                  child: TeacherGroupComponent(
                                    teacherId: teacherId,
                                    group: group,
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateGroupDialog,
        backgroundColor: ColorsManager.mainBlue(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
