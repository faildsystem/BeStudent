class Student {
  final String id;
  final String fullName;
  final String email;
  final double attendance;
  bool isPresent;

  Student({
    required this.id,
    required this.fullName,
    required this.email,
    required this.attendance,
    this.isPresent = false,
  });
}
