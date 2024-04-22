import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/core/widgets/classes/group.dart';
import 'package:student/core/widgets/classes/user.dart';

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
          'type': isTeacher? 'teacher': 'student',
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
      final docId =
          await getDocId(collection: 'users', field: 'id', value: id);
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
          .where('group_code', isEqualTo: code)
          .where('student_id', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        log("Document with code $code and student ID $userId already exists.");
        return 0;
      } else {
        // Document does not exist, proceed to add
        final docId =
            await getDocId(collection: 'group', field: 'code', value: code);
        if (docId != null) {
          await FirebaseFirestore.instance.collection('enrollment').add({
            'group_code': code,
            'student_id': userId,
            'joined_date': Timestamp.now(),
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

  static Stream<List<Group>> fetchStudentGroups(String studentId) {
    return FirebaseFirestore.instance
        .collection('enrollment')
        .where('student_id', isEqualTo: studentId)
        .snapshots()
        .asyncMap((enrollmentSnapshot) async {
      final List<Group> groups = [];
      for (final enrollmentDoc in enrollmentSnapshot.docs) {
        final groupCode = enrollmentDoc['group_code'];

        final geoupDocumentSnapshot = await FirebaseFirestore.instance
            .collection('group')
            .where('code', isEqualTo: groupCode)
            .get();

        final groupDocumentData = geoupDocumentSnapshot.docs.first.data();
        final String courseId = groupDocumentData['course_id'];
        final String groupName = groupDocumentData['name'];
        final String groupDay = groupDocumentData['day'];
        final String grouptime = groupDocumentData['time'];
        

        final courseDocumentSnapshot = await FirebaseFirestore.instance
            .collection('course')
            .where('id', isEqualTo: courseId)
            .get();

        final courseDocumentData = courseDocumentSnapshot.docs.first.data();
        final String teacherId = courseDocumentData['creator_id'];
        final String courseName = courseDocumentData['name'];

        final teacherDocumentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: teacherId)
            .get();
        final teacherDocumentData = teacherDocumentSnapshot.docs.first.data();
        final String teacherName = teacherDocumentData['firstName'] +
            ' ' +
            teacherDocumentData['lastName'];
        final String teacherImage = teacherDocumentData['imageUrl'];
        groups.add(
          Group(
            groupSubjectName: courseName,
            groupCode: groupCode,
            groupName: groupName,
            teacherName: teacherName,
            teacherImage: teacherImage,
            groupDay: groupDay,
            groupTime: grouptime,
          ),
        );
      }
      return groups;
    });
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
