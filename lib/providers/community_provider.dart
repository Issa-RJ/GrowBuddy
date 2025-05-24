import 'dart:io';
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../services/community_repository.dart';

class CommunityProvider extends ChangeNotifier {
  final CommunityRepository _repo = CommunityRepository();

  List<Post>    posts    = [];
  Map<int,List<Comment>> comments = {};

  Future<void> loadPosts() async {
    posts = await _repo.fetchPosts();
    notifyListeners();
  }


  Future<void> loadComments(int postId) async {
    comments[postId] = await _repo.fetchComments(postId);
    notifyListeners();
  }

  Future<void> addComment(Comment c) async {
    await _repo.addComment(c);
    await loadComments(c.postId);
  }

  Future<void> toggleLike(int postId, int userId) async {
    await _repo.toggleLike(postId, userId);
    // no notify; UI can re-check isLiked/count
  }
  Future<void> addPost(Post p, { File? imageFile }) async {
    await _repo.addPost(p, imageFile: imageFile);
    await loadPosts();
  }

  Future<bool> isLiked(int postId, int userId) =>
      _repo.isLiked(postId, userId);

  Future<int> likeCount(int postId) =>
      _repo.likeCount(postId);
}
