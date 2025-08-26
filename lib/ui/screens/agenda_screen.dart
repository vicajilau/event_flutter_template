import 'package:flutter/material.dart';

/// Screen that displays the event agenda with sessions organized by days and tracks
/// Supports multiple days and tracks with color-coded sessions
class AgendaScreen extends StatelessWidget {
  List<String> events;

  AgendaScreen({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editando evento'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.save))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /*
          padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
          */
          ExpansionTile(
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Theme.of(
              context,
            ).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            title: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                Text(
                  'Sabado 15 de Marzo',
                  //'${EventDateUtils.getDayName(day.date, context)} - ${EventDateUtils.getFormattedDate(day.date, context)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            children: <Widget>[
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(text: 'Sala 1'),
                        Tab(text: 'Sala 2'),
                      ],
                    ),
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        children: [
                          Text('Hola, soy la sala 1'),
                          Text('Hola, soy la sala 2'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
