class User {
  String id;
  String email;
  String role;
  String name;
  String profile_Image;
  User({
    required this.id,
    required this.email,
    required this.role,
  required this.name,
    required this.profile_Image,
  });
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'].toString(),
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      name: map['name'] ?? '',
      profile_Image: map['profile_image'] ?? '',
    );
  }

  bool IsAdmin() {
    return role.toLowerCase() == 'admin';
  }
}
