// lib/ui/screens/community/comments_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:plant_care/constants.dart';
import 'package:plant_care/models/comment.dart';
import 'package:plant_care/models/post.dart';
import 'package:plant_care/providers/community_provider.dart';
import 'package:plant_care/services/auth_service.dart';

class CommentsPage extends StatefulWidget {
  final Post post;
  const CommentsPage({required this.post, Key? key}) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    await context.read<CommunityProvider>().loadComments(widget.post.id!);
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final user = AuthService.instance.currentUser!;
    final comment = Comment(
      postId: widget.post.id!,
      authorId: user.id!,
      text: text,
    );
    await context.read<CommunityProvider>().addComment(comment);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityProvider>();
    final comments = provider.comments[widget.post.id!] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: Constants.primaryColor,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : comments.isEmpty
                ? const Center(child: Text('No comments yet.'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: comments.length,
              itemBuilder: (context, i) {
                final c = comments[i];
                // For simplicity, show user ID instead of name
                return ListTile(
                  leading: const Icon(Icons.comment, size: 28),
                  title: Text(c.text),
                  subtitle: Text(
                    timeago.format(c.createdAt),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Write a comment...',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Constants.primaryColor),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
