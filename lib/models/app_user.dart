class AppUser {
  final String uid;
  final String name;
  final String email;
  final String role; // 'entry_user', 'billing_user', 'manager'

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String docId) {
    return AppUser(
      uid: docId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'entry_user',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
    };
  }
}

