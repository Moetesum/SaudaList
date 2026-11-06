class AppUser {
  final String id;
  final String name;
  final String email;
  final String password;
  final bool isAdmin;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.isAdmin = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
