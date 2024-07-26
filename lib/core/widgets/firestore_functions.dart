import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/core/classes/group.dart';
import 'package:student/core/classes/user.dart';
import 'package:student/helpers/app_regex.dart';

import '../classes/student.dart';

class FireStoreFunctions {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  static Future<void> updateUser(String id,
      {String? firstName,
      String? lastName,
      String? dob,
      String? phone,
      String? address,
      String? studyYear,
      String? imageUrl}) async {
    try {
      final docId = await getDocId(collection: 'users', field: 'id', value: id);
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

  static Future<String?> getDocId({
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
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<int> groupJoinRequest({
    required String userId,
    required String code,
    required String? groupId,
  }) async {
    try {
      if (groupId == null) {
        log("Group $code not found.");
        return -1;
      }

      // Check if a document with the same code and student_id exists
      final querySnapshot = await _firestore
          .collection('enrollment')
          .where('groupId', isEqualTo: groupId)
          .where('studentId', isEqualTo: userId)
          .get();

      // check if student already enrolled in this group
      if (querySnapshot.docs.isNotEmpty) {
        log("Document with code $code and student ID $userId already exists.");
        return 0;
      }

      await _firestore.collection('enrollment').add({
        'groupId': groupId,
        'groupCode': code,
        'studentId': userId,
        'joinedDate': Timestamp.now(),
      });
      log("Added Data with ID: $code");
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
    final enrollmentQuerySnapshot = await _firestore
        .collection('enrollment')
        .where('studentId', isEqualTo: studentId)
        .get();
    final List<Group> groups = [];

    for (final enrollmentDoc in enrollmentQuerySnapshot.docs) {
      final groupId = enrollmentDoc['groupId'];

      final groupDocumentSnapshot =
          await _firestore.collection('group').doc(groupId).get();

      final groupDocumentData = groupDocumentSnapshot.data();
      final String groupCode = groupDocumentData!['groupCode'];
      final String subjectName = groupDocumentData['subjectName'];
      final String teacherId = groupDocumentData['creatorId'];
      final String groupName = groupDocumentData['groupName'];
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
          groupDay: groupDay,
          groupTime: groupTime,
          creationDate: creationDate,
          duration: duration,
        ),
      );
    }
    return groups;
  }

  static Future<void> createGroup({
    required String teacherId,
    required String subjectName,
    required String groupName,
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
        'day': day,
        'time': time,
        'duration': duration,
      });
      log("Group Created");
    } catch (error) {
      log("Failed to create group: $error");
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
      final studentDocumentData = studentDocumentSnapshot.docs.first.data();

      students.add(
        Student(
          id: studentId,
          fullName:
              '${studentDocumentData['firstName']} ${studentDocumentData['lastName']}',
          email: studentDocumentData['email'],
          attendance: enrollmentDoc['attendance'],
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

  static Future<void> sendJoinRequestNotification(String teacherId,
      String groupId, String studentId, String groupName) async {
    await _firestore.collection('notifications').add({
      'receiverId': teacherId,
      'senderId': studentId,
      'groupId': groupId,
      'groupName': groupName,
      'type': 'join_request',
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> sendJoinResponseNotification(
      String studentId, String groupId, String groupName, bool accepted) async {
    await _firestore.collection('notifications').add({
      'receiverId': studentId,
      'groupId': groupId,
      'groupName': groupName,
      'type': 'join_response',
      'status': accepted ? 'accepted' : 'rejected',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> updateNotificationStatus(
      String notificationId, String status) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'status': status,
    });
  }

  static Future<void> updateUserToken(String userId, String token) async {
    await _firestore.collection('users').doc(userId).update({
      'fcmToken': token,
    });
  }

  static Future<void> handleJoinRequest(
      String notificationId, bool accepted) async {
    final notification =
        await _firestore.collection('notifications').doc(notificationId).get();
    final studentId = notification['senderId'];
    final groupId = notification['groupId'];
    final groupName = notification['groupName'];

    if (accepted) {
      // Add student to the group
      await _firestore.collection('groups').doc(groupId).update({
        'students': FieldValue.arrayUnion([studentId]),
      });
    }

    // Update notification status
    await updateNotificationStatus(
        notificationId, accepted ? 'accepted' : 'rejected');

    // Notify the student
    await sendJoinResponseNotification(studentId, groupId, groupName, accepted);
  }
}
