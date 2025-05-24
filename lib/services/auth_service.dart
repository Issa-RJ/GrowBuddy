// lib/services/auth_service.dart

import 'dart:io';
import 'package:plant_care/services/db_helper.dart';
import 'package:plant_care/models/user.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  User? _currentUser;
  User? get currentUser => _currentUser;

  /// Returns true if registration succeeded.
  /// You can now optionally pass an avatarPath.
  Future<bool> register({
    required String email,
    required String name,
    required String pass,
    String? avatarPath,
  }) async {
    final existing = await DBHelper.instance.getUserByEmail(email);
    if (existing != null) return false;

    final newUser = User(
      email:      email,
      fullName:   name,
      password:   pass,
      avatarPath: avatarPath,
    );
    await DBHelper.instance.insertUser(newUser.toMap());
    return true;
  }

  /// Returns a User if login succeeds, null otherwise.
  Future<User?> login({
    required String email,
    required String pass,
  }) async {
    final row = await DBHelper.instance.getUserByEmail(email);
    if (row == null) return null;
    final user = User.fromMap(row);
    if (user.password == pass) {
      _currentUser = user;
      return user;
    }
    return null;
  }

  /// Updates the current user’s profile. Supports name, email,
  /// optional newPassword, and optional avatarPath.
  Future<bool> updateProfile({
    required String name,
    required String email,
    String? newPassword,
    String? avatarPath,
  }) async {
    final user = _currentUser;
    if (user == null) return false;

    // If the email changed, make sure it's not taken already
    if (email != user.email) {
      final existing = await DBHelper.instance.getUserByEmail(email);
      if (existing != null && existing['id'] != user.id) {
        return false; // email already in use
      }
    }

    final db = await DBHelper.instance.database;
    final updates = <String, dynamic>{
      'fullName': name,
      'email':    email,
    };
    if (newPassword != null && newPassword.isNotEmpty) {
      updates['password'] = newPassword;
    }
    if (avatarPath != null) {
      updates['avatarPath'] = avatarPath;
    }

    final count = await db.update(
      'users',
      updates,
      where: 'id = ?',
      whereArgs: [user.id],
    );

    if (count > 0) {
      // Refresh in‐memory user
      _currentUser = User(
        id:         user.id,
        email:      email,
        fullName:   name,
        password:   updates['password'] as String? ?? user.password,
        avatarPath: updates['avatarPath'] as String? ?? user.avatarPath,
      );
      return true;
    }

    return false;
  }

  /// Clears the current user.
  Future<void> logout() async {
    _currentUser = null;
  }
}
