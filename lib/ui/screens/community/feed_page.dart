import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plant_care/constants.dart';
import 'package:plant_care/models/post.dart';
import 'package:plant_care/providers/community_provider.dart';

// Use _absolute_ package imports to avoid any ambiguity:
import 'package:plant_care/ui/screens/community/post_card.dart';
import 'package:plant_care/ui/screens/community/create_post_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    await context.read<CommunityProvider>().loadPosts();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityProvider>();

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final posts = provider.posts;
    return Scaffold(
      body: posts.isEmpty
          ? const Center(
        child: Text(
          'No posts yet.\nTap + to create one.',
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: posts.length,
        itemBuilder: (_, i) => PostCard(post: posts[i]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostPage()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
