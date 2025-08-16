import 'package:flutter/material.dart';
import 'core/core.dart';
import 'ui/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = await ConfigLoader.loadConfig();
  final dataLoader = DataLoader(config);

  runApp(MyApp(config: config, dataLoader: dataLoader));
}

class MyApp extends StatelessWidget {
  final dynamic config;
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
