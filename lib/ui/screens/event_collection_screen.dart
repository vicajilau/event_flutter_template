import 'package:event_flutter_template/ui/screens/event_container_screen.dart';
import 'package:event_flutter_template/ui/widgets/language_selector.dart';
import 'package:event_flutter_template/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../l10n/app_localizations.dart';

/// Main home screen widget that displays the event information and navigation
/// Features a bottom navigation bar with tabs for Agenda, Speakers, and Sponsors
class EventCollectionScreen extends StatefulWidget {
  /// Site configuration containing event details
  final SiteConfig config;

  /// Data loader for fetching content from various sources
  final DataLoader dataLoader;

  /// Currently selected locale for the application
  final Locale locale;

  /// Callback function to be called when the locale changes
  final ValueChanged<Locale> localeChanged;

  const EventCollectionScreen({
    super.key,
    required this.config,
    required this.dataLoader,
    required this.locale,
    required this.localeChanged,
  });

  @override
  State<EventCollectionScreen> createState() => _EventCollectionScreenState();
}

/// State class for HomeScreen that manages navigation between tabs
class _EventCollectionScreenState extends State<EventCollectionScreen> {
  /// Initializes the screens list with data loader
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.config.eventName),
        actions: [
          LanguageSelector(
            currentLocale: widget.locale,
            onLanguageChanged: widget.localeChanged,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showEventInfo(context),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          AgendaCard(
            config: widget.config,
            dataLoader: widget.dataLoader,
            locale: widget.locale,
            localeChanged: widget.localeChanged,
          ),
        ],
      ),
    );
  }

  void _addDay() {}

  /// Shows a dialog with event information including dates, venue, and description
  void _showEventInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.config.eventName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.config.eventDates != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.config.eventDates!.startDate} - ${widget.config.eventDates!.endDate}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            if (widget.config.venue != null) ...[
              GestureDetector(
                onTap: () => _openGoogleMaps(widget.config.venue!),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.config.venue!.name,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                ),
                          ),
                          Text(
                            widget.config.venue!.address,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.openUrl,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (widget.config.description != null &&
                widget.config.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                widget.config.description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ] else ...[
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.description),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  /// Opens Google Maps with the venue location
  Future<void> _openGoogleMaps(Venue venue) async {
    final query = Uri.encodeComponent('${venue.name}, ${venue.address}');
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$query';

    // Use the extension to open URL from context
    await context.openUrl(googleMapsUrl);
  }
}

class AgendaCard extends StatelessWidget {
  /// Site configuration containing event details
  final SiteConfig config;

  /// Data loader for fetching content from various sources
  final DataLoader dataLoader;

  /// Currently selected locale for the application
  final Locale locale;

  /// Callback function to be called when the locale changes
  final ValueChanged<Locale> localeChanged;

  const AgendaCard({
    super.key,
    required this.config,
    required this.dataLoader,
    required this.locale,
    required this.localeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: ListTile(
          leading: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              print('edit');
            },
          ),
          title: Text('DevFest Spain 2025'),
          subtitle: Text('12/10/25 - 15/10/25'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              print("delete");
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventContainerScreen(
                  config: config,
                  dataLoader: dataLoader,
                  locale: locale,
                  localeChanged: localeChanged,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
