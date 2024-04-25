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

class Group {
  final String subjectName;
  final String groupCode;
  final String groupName;
  final String groupDay;
  final String groupTime;
  final String teacherName;
  final String teacherImage;

  Group({
    required this.subjectName,
    required this.groupCode,
    required this.groupName,
    required this.teacherName,
    required this.teacherImage,
    required this.groupDay,
    required this.groupTime,
  });
}
