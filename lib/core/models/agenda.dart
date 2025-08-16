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
