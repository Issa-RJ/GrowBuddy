import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';

import 'alarm.dart';        // NotificationPage
import 'share_page.dart';   // SharePage
import 'faqs_page.dart';    // FaqsPage
import 'support_page.dart'; // SupportPage (Privacy/Terms/Feedback)
import 'about_page.dart';   // AboutPage

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void _openScreen(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider  = context.watch<LanguageProvider>();

    final settingsTitle = langProvider.isEnglish ? 'Settings' : 'الإعدادات';
    final darkModeLabel = langProvider.isEnglish ? 'Dark Mode' : 'الوضع الداكن';
    final langLabel     = langProvider.isEnglish ? 'English'   : 'الإنجليزية';
    final langSubtitle  = langProvider.isEnglish
        ? 'Switch to Arabic'
        : 'التبديل إلى الإنجليزية';

    return Scaffold(
      appBar: AppBar(
        title: Text(settingsTitle),
        backgroundColor: Constants.primaryColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Appearance & Language ────────────────────────────────
          Text(
            langProvider.isEnglish
                ? 'Appearance & Language'
                : 'المظهر واللغة',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Column(children: [
              SwitchListTile.adaptive(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16),
                title: Text(darkModeLabel,
                    style:
                    Theme.of(context).textTheme.bodyLarge),
                secondary: Icon(
                  themeProvider.isDarkMode
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  color: Constants.primaryColor,
                ),
                activeColor: Constants.primaryColor,
                value: themeProvider.isDarkMode,
                onChanged: themeProvider.toggleTheme,
              ),
              const Divider(height: 0),
              SwitchListTile.adaptive(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16),
                title: Text(langLabel,
                    style:
                    Theme.of(context).textTheme.bodyLarge),
                subtitle: Text(langSubtitle,
                    style:
                    Theme.of(context).textTheme.bodySmall),
                secondary: Icon(Icons.language_outlined,
                    color: Constants.primaryColor),
                activeColor: Constants.primaryColor,
                value: langProvider.isEnglish,
                onChanged: langProvider.toggleLanguage,
              ),
            ]),
          ),

          const SizedBox(height: 24),

          // ── Notifications & Sharing ───────────────────────────────
          Text(
            langProvider.isEnglish
                ? 'Notifications & Sharing'
                : 'الإشعارات والمشاركة',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Column(children: [
              ListTile(
                leading: Icon(Icons.notifications,
                    color: Constants.primaryColor),
                title: Text(
                    langProvider.isEnglish
                        ? 'Notification Settings'
                        : 'إعدادات الإشعارات',
                    style:
                    Theme.of(context).textTheme.bodyLarge),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openScreen(
                    context, const NotificationPage()),
              ),
              const Divider(height: 0),
              ListTile(
                leading:
                Icon(Icons.share, color: Constants.primaryColor),
                title: Text(
                    langProvider.isEnglish ? 'Share App' : 'مشاركة التطبيق',
                    style:
                    Theme.of(context).textTheme.bodyLarge),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    _openScreen(context, const SharePage()),
              ),
              const Divider(height: 0),
              ListTile(
                leading:
                Icon(Icons.star_rate, color: Constants.primaryColor),
                title: Text(
                    langProvider.isEnglish ? 'Rate App' : 'تقييم التطبيق',
                    style:
                    Theme.of(context).textTheme.bodyLarge),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openScreen(context,
                    const PlaceholderScreen(title: 'Rate App')),
              ),
            ]),
          ),

          const SizedBox(height: 24),

          // ── Support & Legal ────────────────────────────────────────
          Text(
            langProvider.isEnglish
                ? 'Support & Legal'
                : 'الدعم والشروط',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Column(children: [
              ListTile(
                leading: Icon(Icons.help_outline,
                    color: Constants.primaryColor),
                title: Text(
                    langProvider.isEnglish
                        ? 'Help & FAQs'
                        : 'الأسئلة الشائعة',
                    style:
                    Theme.of(context).textTheme.bodyLarge),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openScreen(
                    context, const FaqsPage()),
              ),
              const Divider(height: 0),
              ListTile(
                leading:
                Icon(Icons.info_outline, color: Constants.primaryColor),
                title: Text(
                    langProvider.isEnglish
                        ? 'About GrowBuddy'
                        : 'عن GrowBuddy',
                    style:
                    Theme.of(context).textTheme.bodyLarge),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openScreen(
                    context, const AboutPage()),
              ),
              const Divider(height: 0),
              ListTile(
                leading:
                Icon(Icons.privacy_tip, color: Constants.primaryColor),
                title: Text(
                    langProvider.isEnglish
                        ? 'Privacy Policy'
                        : 'سياسة الخصوصية',
                    style:
                    Theme.of(context).textTheme.bodyLarge),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openScreen(
                    context, const SupportPage()), // reuse for privacy
              ),
              const Divider(height: 0),
              ListTile(
                leading:
                Icon(Icons.description, color: Constants.primaryColor),
                title: Text(
                    langProvider.isEnglish
                        ? 'Terms of Service'
                        : 'شروط الاستخدام',
                    style:
                    Theme.of(context).textTheme.bodyLarge),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openScreen(
                    context, const SupportPage()), // reuse for ToS
              ),
              const Divider(height: 0),
              ListTile(
                leading: Icon(Icons.feedback,
                    color: Constants.primaryColor),
                title: Text(
                    langProvider.isEnglish
                        ? 'Send Feedback'
                        : 'إرسال ملاحظات',
                    style:
                    Theme.of(context).textTheme.bodyLarge),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openScreen(
                    context, const SupportPage()), // reuse feedback
              ),
            ]),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// A simple placeholder page you can reuse
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({required this.title, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Constants.primaryColor,
      ),
      body: const Center(child: Text('Coming soon!')),
    );
  }
}
