// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:plant_care/constants.dart';
import 'package:plant_care/providers/theme_provider.dart';
import 'package:plant_care/providers/language_provider.dart';
import 'package:plant_care/providers/community_provider.dart';   // ← add this import
import 'package:plant_care/l10n/app_localizations.dart';      // ← generated
import 'package:plant_care/ui/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),  // ← new provider
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, langProvider, _) {
          return MaterialApp(
            // localized title
            onGenerateTitle: (ctx) => AppLocalizations.of(ctx)!.appTitle,
            debugShowCheckedModeBanner: false,

            // THEMING
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Constants.primaryColor,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(color: Constants.primaryColor),
                titleTextStyle: TextStyle(
                  color: Constants.blackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Constants.primaryColor,
              scaffoldBackgroundColor: Colors.grey[900],
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey[850],
                elevation: 0,
                iconTheme: IconThemeData(color: Constants.primaryColor),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            themeMode: themeProvider.mode,

            // LOCALIZATION
            locale: langProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // ENTRY
            home: const OnboardingScreen(),
          );
        },
      ),
    );
  }
}
