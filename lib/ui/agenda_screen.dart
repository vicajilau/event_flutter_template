import 'package:flutter/material.dart';
import '../core/core.dart';
import '../l10n/app_localizations.dart';

/// Screen that displays the event agenda with sessions organized by days and tracks
/// Supports multiple days and tracks with color-coded sessions
class AgendaScreen extends StatelessWidget {
  /// Data loader for fetching agenda information
  final DataLoader dataLoader;

  const AgendaScreen({super.key, required this.dataLoader});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AgendaDay>>(
      future: dataLoader.loadAgenda(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.loadingAgenda),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(
                    context,
                  )!.errorLoadingAgenda('${snapshot.error}'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            AgendaScreen(dataLoader: dataLoader),
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.retry),
                ),
              ],
            ),
          );
        }
        final agendaDays = snapshot.data ?? [];

        if (agendaDays.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.event_busy, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.noEventsScheduled),
              ],
            ),
          );
        }

        return DefaultTabController(
          length: agendaDays.length,
          child: Column(
            children: [
              if (agendaDays.length > 1)
                TabBar(
                  tabs: agendaDays
                      .map(
                        (day) => Tab(
                          text: EventDateUtils.getShortDayName(
                            day.date,
                            context,
                          ),
                        ),
                      )
                      .toList(),
                ),
              Expanded(
                child: TabBarView(
                  children: agendaDays
                      .map((day) => _buildDayView(context, day))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDayView(BuildContext context, AgendaDay day) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Fecha del día
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
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
              Text(
                '${EventDateUtils.getDayName(day.date, context)} - ${EventDateUtils.getFormattedDate(day.date, context)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Tracks del día
        ...day.tracks.map((track) => _buildTrackView(context, track)),
      ],
    );
  }

  Widget _buildTrackView(BuildContext context, Track track) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (track.name.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Color(
                      int.parse(track.color.replaceFirst('#', '0xff')),
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  track.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(
                      int.parse(track.color.replaceFirst('#', '0xff')),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Sesiones del track
        ...track.sessions.map((session) => _buildSessionCard(context, session)),
        const SizedBox(height: 16),
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
