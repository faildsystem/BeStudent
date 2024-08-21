import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import '../../../../../core/classes/days.dart';
import '../../../../../core/classes/group.dart';
import '../../../../../core/classes/time.dart';
import '../../../../../theming/colors.dart';
import '../../../../../theming/styles.dart';
import '../stats.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  _TeacherDashboardScreenState createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  late Future<void> _initializeCacheFuture;
  late Future<List<Group>> _groupsFuture;

  final String currentTeacherId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    // Reset the StatisticsCache before initializing it again
    StatisticsCache().reset();
    setState(() {
      _initializeCacheFuture = StatisticsCache().initialize(currentTeacherId);
      _groupsFuture = FireStoreFunctions.fetchTeacherGroups(currentTeacherId);
    });
  }

  Future<List<Group>> _fetchUpcomingAppointments(List<Group> groups) async {
    try {
      DateTime now = DateTime.now();
      String currentDay = _getDayAbbreviation(now.weekday);
      TimeOfDay currentTime = TimeOfDay.fromDateTime(now);

      return groups.where((group) {
        final groupDay = group.groupDay; // Day abbreviation ('SU', 'MO', etc.)
        final groupTime =
            _parseTimeOfDay(group.groupTime); // Convert to TimeOfDay

        // Compare day and time
        return groupDay == currentDay &&
            (groupTime.hour > currentTime.hour ||
                (groupTime.hour == currentTime.hour &&
                    groupTime.minute > currentTime.minute));
      }).toList();
    } catch (e) {
      log('Error filtering upcoming appointments: $e');
      return [];
    }
  }

  String _getDayAbbreviation(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'MO';
      case DateTime.tuesday:
        return 'TU';
      case DateTime.wednesday:
        return 'WE';
      case DateTime.thursday:
        return 'TH';
      case DateTime.friday:
        return 'FR';
      case DateTime.saturday:
        return 'SA';
      case DateTime.sunday:
        return 'SU';
      default:
        return '';
    }
  }

  TimeOfDay _parseTimeOfDay(String time) {
    final timeParts = time.split(' ');
    final timeString = timeParts[0];
    final period = timeParts[1];

    final timeComponents = timeString.split(':');
    final hour = int.parse(timeComponents[0]);
    final minute = int.parse(timeComponents[1]);

    final adjustedHour = period == 'PM' && hour != 12
        ? hour + 12
        : (period == 'AM' && hour == 12 ? 0 : hour);

    return TimeOfDay(hour: adjustedHour, minute: minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "الرئيسية",
        isTeacher: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<void>(
          future: _initializeCacheFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('خطأ: ${snapshot.error}',
                      style: TextStyles.font14Grey400Weight));
            } else {
              // Access cached data
              final statistics = StatisticsCache();

              return Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Statistics Section
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _StatCard(
                                title: 'المجموعات',
                                value: statistics.groupCount.toString()),
                            _StatCard(
                                title: 'الطلاب',
                                value: statistics.studentCount.toString()),
                            _StatCard(
                                title: 'الطلبات المعلقة',
                                value:
                                    statistics.pendingRequestsCount.toString()),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Upcoming Events
                      Row(children: [
                        Text('المجموعات القادمة',
                            style: TextStyles.font18DarkBlue700Weight),
                      ]),

                      const SizedBox(height: 10),
                      FutureBuilder<List<Group>>(
                        future: _groupsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('خطأ: ${snapshot.error}',
                                    style: TextStyles.font14Grey400Weight));
                          } else {
                            final groups = snapshot.data ?? [];
                            final upcomingAppointments =
                                _fetchUpcomingAppointments(groups);

                            return Expanded(
                              child: FutureBuilder<List<Group>>(
                                future: Future.value(upcomingAppointments),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child: Text('خطأ: ${snapshot.error}',
                                            style: TextStyles
                                                .font14Grey400Weight));
                                  } else {
                                    final appointments = snapshot.data ?? [];
                                    return ListView(
                                      children: appointments.map((group) {
                                        return _EventCard(
                                          date:
                                              '${Days.translateDayToArabic(group.groupDay)} ${FormatTimeToArabic.formatTimeToArabic(group.groupTime)}',
                                          title: group.groupName,
                                        );
                                      }).toList(),
                                    );
                                  }
                                },
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          children: [
            Text(title, style: TextStyles.font16Blue400Weight),
            Text(value,
                style: TextStyles.font24Blue700Weight.copyWith(
                  color: ColorsManager.mainBlue(context),
                )),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _QuickActionButton(
      {required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            icon: Icon(icon, color: ColorsManager.mainBlue(context)),
            onPressed: onPressed),
        Text(label,
            style: TextStyles.font14Blue400Weight, textAlign: TextAlign.center),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  final String date;
  final String title;

  const _EventCard({required this.date, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title,
            style: TextStyles.font18DarkBlue700Weight,
            textAlign: TextAlign.right),
        subtitle:
            Text(date, style: const TextStyle(), textAlign: TextAlign.right),
      ),
    );
  }
}
