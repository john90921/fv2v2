class User {
  int id;
  int profile_id;
  String email;
  String name;
  String? description;
  String? profile_Image;
  User({
    required this.id,
    required this.profile_id,
    required this.email,
    required this.name,
    required this.description,
    required this.profile_Image,
  });

  User.initial()
      : id = 0,
        profile_id = 0,
        email = "",
        name = "",
        description = null,
        profile_Image = null;
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      profile_id: map['profile_id'],
      email: map['email'],
      name: map['name'],
      description: map['description'] ?? '',
      profile_Image: map['profile_image'] ?? '',
    );
  }

  bool checkUserID(int id){
    return this.id == id;
  }
}
