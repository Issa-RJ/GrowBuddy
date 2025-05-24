// lib/ui/screens/alarm.dart

import 'package:flutter/material.dart';
import 'package:plant_care/constants.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _waterReminder = true;
  bool _fertilizeReminder = false;
  bool _pestControlReminder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Constants.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                SwitchListTile(
                  title: const Text('Watering Reminder'),
                  subtitle: const Text('Notify me when it’s time to water my plants.'),
                  secondary: Icon(Icons.opacity, color: Constants.primaryColor),
                  value: _waterReminder,
                  onChanged: (val) => setState(() => _waterReminder = val),
                ),
                SwitchListTile(
                  title: const Text('Fertilizing Reminder'),
                  subtitle: const Text('Notify me when it’s time to fertilize.'),
                  secondary: Icon(Icons.eco, color: Constants.primaryColor),
                  value: _fertilizeReminder,
                  onChanged: (val) => setState(() => _fertilizeReminder = val),
                ),
                SwitchListTile(
                  title: const Text('Pest Control Reminder'),
                  subtitle: const Text('Notify me about pest control tasks.'),
                  secondary: Icon(Icons.bug_report, color: Constants.primaryColor),
                  value: _pestControlReminder,
                  onChanged: (val) => setState(() => _pestControlReminder = val),
                ),
                // Add more notification types here as needed
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.primaryColor,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // TODO: Persist notification preferences (e.g. via shared_preferences or your backend)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification settings saved')),
                );
              },
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
