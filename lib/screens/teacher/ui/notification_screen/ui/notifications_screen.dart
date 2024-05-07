import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/core/widgets/classes/requests.dart';
import 'package:student/core/widgets/classes/user.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/screens/teacher/ui/notification_screen/widgets/notifcation_component.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class TeacherNotificationsScreen extends StatefulWidget {
  TeacherNotificationsScreen({Key? key}) : super(key: key);

  @override
  State<TeacherNotificationsScreen> createState() =>
      _TeacherNotificationsScreenState();
}

class _TeacherNotificationsScreenState
    extends State<TeacherNotificationsScreen> {
  final String teacherId = FirebaseAuth.instance.currentUser!.uid;

  late List<Request> requests;
  late List<AppUser> user;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTeacherRequests();
  }

  Future<void> _fetchTeacherRequests() async {
    setState(() {
      isLoading = true;
    });
    requests = await FireStoreFunctions.fetchTeacherRequests(teacherId);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshTeacherRequests() async {
    await _fetchTeacherRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "الاشعارات",
          style: TextStyles.font18DarkBlue700Weight,
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: RefreshIndicator(
          onRefresh: _refreshTeacherRequests,
          child: Container(
            child: isLoading
                ? RefreshIndicator(
                    onRefresh: _refreshTeacherRequests,
                    child: Center(
                      child: LoadingAnimationWidget.bouncingBall(
                        color: ColorsManager.mainBlue(context),
                        size: 90,
                      ),
                    ),
                  )
                : requests.isEmpty
                    ? Center(
                        child: Text(
                          "لا توجد طلبات",
                          style: TextStyle(color: ColorsManager.black(context)),
                        ),
                      )
                    : ListView.builder(
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          final request = requests[index];
                          return NotifcationComponent(
                            request: request,
                          );
                        },
                      ),
          ),
        ),
      ),
    );
  }
}