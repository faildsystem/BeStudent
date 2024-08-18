import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/widgets/firestore_functions.dart';

class StatisticsCache {
  static final StatisticsCache _instance = StatisticsCache._internal();

  factory StatisticsCache() => _instance;

  StatisticsCache._internal();

  int groupCount = 0;
  int studentCount = 0;
  int pendingRequestsCount = 0;

  bool isInitialized = false;

  Future<void> initialize(String teacherId) async {
    if (!isInitialized) {
      try {
        // Fetch the number of groups for the current teacher
        QuerySnapshot groupSnapshot = await FirebaseFirestore.instance
            .collection('group')
            .where('creatorId', isEqualTo: teacherId)
            .get();
        groupCount = groupSnapshot.size;

        // Fetch the number of students for the current teacher
        studentCount =
            await FireStoreFunctions.fetchTotalNumberOfStudentsInTeacherGroups(
                teacherId);

        // Fetch the number of pending requests for the current teacher
        // Fetch the number of pending requests for the current teacher
        QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
            .collection('notifications')
            .where('receiverId', isEqualTo: teacherId)
            .where('status', isEqualTo: 'pending')
            .get();
        pendingRequestsCount = requestSnapshot.size;
        isInitialized = true;
      } catch (e) {
        log('Error initializing statistics: $e');
      }
    }
  }

  void reset() {
    groupCount = 0;
    studentCount = 0;
    pendingRequestsCount = 0;
    isInitialized = false;
  }
}
