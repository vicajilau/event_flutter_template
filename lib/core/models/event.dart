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
