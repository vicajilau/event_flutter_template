import 'package:event_flutter_template/core/models/organization.dart';
import 'package:event_flutter_template/ui/widgets/language_selector.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';
import 'screens.dart';

/// Main home screen widget that displays the event information and navigation
/// Features a bottom navigation bar with tabs for Agenda, Speakers, and Sponsors
class EventCollectionScreen extends StatefulWidget {
  /// Site configuration containing event details
  final List<SiteConfig> config;

  /// Data loader for fetching content from various sources
  final DataLoader dataLoader;

  /// Currently selected locale for the application
  final Locale locale;

  /// Callback function to be called when the locale changes
  final ValueChanged<Locale> localeChanged;

  final int crossAxisCount;

  final Organization organization;

  const EventCollectionScreen({
    super.key,
    required this.config,
    required this.dataLoader,
    required this.locale,
    required this.localeChanged,
    this.crossAxisCount = 4,
    required this.organization,
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
    var dataLoader = widget.dataLoader;
    if (dataLoader.config.isEmpty) {
      return const Center(child: Text("No hay organizaciones para mostrar."));
    }
    final items = dataLoader.config.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.organization.organizationName),
        actions: [
          LanguageSelector(
            currentLocale: widget.locale,
            onLanguageChanged: widget.localeChanged,
          ),
        ],
      ),
      body: GridView.builder(
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount, // Número de ítems por fila
          crossAxisSpacing: 8.0, // Espacio horizontal entre ítems
          mainAxisSpacing: 8.0, // Espacio vertical entre ítems
        ),
        itemBuilder: (BuildContext context, int index) {
          var item = items[index];
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800, minHeight: 400),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Card(
                  child: ListTile(
                    dense: true,
                    title: Text(
                      item.eventName,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      "${item.eventDates.startDate.toString()}/${item.eventDates.endDate}",
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AgendaScreen(events: [item.eventDates])),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Delete Event"),
                              content: const Text("Are you sure you want to delete this event?"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text("Delete"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      items.remove(item);
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                )
              ]
            ),
          );
        },
      ),
    );
  }

  /*void _addDay() {}

  /// Shows a dialog with event information including dates, venue, and description
  void _showEventInfo(BuildContext context,SiteConfig siteConfig) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(siteConfig.eventName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (siteConfig.eventDates != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${siteConfig.eventDates!.startDate} - ${siteConfig.eventDates!.endDate}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            if (siteConfig.venue != null) ...[
              GestureDetector(
                onTap: () => _openGoogleMaps(siteConfig.venue!),
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
                            siteConfig.venue!.name,
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
                            siteConfig.venue!.address,
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
            if (siteConfig.description != null &&
                siteConfig.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                siteConfig.description!,
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
  }*/

  /// Opens Google Maps with the venue location
  /*Future<void> _openGoogleMaps(Venue venue) async {
    final query = Uri.encodeComponent('${venue.name}, ${venue.address}');
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$query';

    // Use the extension to open URL from context
    await context.openUrl(googleMapsUrl);
  }*/
}

class AgendaCard extends StatelessWidget {
  /// Site configuration containing event details
  final List<SiteConfig> config;

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
              MaterialPageRoute(builder: (context) => AgendaScreen(events: [])),
            );
          },
        ),
      ),
    );
  }
}
