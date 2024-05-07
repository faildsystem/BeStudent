import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/core/widgets/classes/group.dart';
import 'package:student/core/widgets/classes/requests.dart';
import 'package:student/core/widgets/classes/user.dart';
import 'package:student/helpers/app_regex.dart';

import 'classes/student.dart';

class FireStoreFunctions {
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
    return FirebaseFirestore.instance
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
        await FirebaseFirestore.instance
            .collection('users')
            .doc(docId)
            .update(updatedData);
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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
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
  
  static Future<void> enrollStudent({
    required String userId,
    required String code,
    required String groupId,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('enrollment').add({
        'groupId': groupId,
        'groupCode': code,
        'studentId': userId,
        'joinedDate': Timestamp.now(),
      });
      log("Student enrolled in group $groupId");

    } catch (error) {
      log("Failed to enroll student: $error");
    }
  }

  static Future<void> deleteRequestStatus(String requestId) async {
    try {
      await FirebaseFirestore.instance.collection('requests').doc(requestId).delete();
      log("Request deleted");
    } catch (error) {
      log("Failed to delete request: $error");
    }
  }

  static Future<int> sendJoinRequest({
    required String userId,
    required String? groupId,
  }) async {
    try {
      if (groupId == null) {
        log("Group $groupId not found.");
        return -1;
      }

      // check if student already enrolled in this group
      final querySnapshot = await FirebaseFirestore.instance
          .collection('enrollment')
          .where('groupId', isEqualTo: groupId)
          .where('studentId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        log("Document with code $groupId and student ID $userId already exists.");
        return 0;
      }

      // Check if a request with the same code and student_id exists
      final requestQuerySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('groupId', isEqualTo: groupId)
          .where('studentId', isEqualTo: userId)
          .get();

      // check if student already sent a request to join this group
      if (requestQuerySnapshot.docs.isNotEmpty) {
        log("Request with code $groupId and student ID $userId already exists.");
        return 0;
      } 

      // get the teacher id
      final groupDoc = await FirebaseFirestore.instance.collection('group').doc(groupId).get();
      final teacherId = groupDoc['creatorId'];

      await FirebaseFirestore.instance.collection('requests').add({
        'studentId': userId,
        'groupId': groupId,
        'teacherId': teacherId,
        'requestDate': Timestamp.now(),
        'status': 'pending',
      });
      log('Request sent');
      return 1;
    } catch (error) {
      log("Failed to send group join request: $error");
      return -1;
    }
  }
  
 static Future<List<Request>> fetchTeacherRequests(String teacherId) async {
    final List<Request> requests = [];
    final querySnapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('teacherId', isEqualTo: teacherId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (querySnapshot.docs.isEmpty) {
      log("No requests found.");
      return requests;
    }

    for (final requestDoc in querySnapshot.docs) {
      final studentId = requestDoc['studentId'];
      final groupId = requestDoc['groupId'];
      final requestDate = requestDoc['requestDate'];
      final status = requestDoc['status'];

      final student = await fetchUser(studentId);
      final group = await fetchGroup(groupId);

      requests.add(
        Request(
          requestId: requestDoc.id,
          student: student,
          group: group,
          date: requestDate,
          status: status,
        ),
      );
    }
    return requests;
  }

  static Future<Group> fetchGroup(String groupId) async {
    final groupDocumentSnapshot = await FirebaseFirestore.instance
        .collection('group')
        .doc(groupId)
        .get();

    final groupDocumentData = groupDocumentSnapshot.data();
    final String groupCode = groupDocumentData!['groupCode'];
    final String subjectName = groupDocumentData['subjectName'];
    final String teacherId = groupDocumentData['creatorId'];
    final String groupName = groupDocumentData['groupName'];
    final String groupDay = groupDocumentData['day'];
    final String groupTime = groupDocumentData['time'];
    final Timestamp creationDate = groupDocumentData['creationDate'];
    final int duration = groupDocumentData['duration'];

    final teacherDocumentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: teacherId)
        .get();
    final teacherDocumentData = teacherDocumentSnapshot.docs.first.data();
    final String teacherName =
        '${teacherDocumentData['firstName']} ${teacherDocumentData['lastName']}';
    final String teacherImage = teacherDocumentData['imageUrl'];

    return Group(
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
    );
  }

  static Future<AppUser> fetchUser(String userId) async {
    final userDocumentSnapshot = await FirebaseFirestore.instance
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
    final enrollmentQuerySnapshot = await FirebaseFirestore.instance
        .collection('enrollment')
        .where('studentId', isEqualTo: studentId)
        .get();
    final List<Group> groups = [];

    for (final enrollmentDoc in enrollmentQuerySnapshot.docs) {
      final groupId = enrollmentDoc['groupId'];

      final groupDocumentSnapshot = await FirebaseFirestore.instance
          .collection('group')
          .doc(groupId)
          .get();

      final groupDocumentData = groupDocumentSnapshot.data();
      final String groupCode = groupDocumentData!['groupCode'];
      final String subjectName = groupDocumentData['subjectName'];
      final String teacherId = groupDocumentData['creatorId'];
      final String groupName = groupDocumentData['groupName'];
      final String groupDay = groupDocumentData['day'];
      final String groupTime = groupDocumentData['time'];
      final Timestamp creationDate = groupDocumentData['creationDate'];
      final int duration = groupDocumentData['duration'];

      final teacherDocumentSnapshot = await FirebaseFirestore.instance
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

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('group')
          .where('groupCode', isEqualTo: code)
          .get();

      codeExists = querySnapshot.docs.isNotEmpty;
    } while (codeExists);

    try {
      await FirebaseFirestore.instance.collection('group').add({
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
    final querySnapshot = await FirebaseFirestore.instance
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
      final enrollmentDoc = await FirebaseFirestore.instance
          .collection('enrollment')
          .where('studentId', isEqualTo: studentId)
          .where('groupId', isEqualTo: groupId)
          .get();
      if (enrollmentDoc.docs.isEmpty) {
        log("Document with code $groupId and student ID $studentId not found.");
      }

      await FirebaseFirestore.instance
          .collection('enrollment')
          .doc(enrollmentDoc.docs.first.id)
          .delete();
    } catch (error) {
      log("Failed to delete document: $error");
    }
  }

  static Future<List<Student>> fetchGroupStudents(String groupId) async {
    final List<Student> students = [];
    final enrollmentQuerySnapshot = await FirebaseFirestore.instance
        .collection('enrollment')
        .where('groupId', isEqualTo: groupId)
        .get();
    for (final enrollmentDoc in enrollmentQuerySnapshot.docs) {
      final studentId = enrollmentDoc['studentId'];
      final studentDocumentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: studentId)
          .get();
      final studentDocumentData = studentDocumentSnapshot.docs.first.data();
      students.add(
        Student(
          firstName: studentDocumentData['firstName'],
          lastName: studentDocumentData['lastName'],
          email: studentDocumentData['email'],
        ),
      );
    }
    return students;
  }
}
