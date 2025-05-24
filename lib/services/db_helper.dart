// lib/services/db_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._();
  static Database? _db;
  DBHelper._();

  /// Open the database (version 3), creating or migrating as needed.
  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'plant_care.db');

    _db = await openDatabase(
      path,
      version: 3,              // bumped to 3
      onCreate: _createDB,
      onUpgrade: _upgradeDB,   // handles migrations
    );
    return _db!;
  }

  /// Initial creation: users + community tables
  Future _createDB(Database db, int version) async {
    // Users table (with avatarPath)
    await db.execute('''
      CREATE TABLE users(
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        email       TEXT    UNIQUE NOT NULL,
        fullName    TEXT    NOT NULL,
        password    TEXT    NOT NULL,
        avatarPath  TEXT
      )
    ''');

    // Posts table
    await db.execute('''
      CREATE TABLE posts(
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        authorId    INTEGER NOT NULL,
        text        TEXT,
        imagePath   TEXT,
        createdAt   INTEGER NOT NULL,
        FOREIGN KEY(authorId) REFERENCES users(id)
      )
    ''');

    // Comments table
    await db.execute('''
      CREATE TABLE comments(
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        postId      INTEGER NOT NULL,
        authorId    INTEGER NOT NULL,
        text        TEXT    NOT NULL,
        createdAt   INTEGER NOT NULL,
        FOREIGN KEY(postId) REFERENCES posts(id),
        FOREIGN KEY(authorId) REFERENCES users(id)
      )
    ''');

    // Likes table (one row per user-post like)
    await db.execute('''
      CREATE TABLE likes(
        postId      INTEGER NOT NULL,
        userId      INTEGER NOT NULL,
        PRIMARY KEY(postId, userId),
        FOREIGN KEY(postId) REFERENCES posts(id),
        FOREIGN KEY(userId) REFERENCES users(id)
      )
    ''');
  }

  /// Migrates from older versions to the current (3).
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // add avatarPath in v2
      await db.execute('ALTER TABLE users ADD COLUMN avatarPath TEXT');
    }
    if (oldVersion < 3) {
      // create posts table
      await db.execute('''
        CREATE TABLE posts(
          id          INTEGER PRIMARY KEY AUTOINCREMENT,
          authorId    INTEGER NOT NULL,
          text        TEXT,
          imagePath   TEXT,
          createdAt   INTEGER NOT NULL,
          FOREIGN KEY(authorId) REFERENCES users(id)
        )
      ''');

      // create comments table
      await db.execute('''
        CREATE TABLE comments(
          id          INTEGER PRIMARY KEY AUTOINCREMENT,
          postId      INTEGER NOT NULL,
          authorId    INTEGER NOT NULL,
          text        TEXT    NOT NULL,
          createdAt   INTEGER NOT NULL,
          FOREIGN KEY(postId) REFERENCES posts(id),
          FOREIGN KEY(authorId) REFERENCES users(id)
        )
      ''');

      // create likes table
      await db.execute('''
        CREATE TABLE likes(
          postId      INTEGER NOT NULL,
          userId      INTEGER NOT NULL,
          PRIMARY KEY(postId, userId),
          FOREIGN KEY(postId) REFERENCES posts(id),
          FOREIGN KEY(userId) REFERENCES users(id)
        )
      ''');
    }
  }

  Future<int> insertUser(Map<String, dynamic> row) async {
    final db = await database;
    return db.insert('users', row);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return res.isNotEmpty ? res.first : null;
  }

// … you can add fetch/insert/update methods for posts, comments, likes here …
}
