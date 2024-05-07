import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/core/widgets/classes/group.dart';
import 'package:student/core/widgets/classes/user.dart';

class Request {
  String requestId;
  AppUser student;
  Group group;
  Timestamp date;
  String status;

  Request({
    required this.requestId,
    required this.student,
    required this.group,
    required this.date,
    required this.status,
  });
}
