class AppUser {
  final String uid;
  final String email;
  final String? name;
  final bool isAdmin;

  AppUser({
    required this.uid,
    required this.email,
    this.name,
    this.isAdmin = false,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'],
      isAdmin: map['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'isAdmin': isAdmin,
    };
  }
}
