import 'package:flutter/material.dart';

import '../../core/models/agenda.dart';
import '../../l10n/app_localizations.dart';
import '../../core/models/event.dart';

/// Screen that displays the event agenda with sessions organized by days and tracks
/// Supports multiple days and tracks with color-coded sessions
class AgendaScreen extends StatefulWidget {
  List<String> events;

  const AgendaScreen({super.key, required this.events});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          showTrailingIcon: false,
          onExpansionChanged: (value) {
            setState(() {
              expanded = value;
            });
          },
          title: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Sabado 15 de Marzo',
                    //'${EventDateUtils.getDayName(day.date, context)} - ${EventDateUtils.getFormattedDate(day.date, context)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Icon(Icons.expand_more),
                ),
              ],
            ),
          ),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DefaultTabController(
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
                          ListView(
                            shrinkWrap: true,
                            children: [
                              _buildSessionCard(
                                context,
                                Session(
                                  title: "Prueba 1",
                                  time: "time",
                                  speaker: "Fran Cedrón",
                                  description:
                                      "Tarjeta de pruebas para crear la UI y ver como se va a la vez que la construyo",
                                  type: 'keynote',
                                ),
                              ),
                              _buildSessionCard(
                                context,
                                Session(
                                  title: "Prueba 1",
                                  time: "time",
                                  speaker: "Fran Cedrón",
                                  description:
                                      "Tarjeta de pruebas para crear la UI y ver como se va a la vez que la construyo",
                                  type: 'keynote',
                                ),
                              ),
                              _buildSessionCard(
                                context,
                                Session(
                                  title: "Prueba 1",
                                  time: "time",
                                  speaker: "Fran Cedrón",
                                  description:
                                      "Tarjeta de pruebas para crear la UI y ver como se va a la vez que la construyo",
                                  type: 'keynote',
                                ),
                              ),
                            ],
                          ),
                          Text('Hola, soy la sala 2'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSessionCard(BuildContext context, Session session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getSessionTypeColor(context, session.type),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    session.time,
                    style: TextStyle(
                      color: _getSessionTypeTextColor(context, session.type),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                if (session.type != 'break')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getSessionTypeLabel(context, session.type),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              session.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (session.speaker.isNotEmpty && session.type != 'break') ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    session.speaker,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            if (session.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                session.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getSessionTypeColor(BuildContext context, String type) {
    switch (type) {
      case 'keynote':
        return Colors.purple.shade100;
      case 'talk':
        return Theme.of(context).colorScheme.primaryContainer;
      case 'workshop':
        return Colors.green.shade100;
      case 'break':
        return Colors.orange.shade100;
      default:
        return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
  }

  Color _getSessionTypeTextColor(BuildContext context, String type) {
    switch (type) {
      case 'keynote':
        return Colors.purple.shade800;
      case 'talk':
        return Theme.of(context).colorScheme.onPrimaryContainer;
      case 'workshop':
        return Colors.green.shade800;
      case 'break':
        return Colors.orange.shade800;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  /// Returns the localized label for the given session type
  String _getSessionTypeLabel(BuildContext context, String type) {
    switch (type) {
      case 'keynote':
        return AppLocalizations.of(context)!.keynote;
      case 'talk':
        return AppLocalizations.of(context)!.talk;
      case 'workshop':
        return AppLocalizations.of(context)!.workshop;
      case 'break':
        return AppLocalizations.of(context)!.sessionBreak;
      case 'panel':
        return 'PANEL';
      default:
        return 'EVENTO';
    }
  }
}
