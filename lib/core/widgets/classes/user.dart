class AppUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String type;
  String? phone;
  String? address;
  String? birthDate;
  String? image;

  AppUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.type,
    required this.phone,
    required this.address,
    required this.birthDate,
    required this.image,
  });
}
