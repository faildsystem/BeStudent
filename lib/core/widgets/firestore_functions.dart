import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../helpers/app_regex.dart';
import '../classes/group.dart';
import '../classes/student.dart';
import '../classes/user.dart';

class FireStoreFunctions {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static Future<void> addUser(
      bool isTeacher,
      String id,
      String firstName,
      String lastName,
      String dob,
      String email,
      String phone,
      String address,
      String imageUrl) {
    return _firestore
        .collection('users')
        .add({
          'id': id,
          'firstName': firstName,
          'lastName': lastName,
          'birthDate': dob,
          'email': email,
          'phone': phone,
          'address': address,
          'imageUrl': imageUrl,
          'type': isTeacher ? 'teacher' : 'student',
        })
        .then((value) => log("User Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }

  static Future<int> deleteUserAndMoveData(String userId) async {
    try {
      log('Starting deletion process for user: $userId');
      return await _firestore.runTransaction((transaction) async {
        // Fetch user document
        log('Fetching user document...');
        final querySnapshot = await _firestore
            .collection('users')
            .where('id', isEqualTo: userId)
            .get();
        final docId = querySnapshot.docs.first.id;

        final userDocSnapshot = await transaction.get(
          _firestore.collection('users').doc(docId),
        );

        if (!userDocSnapshot.exists) {
          log('User not found: $userId');
          return 0; // User not found
        }
        final userData = userDocSnapshot.data();
        log('User data fetched: $userData');

        if (userData?['type'] == 'teacher') {
          log('User is a teacher. Fetching related data...');
          // Fetch related data for teacher
          final groupSnapshot = await _firestore
              .collection('group')
              .where('creatorId', isEqualTo: userId)
              .get();

          final groups = groupSnapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList();
          log('Groups fetched: ${groups.length} groups found.');

          final notificationSnapshot = await _firestore
              .collection('notifications')
              .where('receiverId', isEqualTo: userId)
              .get();

          final notifications = notificationSnapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList();
          log('Notifications fetched: ${notifications.length} notifications found.');

          List<Map<String, dynamic>> attendance = [];
          if (groups.isNotEmpty) {
            final attendanceSnapshot = await _firestore
                .collection('attendance')
                .where('groupId',
                    whereIn: groups.map((group) => group['id']).toList())
                .get();

            attendance = attendanceSnapshot.docs
                .map((doc) => {'id': doc.id, ...doc.data()})
                .toList();
            log('Attendance records fetched: ${attendance.length} records found.');
          } else {
            log('No groups found, skipping attendance fetch.');
          }

          // Create deleted teacher document
          final deletedTeacherData = {
            'userData': userData,
            'groups': groups,
            'attendance': attendance,
            'notifications': notifications,
            'deletionDate': Timestamp.now(),
          };

          final deletedTeacherRef = _firestore
              .collection('deleted_users')
              .doc('teacher')
              .collection('teachers')
              .doc(userId);
          log('Saving deleted teacher data...');
          transaction.set(deletedTeacherRef, deletedTeacherData);

          // Step 5: Delete user and related data
          log('Deleting user data from original collections...');
          transaction.delete(userDocSnapshot.reference);

          for (var group in groups) {
            log("Deleting group: ${group['id']}");
            final groupRef = _firestore.collection('group').doc(group['id']);
            transaction.delete(groupRef);
          }

          for (var notification in notifications) {
            log("Deleting notification: ${notification['id']}");
            final notificationRef =
                _firestore.collection('notifications').doc(notification['id']);
            transaction.delete(notificationRef);
          }

          for (var attendanceDoc in attendance) {
            log("Deleting attendance record: ${attendanceDoc['id']}");
            final attendanceRef =
                _firestore.collection('attendance').doc(attendanceDoc['id']);
            transaction.delete(attendanceRef);
          }

          log('Attempting to delete user from Firebase Authentication...');
          final user = _auth.currentUser;
          if (user != null) {
            await user.delete();
            log('User successfully deleted from Firebase Auth.');
            return 1; // Success
          } else {
            log('User not found in Firebase Auth.');
            return -1; // User not found in Auth
          }
        } else {
          log('User is a student. Fetching related data...');
          // Handle the student case

          // Fetch related data for student
          final enrollmentSnapshot = await _firestore
              .collection('enrollment')
              .where('studentId', isEqualTo: userId)
              .get();

          final enrollments = enrollmentSnapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList();
          log('Enrollments fetched: ${enrollments.length} enrollments found.');

          final notificationSnapshot = await _firestore
              .collection('notifications')
              .where('senderId', isEqualTo: userId)
              .get();

          final notifications = notificationSnapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList();
          log('Notifications fetched: ${notifications.length} notifications found.');

          // Create deleted student document
          final deletedStudentData = {
            'userData': userData,
            'enrollments': enrollments,
            'notifications': notifications,
            'deletionDate': Timestamp.now(),
          };

          final deletedStudentRef = _firestore
              .collection('deleted_users')
              .doc('student')
              .collection('students')
              .doc(userId);
          log('Saving deleted student data...');
          transaction.set(deletedStudentRef, deletedStudentData);

          // Delete user and related data
          log('Deleting user data from original collections...');
          transaction.delete(userDocSnapshot.reference);

          for (var enrollment in enrollments) {
            log("Deleting enrollment: ${enrollment['id']}");
            final enrollmentRef =
                _firestore.collection('enrollment').doc(enrollment['id']);
            transaction.delete(enrollmentRef);
          }

          for (var notification in notifications) {
            log("Deleting notification: ${notification['id']}");
            final notificationRef =
                _firestore.collection('notifications').doc(notification['id']);
            transaction.delete(notificationRef);
          }

          log('Attempting to delete user from Firebase Authentication...');
          final user = _auth.currentUser;
          if (user != null) {
            await user.delete();
            log('User successfully deleted from Firebase Auth.');
            return 1; // Success
          } else {
            log('User not found in Firebase Auth.');
            return -1; // User not found in Auth
          }
        }
      });
    } catch (error) {
      log('Transaction failed: $error');
      return -2; // Transaction failed
    }
  }

  static Future<void> updateUser(String id,
      {String? firstName,
      String? lastName,
      String? dob,
      String? phone,
      String? address,
      String? studyYear,
      String? imageUrl}) async {
    try {
      final doc = await getDoc(collection: 'users', field: 'id', value: id);
      final docId = doc?.id;
      if (docId != null) {
        Map<String, dynamic> updatedData = {
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          if (dob != null) 'birthDate': dob,
          if (phone != null) 'phone': phone,
          if (address != null) 'address': address,
          if (studyYear != null) 'studyYear': studyYear,
          if (imageUrl != null) 'imageUrl': imageUrl,
        };
        await _firestore.collection('users').doc(docId).update(updatedData);
        log("User Updated");
      } else {
        log("User with ID $id not found.");
      }
    } catch (error) {
      log("Failed to update user: $error");
    }
  }

  static Future<QueryDocumentSnapshot<Object?>?> getDoc({
    required String collection,
    required String field,
    required var value,
  }) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .where(field, isEqualTo: value)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<int> enrollGroup({
    required String userId,
    required String groupId,
  }) async {
    try {
      // if (groupId == null) {
      //   return -1;
      // }

      // Check if a document with the same code and student_id exists
      final querySnapshot = await _firestore
          .collection('enrollment')
          .where('groupId', isEqualTo: groupId)
          .where('studentId', isEqualTo: userId)
          .get();

      // check if student already enrolled in this group
      if (querySnapshot.docs.isNotEmpty) {
        log("Document with student ID $userId already exists.");
        return 0;
      }

      await _firestore.collection('enrollment').add({
        'groupId': groupId,
        'studentId': userId,
        'joinedDate': Timestamp.now(),
      });
      return 1;
    } catch (error) {
      log("Failed to send group join request: $error");
      return -1;
    }
  }

  static Future<AppUser> fetchUser(String userId) async {
    final userDocumentSnapshot = await _firestore
        .collection('users')
        .where('id', isEqualTo: userId)
        .get();
    final userDocumentData = userDocumentSnapshot.docs.first.data();
    return AppUser(
      id: userDocumentData['id'],
      firstName: userDocumentData['firstName'],
      lastName: userDocumentData['lastName'],
      email: userDocumentData['email'],
      type: userDocumentData['type'],
      phone: userDocumentData['phone'],
      address: userDocumentData['address'],
      birthDate: userDocumentData['birthDate'],
      image: userDocumentData['imageUrl'],
    );
  }

  static Future<List<Group>> fetchStudentGroups(String studentId) async {
    try {
      final enrollmentQuerySnapshot = await _firestore
          .collection('enrollment')
          .where('studentId', isEqualTo: studentId)
          .get();

      final List<Group> groups = [];

      for (final enrollmentDoc in enrollmentQuerySnapshot.docs) {
        final groupId = enrollmentDoc['groupId'];

        final groupDocumentSnapshot =
            await _firestore.collection('group').doc(groupId).get();
        if (!groupDocumentSnapshot.exists) {
          continue;
        }
        log("Group Document: ${groupDocumentSnapshot.data()}");

        final groupDocumentData = groupDocumentSnapshot.data();
        final String groupCode = groupDocumentData!['groupCode'];
        final String subjectName = groupDocumentData['subjectName'];
        final String teacherId = groupDocumentData['creatorId'];
        final String groupName = groupDocumentData['groupName'];
        // final String groupGrade = groupDocumentData['grade'];
        final String groupDay = groupDocumentData['day'];
        final String groupTime = groupDocumentData['time'];
        final Timestamp creationDate = groupDocumentData['creationDate'];
        final int duration = groupDocumentData['duration'];

        final teacherDocumentSnapshot = await _firestore
            .collection('users')
            .where('id', isEqualTo: teacherId)
            .get();
        final teacherDocumentData = teacherDocumentSnapshot.docs.first.data();
        final String teacherName =
            '${teacherDocumentData['firstName']} ${teacherDocumentData['lastName']}';
        final String teacherImage = teacherDocumentData['imageUrl'];

        groups.add(
          Group(
            subjectName: subjectName,
            groupId: groupId,
            teacherName: teacherName,
            teacherImage: teacherImage,
            groupCode: groupCode,
            groupName: groupName,
            // groupGrade: groupGrade,
            groupDay: groupDay,
            groupTime: groupTime,
            creationDate: creationDate,
            duration: duration,
          ),
        );
      }
      return groups;
    } catch (e) {
      return [];
    }
  }

  static Future<void> createGroup({
    required String teacherId,
    required String subjectName,
    required String groupName,
    // required String grade,
    required String day,
    required String time,
    required int duration,
  }) async {
    String code;
    bool codeExists = false;

    do {
      code = AppRegex.generateCode();

      QuerySnapshot querySnapshot = await _firestore
          .collection('group')
          .where('groupCode', isEqualTo: code)
          .get();

      codeExists = querySnapshot.docs.isNotEmpty;
    } while (codeExists);

    try {
      await _firestore.collection('group').add({
        'creatorId': teacherId,
        'creationDate': Timestamp.now(),
        'subjectName': subjectName,
        'groupCode': code,
        'groupName': groupName,
        // 'grade': grade,
        'day': day,
        'time': time,
        'duration': duration,
      });
      log("Group Created");
    } catch (error) {
      log("Failed to create group: $error");
    }
  }

  static Future<void> deleteGroup(String groupId) async {
    try {
      await _firestore.collection('group').doc(groupId).delete();
      log("Group Deleted");
    } catch (error) {
      log("Failed to delete group: $error");
    }
  }

  static Future<List<Group>> fetchTeacherGroups(String teacherId) async {
    final List<Group> groups = [];
    final querySnapshot = await _firestore
        .collection('group')
        .where('creatorId', isEqualTo: teacherId)
        .get();
    for (final groupDoc in querySnapshot.docs) {
      final subjectName = groupDoc['subjectName'];
      final groupId = groupDoc.id;
      final groupCode = groupDoc['groupCode'];
      final String groupName = groupDoc['groupName'];
      // final String groupGrade = groupDoc['grade'];
      final String groupDay = groupDoc['day'];
      final String groupTime = groupDoc['time'];
      final Timestamp creationDate = groupDoc['creationDate'];
      final int duration = groupDoc['duration'];

      groups.add(
        Group(
          subjectName: subjectName,
          groupId: groupId,
          groupCode: groupCode,
          groupName: groupName,
          // groupGrade: groupGrade,
          teacherName: '',
          teacherImage: '',
          groupDay: groupDay,
          groupTime: groupTime,
          creationDate: creationDate,
          duration: duration,
        ),
      );
    }
    return groups;
  }

  static Future<void> unrollGroup(String studentId, String groupId) async {
    try {
      final enrollmentDoc = await _firestore
          .collection('enrollment')
          .where('studentId', isEqualTo: studentId)
          .where('groupId', isEqualTo: groupId)
          .get();
      if (enrollmentDoc.docs.isEmpty) {
        log("Document with code $groupId and student ID $studentId not found.");
      }

      await _firestore
          .collection('enrollment')
          .doc(enrollmentDoc.docs.first.id)
          .delete();

      final notifications = await _firestore
          .collection('notifications')
          .where('senderId', isEqualTo: studentId)
          .where('groupId', isEqualTo: groupId)
          .get();

      for (final notification in notifications.docs) {
        await _firestore
            .collection('notifications')
            .doc(notification.id)
            .delete();
      }
    } catch (error) {
      log("Failed to delete document: $error");
    }
  }

  static Future<List<Student>> fetchGroupStudents(String groupId) async {
    final List<Student> students = [];
    final enrollmentQuerySnapshot = await _firestore
        .collection('enrollment')
        .where('groupId', isEqualTo: groupId)
        .get();
    for (final enrollmentDoc in enrollmentQuerySnapshot.docs) {
      final studentId = enrollmentDoc['studentId'];
      final studentDocumentSnapshot = await _firestore
          .collection('users')
          .where('id', isEqualTo: studentId)
          .get();
      if (studentDocumentSnapshot.docs.isEmpty) {
        continue;
      }
      final studentDocumentData = studentDocumentSnapshot.docs.first.data();

      students.add(
        Student(
          id: studentId,
          fullName:
              '${studentDocumentData['firstName']} ${studentDocumentData['lastName']}',
          email: studentDocumentData['email'],
          // attendance: enrollmentDoc['attendance'],
        ),
      );
    }
    return students;
  }

  static Future<void> saveAttendance(
      List<String> presentStudents, String groupId) async {
    await _firestore.collection('attendance').add({
      'groupId': groupId,
      'students': presentStudents,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<int> sendJoinRequestNotification(
    String teacherId,
    String groupId,
    String studentId,
    String groupName,
  ) async {
    try {
      log("Checking for existing join requests");

      // Initial query without orderBy
      final querySnapshot = await _firestore
          .collection('notifications')
          .where('senderId', isEqualTo: studentId)
          .where('groupId', isEqualTo: groupId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final latestRequest = querySnapshot.docs.first;
        final status = latestRequest['status'];
        log("Found existing request with status: $status");

        if (status == 'pending') {
          return 0; // Indicates a pending request
        } else if (status == 'accepted') {
          return 2; // Indicates already accepted
        }
      }

      log("No existing requests found or last request not pending/accepted. Adding new request");
      await _firestore.collection('notifications').add({
        'receiverId': teacherId,
        'senderId': studentId,
        'groupId': groupId,
        'groupName': groupName,
        'type': 'join_request',
        'status': 'pending',
        'seen_by_sender': false,
        'seen_by_receiver': false,
        'timestamp': FieldValue.serverTimestamp(),
      });

      log("Join request successfully added");
      return 1; // Indicates successful request
    } catch (error) {
      log("Failed to send join request: $error");
      return -1; // Indicates an error
    }
  }

  static Future<void> updateNotificationStatus(
      String notificationId, String status) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'status': status,
    });
  }

  static Future<void> markTeacherNotificationAsSeen(
      String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'seen_by_receiver': true,
    });
  }

  static Future<void> markStudentNotificationAsSeen(
      String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'seen_by_sender': true,
    });
  }

  static Future<List<Map<String, String>>> fetchTeacherNotifications(
      String teacherId) async {
    final List<Map<String, String>> notifications = [];
    final querySnapshot = await _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: teacherId)
        .where('status', isEqualTo: 'pending')
        .get();
    log('Fetching notifications for teacher $teacherId');

    for (final notificationDoc in querySnapshot.docs) {
      final senderId = notificationDoc['senderId'];
      final groupId = notificationDoc['groupId'];
      final groupName = notificationDoc['groupName'];
      final type = notificationDoc['type'];
      final timestamp = notificationDoc['timestamp'].toDate().toString();

      final studentData = await FireStoreFunctions.getDoc(
          collection: 'users', field: 'id', value: senderId);

      notifications.add({
        'notificationId': notificationDoc.id,
        'senderId': senderId,
        'groupId': groupId,
        'groupName': groupName,
        'type': type,
        'timestamp': timestamp,
        'name': '${studentData!['firstName']} ${studentData['lastName']}',
        'image': studentData['imageUrl'],
      });
    }
    return notifications;
  }

  static Future<List<Map<String, String>>> fetchStudentNotifications(
      String studentId) async {
    final List<Map<String, String>> notifications = [];
    log('Fetching notifications for student $studentId');
    final querySnapshot = await _firestore
        .collection('notifications')
        .where('senderId', isEqualTo: studentId)
        .where('status', whereIn: ['accepted', 'rejected'])
        .where('seen_by_sender', isEqualTo: false)
        .get();

    for (final notificationDoc in querySnapshot.docs) {
      final receiverId = notificationDoc['receiverId'];
      final groupId = notificationDoc['groupId'];
      final groupName = notificationDoc['groupName'];
      final type = notificationDoc['type'];
      final status = notificationDoc['status'];
      final timestamp = notificationDoc['timestamp'].toDate().toString();

      final teacherData = await FireStoreFunctions.getDoc(
          collection: 'users', field: 'id', value: receiverId);

      notifications.add({
        'notificationId': notificationDoc.id,
        'receiverId': receiverId,
        'groupId': groupId,
        'groupName': groupName,
        'type': type,
        'status': status,
        'timestamp': timestamp,
        'name': '${teacherData!['firstName']} ${teacherData['lastName']}',
        'image': teacherData['imageUrl'],
      });
    }
    return notifications;
  }

  static Future<int> fetchTotalNumberOfStudentsInTeacherGroups(
      String teacherId) async {
    try {
      // Step 1: Fetch all groups created by the teacher
      final groupQuerySnapshot = await _firestore
          .collection('group')
          .where('creatorId', isEqualTo: teacherId)
          .get();

      final List<String> groupIds =
          groupQuerySnapshot.docs.map((doc) => doc.id).toList();

      if (groupIds.isEmpty) {
        return 0; // No groups found for this teacher
      }

      // Step 2: Fetch all enrollments related to those groups
      final enrollmentQuerySnapshot = await _firestore
          .collection('enrollment')
          .where('groupId', whereIn: groupIds)
          .get();

      // The number of unique student IDs is the total number of students
      return enrollmentQuerySnapshot.size;
    } catch (error) {
      log("Failed to fetch total number of students: $error");
      return 0;
    }
  }

  static Future<DateTime> fetchTermEndDate() async {
    final termEndDate =
        await _firestore.collection('app-settings').doc('app-settings').get();
    return termEndDate['term-end-date'].toDate();
  }

  static Future<void> sendArabicVerificationEmail() async {
    try {
      // Set the language code to Arabic
      await FirebaseAuth.instance.setLanguageCode("ar");

      // Send the verification email
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      log("Verification email sent in Arabic.");
    } catch (e) {
      log("Failed to send verification email: $e");
    }
  }

  static Future<Map<String, dynamic>> fetchStudentProfile(
      String studentId) async {
    final studentDoc = await _firestore
        .collection('users')
        .where('id', isEqualTo: studentId)
        .get();
    if (studentDoc.docs.isEmpty) return {};

    final studentData = studentDoc.docs.first.data();
    return {
      'fullName': '${studentData['firstName']} ${studentData['lastName']}',
      'imageUrl': studentData['imageUrl'],
    };
  }

  static Future<Map<String, dynamic>> fetchStudentAttendance(
      String studentId) async {
    final querySnapshot = await _firestore
        .collection('attendance')
        .where('students', arrayContains: studentId)
        .get();

    final attendanceDates = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return data['timestamp'].toDate().toString();
    }).toList();

    return {
      'count': attendanceDates.length,
      'dates': attendanceDates,
    };
  }
}
