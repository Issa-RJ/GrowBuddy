import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_care/services/perenual_api_service.dart';
import 'package:plant_care/ui/screens/detail_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _identifying = false;

  Future<void> _pickImage(ImageSource src) async {
    final XFile? picked = await _picker.pickImage(
      source: src,
      imageQuality: 80,
      maxWidth: 1200,
      maxHeight: 1200,
    );
    if (picked == null) return;
    setState(() => _imageFile = File(picked.path));
    _showPreviewSheet();
  }

  Future<void> _identifyAndOpenDetail() async {
    if (_imageFile == null) return;
    setState(() => _identifying = true);

    try {
      final svc = PerenualApiService();
      final idResult = await svc.identifyPlant(_imageFile!);
      final name = idResult.name;
      if (name.isEmpty) throw 'No name returned';
      final speciesList = await svc.fetchSpecies(q: name);
      if (speciesList.isEmpty) throw 'No species match for "$name"';
      final plant = speciesList.first;

      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DetailPage(plantId: plant.id),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Identification failed: $e')),
      );
    } finally {
      setState(() => _identifying = false);
    }
  }

  void _showPreviewSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    _imageFile!,
                    fit: BoxFit.contain,
                  ),
                )
                    : const Center(child: Text('No image selected')),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _identifying ? null : _identifyAndOpenDetail,
                icon: _identifying
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
                    : const Icon(Icons.search),
                label: Text(
                  _identifying ? 'Identifying…' : 'Show Plant Details',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel', style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickCard(IconData icon, String label, ImageSource src) {
    return GestureDetector(
      onTap: () => _pickImage(src),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF7),
      appBar: AppBar(
        title: const Text('Scan Plant', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text(
              'Select an option to identify your plant',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPickCard(
                      Icons.camera_alt,
                      'Take Photo',
                      ImageSource.camera,
                    ),
                    _buildPickCard(
                      Icons.photo_library,
                      'Upload Photo',
                      ImageSource.gallery,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
