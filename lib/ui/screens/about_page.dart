// lib/ui/screens/about_page.dart

import 'package:flutter/material.dart';
import 'package:plant_care/constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  static const _appVersion = '1.0.0+1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About GrowBuddy'),
        backgroundColor: Constants.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Optional: your app logo
            // Image.asset('assets/images/logo.png', height: 100),

            const SizedBox(height: 16),
            Text(
              Constants.appName,
              style: TextStyle(
                color: Constants.primaryColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version $_appVersion',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            const Text(
              'GrowBuddy is your ultimate plant care companion. '
                  'Learn about plant species, set reminders, and track your garden’s progress—all in one place.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const Spacer(),
            Text(
              '© ${DateTime.now().year} GrowBuddy, Inc.',
              style: const TextStyle(fontSize: 12, color: Colors.black38),
            ),
          ],
        ),
      ),
    );
  }
}
