// lib/ui/screens/edit_profile_page.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_care/constants.dart';
import 'package:plant_care/services/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
  late TextEditingController _confirmCtrl;

  File? _avatarFile;
  bool _saving = false;
  bool _showPasswordFields = false;

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    _nameCtrl     = TextEditingController(text: user?.fullName ?? '');
    _emailCtrl    = TextEditingController(text: user?.email    ?? '');
    _passwordCtrl = TextEditingController();
    _confirmCtrl  = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 600,
      maxHeight: 600,
    );
    if (picked != null) {
      setState(() => _avatarFile = File(picked.path));
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final newName     = _nameCtrl.text.trim();
    final newEmail    = _emailCtrl.text.trim();
    final newPassword = _showPasswordFields ? _passwordCtrl.text : null;

    try {
      // TODO: extend updateProfile to accept avatarFile & password
      final success = await AuthService.instance.updateProfile(
        name:  newName,
        email: newEmail,
        // password: newPassword,
        // avatar: _avatarFile,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Profile updated' : 'Update failed',
          ),
        ),
      );
      if (success) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Constants.primaryColor,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar Picker
              GestureDetector(
                onTap: _pickAvatar,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _avatarFile != null
                      ? FileImage(_avatarFile!)
                      : AssetImage('assets/images/man_profile.jpeg')
                  as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Constants.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Details Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 24),
                  child: Column(
                    children: [
                      // Full Name
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => (v ?? '').trim().isEmpty
                            ? 'Name is required'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          final val = (v ?? '').trim();
                          if (val.isEmpty) return 'Email is required';
                          if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$')
                              .hasMatch(val)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),

                      // Change Password Toggle
                      const SizedBox(height: 16),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Change Password'),
                        secondary: const Icon(Icons.lock_outline),
                        value: _showPasswordFields,
                        onChanged: (v) =>
                            setState(() => _showPasswordFields = v),
                      ),

                      // Password Fields
                      if (_showPasswordFields) ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordCtrl,
                          decoration: const InputDecoration(
                            labelText: 'New Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (v) {
                            if ((v ?? '').length < 6) {
                              return 'At least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (v) {
                            if (v != _passwordCtrl.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 3,
                  ),
                  onPressed: _saving ? null : _onSave,
                  child: _saving
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
