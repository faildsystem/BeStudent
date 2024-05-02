// ignore_for_file: public_member_api_docs, sort_constructors_first
// enum Category {
//   arabicLanguage,
//   mathematics,
//   science,
//   history,
//   geography,
//   englishLanguage,
//   frenchLanguage,
//   italianLanguage,
//   germanLanguage,
// }
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String subjectName;
  final String groupId;
  final String groupCode;
  final String groupName;
  final String groupDay;
  final String groupTime;
  final String teacherName;
  final String teacherImage;
  final Timestamp creationDate;
  final int duration;

  Group({
    required this.subjectName,
    required this.groupId,
    required this.groupCode,
    required this.groupName,
    required this.teacherName,
    required this.teacherImage,
    required this.groupDay,
    required this.groupTime,
    required this.creationDate,
    required this.duration,
  });
}
