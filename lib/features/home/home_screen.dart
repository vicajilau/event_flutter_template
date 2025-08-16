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
      appBar: AppBar(
        title: Text(widget.config.eventName),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showEventInfo(context),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.schedule),
            selectedIcon: Icon(Icons.schedule),
            label: 'Agenda',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Speakers',
          ),
          NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business),
            label: 'Sponsors',
          ),
        ],
      ),
    );
  }

  void _showEventInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.config.eventName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Año: ${widget.config.year}'),
            const SizedBox(height: 8),
            const Text(
              '¡Bienvenido al evento tecnológico más importante del año!',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
