// lib/ui/screens/share_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:plant_care/constants.dart';

class SharePage extends StatelessWidget {
  const SharePage({Key? key}) : super(key: key);

  static const String _shareText =
      'Check out ${Constants.appName} – your plant care companion! '
      'Download it now: https://example.com/download';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share'),
        backgroundColor: Constants.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Share ${Constants.appName}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Constants.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Invite your friends to grow with you!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),

              // Share via system dialog
              ElevatedButton.icon(
                onPressed: () => Share.share(_shareText),
                icon: const Icon(Icons.share),
                label: const Text('Share App'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Copy link to clipboard
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: _shareText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link copied to clipboard')),
                  );
                },
                icon: const Icon(Icons.link),
                label: const Text('Copy Link'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Constants.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
