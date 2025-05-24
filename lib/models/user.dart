// lib/models/user.dart

class User {
  final int?    id;
  final String  email;
  final String  fullName;
  final String  password;
  final String? avatarPath;

  User({
    this.id,
    required this.email,
    required this.fullName,
    required this.password,
    this.avatarPath,
  });

  factory User.fromMap(Map<String, dynamic> m) => User(
    id:         m['id'] as int?,
    email:      m['email'] as String,
    fullName:   m['fullName'] as String,
    password:   m['password'] as String,
    avatarPath: m['avatarPath'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'email':      email,
    'fullName':   fullName,
    'password':   password,
    'avatarPath': avatarPath,
  };
}
