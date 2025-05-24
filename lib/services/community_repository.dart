// lib/services/community_repository.dart

import 'dart:io';
import 'package:path/path.dart' as p;              // ← aliased to `p`
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/post.dart';
import '../models/comment.dart';
import 'db_helper.dart';

class CommunityRepository {
  final DBHelper _dbHelper = DBHelper.instance;

  Future<List<Post>> fetchPosts() async {
    final db   = await _dbHelper.database;
    final rows = await db.query('posts', orderBy: 'createdAt DESC');
    return rows.map(Post.fromMap).toList();
  }

  Future<int> addPost(Post post, { File? imageFile }) async {
    String? savedPath;
    if (imageFile != null) {
      final dir      = await getApplicationDocumentsDirectory();
      final baseName = p.basename(imageFile.path);
      final newName  = '${DateTime.now().millisecondsSinceEpoch}_$baseName';
      savedPath      = p.join(dir.path, newName);
      await imageFile.copy(savedPath);
    }

    final db = await _dbHelper.database;
    return db.insert('posts', {
      'authorId':  post.authorId,
      'text':      post.text,
      'imagePath': savedPath,
      'createdAt': post.createdAt.millisecondsSinceEpoch,
    });
  }

  Future<List<Comment>> fetchComments(int postId) async {
    final db   = await _dbHelper.database;
    final rows = await db.query(
      'comments',
      where: 'postId = ?',
      whereArgs: [postId],
      orderBy: 'createdAt ASC',
    );
    return rows.map(Comment.fromMap).toList();
  }

  Future<int> addComment(Comment comment) async {
    final db = await _dbHelper.database;
    return db.insert('comments', {
      'postId':    comment.postId,
      'authorId':  comment.authorId,
      'text':      comment.text,
      'createdAt': comment.createdAt.millisecondsSinceEpoch,
    });
  }

  Future<void> toggleLike(int postId, int userId) async {
    final db = await _dbHelper.database;
    final exists = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM likes WHERE postId = ? AND userId = ?',
      [postId, userId],
    ))!;

    if (exists > 0) {
      await db.delete(
        'likes',
        where: 'postId = ? AND userId = ?',
        whereArgs: [postId, userId],
      );
    } else {
      await db.insert('likes', {
        'postId': postId,
        'userId': userId,
      });
    }
  }

  Future<bool> isLiked(int postId, int userId) async {
    final db    = await _dbHelper.database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM likes WHERE postId = ? AND userId = ?',
      [postId, userId],
    ))!;
    return count > 0;
  }

  Future<int> likeCount(int postId) async {
    final db = await _dbHelper.database;
    return Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM likes WHERE postId = ?',
      [postId],
    ))!;
  }
}
