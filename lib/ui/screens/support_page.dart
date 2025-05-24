// lib/ui/screens/support_page.dart

import 'package:flutter/material.dart';
import 'package:plant_care/constants.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  void _openPlaceholder(BuildContext context, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: Constants.primaryColor,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '$title content goes here.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support & Legal'),
        backgroundColor: Constants.primaryColor,
        elevation: 0,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.privacy_tip, color: Constants.primaryColor),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openPlaceholder(context, 'Privacy Policy'),
          ),
          const Divider(height: 0),
          ListTile(
            leading: Icon(Icons.description, color: Constants.primaryColor),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openPlaceholder(context, 'Terms of Service'),
          ),
          const Divider(height: 0),
          ListTile(
            leading: Icon(Icons.feedback, color: Constants.primaryColor),
            title: const Text('Send Feedback'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openPlaceholder(context, 'Send Feedback'),
          ),
        ],
      ),
    );
  }
}
