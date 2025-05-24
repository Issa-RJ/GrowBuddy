// lib/ui/screens/community/post_card.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:plant_care/constants.dart';
import 'package:plant_care/models/post.dart';
import 'package:plant_care/providers/community_provider.dart';
import 'package:plant_care/services/auth_service.dart';
import 'package:plant_care/ui/screens/community/comments_page.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({required this.post, Key? key}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late final CommunityProvider _provider;
  late final user = AuthService.instance.currentUser!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = context.read<CommunityProvider>();
  }

  Future<void> _toggleLike() async {
    await _provider.toggleLike(widget.post.id!, user.id!);
    setState(() {}); // re-trigger FutureBuilders
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header: avatar, name, timestamp ─────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: user.avatarPath != null
                      ? FileImage(File(user.avatarPath!))
                      : null,
                  child: user.avatarPath == null
                      ? Text(
                    user.fullName.isNotEmpty
                        ? user.fullName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(color: Colors.white),
                  )
                      : null,
                ),
                const SizedBox(width: 8),
                Text(
                  user.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  timeago.format(post.createdAt),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),

            // ── Body text ───────────────────────────────────────
            if (post.text?.trim().isNotEmpty ?? false) ...[
              const SizedBox(height: 12),
              Text(post.text!),
            ],

            // ── Body image ──────────────────────────────────────
            if (post.imagePath != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(post.imagePath!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ],

            const SizedBox(height: 12),

            // ── Actions: like & comment ─────────────────────────
            Row(
              children: [
                FutureBuilder<bool>(
                  future: _provider.isLiked(post.id!, user.id!),
                  builder: (context, snap) {
                    final liked = snap.data ?? false;
                    return IconButton(
                      icon: Icon(
                        liked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                        color: liked ? Constants.primaryColor : Colors.grey,
                      ),
                      onPressed: _toggleLike,
                    );
                  },
                ),

                FutureBuilder<int>(
                  future: _provider.likeCount(post.id!),
                  builder: (context, snap) {
                    final count = snap.data ?? 0;
                    return Text('$count');
                  },
                ),

                const Spacer(),

                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CommentsPage(post: post),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
