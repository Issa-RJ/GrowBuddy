// lib/ui/screens/faqs_page.dart

import 'package:flutter/material.dart';
import 'package:plant_care/constants.dart';

class FaqsPage extends StatelessWidget {
  const FaqsPage({Key? key}) : super(key: key);

  static const List<Map<String, String>> _faqs = [
    {
      'question': 'How do I scan a plant?',
      'answer':
      'Tap “Take Photo” or “Upload Photo” on the Scan screen, select or capture an image, then press “Show Plant Details” to identify your plant.',
    },
    {
      'question': 'Where can I view detailed plant information?',
      'answer':
      'After identification, you will be automatically taken to the Detail screen, which shows species data, care guides, and disease info.',
    },
    {
      'question': 'How do I edit my profile?',
      'answer':
      'Go to Profile → Edit Profile, update your name, email, or avatar, then tap “Save” to apply changes.',
    },
    {
      'question': 'How can I change app settings?',
      'answer':
      'Open Profile → Settings to adjust theme, language, and notification preferences.',
    },
    {
      'question': 'How do notifications work?',
      'answer':
      'You can enable or disable reminders in Profile → Notifications. Reminders will appear based on your alert settings.',
    },
    {
      'question': 'How do I log out?',
      'answer':
      'Go to Profile → Log Out. This will clear your session and return you to the sign-in screen.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
        backgroundColor: Constants.primaryColor,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        itemCount: _faqs.length,
        itemBuilder: (context, index) {
          final faq = _faqs[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ExpansionTile(
              leading: Icon(
                Icons.question_answer,
                color: Constants.primaryColor,
              ),
              title: Text(
                faq['question']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                Text(
                  faq['answer']!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
