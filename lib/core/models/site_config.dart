import 'event.dart';

/// Main configuration class for the event site
/// Contains all the essential information needed to configure and display an event
/// including branding, dates, venue, and deployment settings
class SiteConfig {
  /// The name of the event (e.g., "DevFest Spain 2025")
  final String eventName;

  /// The year of the event, used for organizing multi-year events
  final String year;

  /// The base URL for data loading (local assets or remote URLs)
  final String baseUrl;

  /// Primary color for the event theme in hex format (e.g., "#4285F4")
  final String primaryColor;

  /// Secondary color for the event theme in hex format (e.g., "#34A853")
  final String secondaryColor;

  /// Event date information including start, end dates and timezone
  final EventDates? eventDates;

  /// Venue information where the event will take place
  final Venue? venue;

  /// Optional description of the event
  final String? description;

  /// Creates a new SiteConfig instance
  SiteConfig({
    required this.eventName,
    required this.year,
    required this.baseUrl,
    required this.primaryColor,
    required this.secondaryColor,
    this.eventDates,
    this.venue,
    this.description,
  });

  /// Creates a SiteConfig from JSON data with additional parameters
  ///
  /// The [json] parameter contains the configuration data from site.json
  /// The [baseUrl] parameter specifies where to load data from (local or remote)
  /// The [year] parameter identifies which event year this configuration represents
  ///
  /// Optional fields (eventDates, venue, description) will be null if not provided
  factory SiteConfig.fromJson(
    Map<String, dynamic> json, {
    required String baseUrl,
    required String year,
  }) {
    return SiteConfig(
        eventName: json['eventName'],
        year: year,
        baseUrl: baseUrl,
        primaryColor: json['primaryColor'],
        secondaryColor: json['secondaryColor'],
        eventDates: json['eventDates'] != null
            ? EventDates.fromJson(json['eventDates'])
            : null,
        venue: json['venue'] != null ? Venue.fromJson(json['venue']) : null,
        description: json['description'],
      );
  }
}
