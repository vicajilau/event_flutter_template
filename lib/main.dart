import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/core.dart';
import 'ui/home_screen.dart';
import 'l10n/app_localizations.dart';

/// Entry point of the Flutter application for tech events
/// Initializes configuration and data loader before running the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = await ConfigLoader.loadConfig();
  final dataLoader = DataLoader(config);

  runApp(MyApp(config: config, dataLoader: dataLoader));
}

/// Main application widget that sets up the Material Design theme and localization
/// Supports multiple languages and environments (dev, pre, pro)
class MyApp extends StatelessWidget {
  /// Site configuration containing event details and styling
  final dynamic config;

  /// Data loader for fetching speakers, agenda, and sponsors
  final dynamic dataLoader;

  const MyApp({super.key, required this.config, required this.dataLoader});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(
      int.parse(config.primaryColor.replaceFirst('#', '0xff')),
    );
    final secondaryColor = Color(
      int.parse(config.secondaryColor.replaceFirst('#', '0xff')),
    );

    return MaterialApp(
      title: config.eventName,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          secondary: secondaryColor,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        cardTheme: const CardThemeData(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      home: HomeScreen(config: config, dataLoader: dataLoader),
    );
  }
}
