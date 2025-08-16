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

class EventDates {
  final String startDate;
  final String endDate;
  final String timezone;

  EventDates({
    required this.startDate,
    required this.endDate,
    required this.timezone,
  });

  factory EventDates.fromJson(Map<String, dynamic> json) {
    return EventDates(
      startDate: json['startDate'],
      endDate: json['endDate'],
      timezone: json['timezone'],
    );
  }
}

class Venue {
  final String name;
  final String address;
  final String city;

  Venue({required this.name, required this.address, required this.city});

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      name: json['name'],
      address: json['address'],
      city: json['city'],
    );
  }
}

class AgendaDay {
  final String date;
  final String dayName;
  final List<Track> tracks;

  AgendaDay({required this.date, required this.dayName, required this.tracks});

  factory AgendaDay.fromJson(Map<String, dynamic> json) {
    return AgendaDay(
      date: json['date'],
      dayName: json['dayName'],
      tracks: (json['tracks'] as List)
          .map((track) => Track.fromJson(track))
          .toList(),
    );
  }
}

class Track {
  final String name;
  final String color;
  final List<Session> sessions;

  Track({required this.name, required this.color, required this.sessions});

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      name: json['name'],
      color: json['color'],
      sessions: (json['sessions'] as List)
          .map((session) => Session.fromJson(session))
          .toList(),
    );
  }
}

class Session {
  final String title;
  final String time;
  final String speaker;
  final String description;
  final String type;

  Session({
    required this.title,
    required this.time,
    required this.speaker,
    required this.description,
    required this.type,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      title: json['title'],
      time: json['time'],
      speaker: json['speaker'],
      description: json['description'],
      type: json['type'],
    );
  }
}
