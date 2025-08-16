import 'package:flutter/material.dart';
import 'core/config_loader.dart';
import 'core/data_loader.dart';
import 'features/home/home_screen.dart';

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
    return MaterialApp(
      title: config.eventName,
      theme: ThemeData(
        primaryColor: Color(int.parse(config.primaryColor.replaceFirst('#', '0xff'))),
      ),
      home: HomeScreen(config: config, dataLoader: dataLoader),
    );
  }
}
