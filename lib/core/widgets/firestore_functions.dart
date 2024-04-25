import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/core/widgets/classes/group.dart';
import 'package:student/core/widgets/classes/user.dart';
import 'package:student/helpers/app_regex.dart';

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

  static Future<int> groupJoinRequest({
    required String userId,
    required String code,
  }) async {
    try {
      // Check if a document with the same code and student_id exists
      final querySnapshot = await FirebaseFirestore.instance
          .collection('enrollment')
          .where('groupCode', isEqualTo: code)
          .where('studentId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        log("Document with code $code and student ID $userId already exists.");
        return 0;
      } else {
        // Document does not exist, proceed to add
        final docId = await getDocId(
            collection: 'group', field: 'groupCode', value: code);
        if (docId != null) {
          await FirebaseFirestore.instance.collection('enrollment').add({
            'groupCode': code,
            'studentId': userId,
            'joinedDate': Timestamp.now(),
          });
          log("Added Data with ID: $code");
          return 1;
        } else {
          log("Group $code not found.");
          return -1;
        }
      }
    } catch (error) {
      log("Failed to send group join request: $error");
      return -1;
    }
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
      final groupCode = enrollmentDoc['groupCode'];

      final groupDocumentSnapshot = await FirebaseFirestore.instance
          .collection('group')
          .where('groupCode', isEqualTo: groupCode)
          .get();

      final groupDocumentData = groupDocumentSnapshot.docs.first.data();
      final String subjectName = groupDocumentData['subjectName'];
      final String teacherId = groupDocumentData['creatorId'];
      final String groupName = groupDocumentData['groupName'];
      final String groupDay = groupDocumentData['day'];
      final String grouptime = groupDocumentData['time'];

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
          teacherName: teacherName,
          teacherImage: teacherImage,
          groupCode: groupCode,
          groupName: groupName,
          groupDay: groupDay,
          groupTime: grouptime,
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
      final groupCode = groupDoc['groupCode'];
      final String groupName = groupDoc['groupName'];
      final String groupDay = groupDoc['day'];
      final String grouptime = groupDoc['time'];

      groups.add(
        Group(
          subjectName: subjectName,
          groupCode: groupCode,
          groupName: groupName,
          teacherName: '',
          teacherImage: '',
          groupDay: groupDay,
          groupTime: grouptime,
        ),
      );
    }
    return groups;
  }

  static Future<void> unrollGroup(String studentId, String groupCode) async {
    try {
      final enrollmentDocId = await getDocId(
          collection: 'enrollment', field: 'student_id', value: studentId);
      if (enrollmentDocId != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('enrollment')
            .where('group_code', isEqualTo: groupCode)
            .where('student_id', isEqualTo: studentId)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('enrollment')
              .doc(querySnapshot.docs.first.id)
              .delete();
          log("Document with code $groupCode and student ID $studentId deleted.");
        } else {
          log("Document with code $groupCode and student ID $studentId not found.");
        }
      } else {
        log("Document with student ID $studentId not found.");
      }
    } catch (error) {
      log("Failed to delete document: $error");
    }
  }
}
