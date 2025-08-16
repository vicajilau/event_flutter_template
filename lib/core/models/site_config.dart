import 'event.dart';

class SiteConfig {
  final String eventName;
  final String year;
  final String baseUrl;
  final String primaryColor;
  final String secondaryColor;
  final EventDates? eventDates;
  final Venue? venue;
  final String? description;

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
