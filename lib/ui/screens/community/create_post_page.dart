// lib/ui/screens/community/create_post_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:plant_care/constants.dart';
import 'package:plant_care/models/post.dart';
import 'package:plant_care/providers/community_provider.dart';
import 'package:plant_care/services/auth_service.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _textCtrl = TextEditingController();
  File? _pickedImage;
  bool _posting = false;

  Future<void> _pickImage() async {
    final XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null) {
      setState(() => _pickedImage = File(file.path));
    }
  }

  Future<void> _submit() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty && _pickedImage == null) return;

    setState(() => _posting = true);
    final user = AuthService.instance.currentUser!;
    final post = Post(
      authorId:  user.id!,
      text:      text.isEmpty ? null : text,
      imagePath: null,           // will be set by repo
      createdAt: DateTime.now(),
    );

    // Pass the File into the provider
    await context.read<CommunityProvider>().addPost(
      post,
      imageFile: _pickedImage,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Post'), backgroundColor: Constants.primaryColor),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textCtrl,
              decoration: const InputDecoration(
                hintText: 'What’s on your mind?',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16),
            if (_pickedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(_pickedImage!, height: 200, fit: BoxFit.cover),
              ),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text('Add Image'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Constants.primaryColor),
                onPressed: _posting ? null : _submit,
                child: _posting
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const Text('Post'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
