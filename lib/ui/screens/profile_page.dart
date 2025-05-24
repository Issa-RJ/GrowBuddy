// lib/ui/screens/profile_page.dart

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant_care/constants.dart';
import 'package:plant_care/models/user.dart';
import 'package:plant_care/services/auth_service.dart';
import 'package:plant_care/ui/screens/edit_profile_page.dart';
import 'package:plant_care/ui/screens/settings_page.dart';
import 'package:plant_care/ui/screens/alarm.dart';         // NotificationPage
import 'package:plant_care/ui/screens/signin_page.dart';
import 'package:plant_care/ui/screens/faqs_page.dart';
import 'package:plant_care/ui/screens/share_page.dart';    // SharePage

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await AuthService.instance.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SignIn()),
          (r) => false,
    );
  }

  void _openPlaceholder(BuildContext context, String title) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: Constants.primaryColor,
          ),
          body: Center(child: Text('$title screen')),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final name  = user?.fullName ?? 'User';
    final email = user?.email    ?? '';

    final options = [
      // 1) Edit Profile
      _ProfileOption(
        icon: Icons.edit,
        label: 'Edit Profile',
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const EditProfilePage(),
            ),
          );
        },
      ),

      // 2) Settings
      _ProfileOption(
        icon: Icons.settings,
        label: 'Settings',
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const SettingsPage(),
            ),
          );
        },
      ),

      // 3) Notifications
      _ProfileOption(
        icon: Icons.notifications,
        label: 'Notifications',
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const NotificationPage(),
            ),
          );
        },
      ),

      // 4) FAQs
      _ProfileOption(
        icon: Icons.question_answer,
        label: 'FAQs',
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const FaqsPage(),
            ),
          );
        },
      ),

      // 5) Share
      _ProfileOption(
        icon: Icons.share,
        label: 'Share',
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const SharePage(),
            ),
          );
        },
      ),

      // 6) Log Out
      _ProfileOption(
        icon: Icons.logout,
        label: 'Log Out',
        onTap: () => _logout(context),
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ─── HEADER ───────────────────────────────────────────────────
            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Constants.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white.withOpacity(.8),
                      backgroundImage:
                      const AssetImage('assets/images/man_profile.jpeg'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.white.withOpacity(.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ─── GRID OF CARDS ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children:
                options.map((opt) => _ProfileCard(option: opt)).toList(),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ProfileOption {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ProfileOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class _ProfileCard extends StatelessWidget {
  final _ProfileOption option;
  const _ProfileCard({required this.option});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: option.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(option.icon, size: 32, color: Constants.primaryColor),
              const SizedBox(height: 12),
              Text(
                option.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
