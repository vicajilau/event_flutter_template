import 'package:flutter/material.dart';

import '../../core/models/agenda.dart';
import '../../core/utils/date_utils.dart';
import '../../l10n/app_localizations.dart';

class ExpansionTileState {
  final bool isExpanded;
  final int tabBarIndex;

  ExpansionTileState({required this.isExpanded, required this.tabBarIndex});
}

/// Screen that displays the event agenda with sessions organized by days and tracks
/// Supports multiple days and tracks with color-coded sessions
class AgendaScreen extends StatefulWidget {
  final List<AgendaDay> agendaDays;

  const AgendaScreen({super.key, required this.agendaDays});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  Map<String, ExpansionTileState> _expansionTilesStates = {};

  @override
  void initState() {
    super.initState();

    for (var day in widget.agendaDays) {
      _updateTileState(
        key: day.date,
        value: ExpansionTileState(isExpanded: false, tabBarIndex: 0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.agendaDays.length,
      itemBuilder: (context, index) {
        final String date = widget.agendaDays[index].date;
        final bool isExpanded =
            _expansionTilesStates[date]?.isExpanded ?? false;
        final int tabBarIndex = _expansionTilesStates[date]?.tabBarIndex ?? 0;
        return ExpansionTile(
          initiallyExpanded: isExpanded,
          showTrailingIcon: false,
          onExpansionChanged: (value) {
            setState(() {
              final tabBarIndex = _expansionTilesStates[date]?.tabBarIndex ?? 0;
              _updateTileState(
                key: date,
                value: ExpansionTileState(
                  isExpanded: value,
                  tabBarIndex: tabBarIndex,
                ),
              );
            });
          },
          title: _buildTitleExpansionTile(isExpanded, date),
          children: <Widget>[
            _buildExpansionTileBody(
              widget.agendaDays[index].tracks,
              tabBarIndex,
              date,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitleExpansionTile(bool isExpanded, String dayDate) {
    return Container(
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
              '${EventDateUtils.getDayName(dayDate, context)} - ${EventDateUtils.getFormattedDate(dayDate, context)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          AnimatedRotation(
            turns: isExpanded ? 0.5 : 0.0,
            duration: Duration(milliseconds: 200),
            child: Icon(Icons.expand_more),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTileBody(
    List<Track> tracks,
    int tabBarIndex,
    String date,
  ) {
    return DefaultTabController(
      initialIndex: tabBarIndex,
      length: tracks.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: List.generate(tracks.length, (index) {
              return Tab(text: tracks[index].name);
            }),
          ),
          CustomTabBarView(
            tracks: tracks,
            currentIndex: tabBarIndex,
            onIndexChanged: (value) {
              final isExpanded =
                  _expansionTilesStates[date]?.isExpanded ?? false;
              _updateTileState(
                key: date,
                value: ExpansionTileState(
                  isExpanded: isExpanded,
                  tabBarIndex: value,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _updateTileState({
    required String key,
    required ExpansionTileState value,
  }) {
    _expansionTilesStates[key] = value;
  }
}

class CustomTabBarView extends StatefulWidget {
  final List<Track> tracks;
  int currentIndex;
  final ValueChanged<int> onIndexChanged;

  CustomTabBarView({
    super.key,
    required this.tracks,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  State<CustomTabBarView> createState() => _CustomTabBarViewState();
}

class _CustomTabBarViewState extends State<CustomTabBarView> {
  List<SessionCards> sessionCards = [];

  @override
  void initState() {
    super.initState();
    sessionCards = List.generate(widget.tracks.length, (index) {
      return SessionCards(sessions: widget.tracks[index].sessions);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tabBarController = DefaultTabController.of(context);
    tabBarController.addListener(() {
      setState(() {
        widget.onIndexChanged(tabBarController.index);
        widget.currentIndex = tabBarController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return sessionCards[widget.currentIndex];
  }
}

class SessionCards extends StatelessWidget {
  final List<Session> sessions;

  const SessionCards({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(sessions.length, (index) {
          final session = sessions[index];
          return _buildSessionCard(
            context,
            Session(
              title: session.title,
              time: session.time,
              speaker: session.speaker,
              description: session.description,
              type: session.type,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, Session session) {
    return Card(
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
