import 'package:flutter/material.dart';
import '../../core/data_loader.dart';
import '../../core/models.dart';
import 'agenda_screen.dart';
import 'speakers_screen.dart';
import 'sponsors_screen.dart';

class HomeScreen extends StatefulWidget {
  final SiteConfig config;
  final DataLoader dataLoader;

  const HomeScreen({super.key, required this.config, required this.dataLoader});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      AgendaScreen(dataLoader: widget.dataLoader),
      SpeakersScreen(dataLoader: widget.dataLoader),
      SponsorsScreen(dataLoader: widget.dataLoader),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.config.eventName)),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Speakers'),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Sponsors',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
