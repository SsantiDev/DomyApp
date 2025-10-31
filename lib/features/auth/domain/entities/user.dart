class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'cliente' o 'operaria'
  final String phone;
  final String? address;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    this.address,
  });
}
