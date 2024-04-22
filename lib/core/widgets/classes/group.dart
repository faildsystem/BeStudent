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
  final String groupSubjectName;
  final String teacherName;
  final String groupCode;
  final String teacherImage;
  final String groupName;
  final String groupDay;
  final String groupTime;

  Group({
    required this.groupSubjectName,
    required this.groupCode,
    required this.groupName,
    required this.teacherName,
    required this.teacherImage,
    required this.groupDay,
    required this.groupTime,
  });
}
