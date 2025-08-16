import 'package:flutter_test/flutter_test.dart';
import 'package:event_flutter_template/core/core.dart';

void main() {
  group('Core Models Tests', () {
    group('SiteConfig Tests', () {
      test('SiteConfig.fromJson creates object correctly', () {
        final json = {
          'eventName': 'DevFest 2025',
          'primaryColor': '#1976D2',
          'secondaryColor': '#FFC107',
          'description': 'Test event description',
          'eventDates': {
            'startDate': '2025-09-15',
            'endDate': '2025-09-16',
            'timezone': 'Europe/Madrid',
          },
          'venue': {
            'name': 'Test Venue',
            'address': '123 Test Street',
            'city': 'Test City',
          },
        };

        final config = SiteConfig.fromJson(
          json,
          baseUrl: 'https://example.com',
          year: '2025',
        );

        expect(config.eventName, 'DevFest 2025');
        expect(config.year, '2025');
        expect(config.baseUrl, 'https://example.com');
        expect(config.primaryColor, '#1976D2');
        expect(config.secondaryColor, '#FFC107');
        expect(config.description, 'Test event description');
        expect(config.eventDates, isNotNull);
        expect(config.venue, isNotNull);
      });

      test('SiteConfig.fromJson handles null optional fields', () {
        final json = {
          'eventName': 'DevFest 2025',
          'primaryColor': '#1976D2',
          'secondaryColor': '#FFC107',
        };

        final config = SiteConfig.fromJson(
          json,
          baseUrl: 'https://example.com',
          year: '2025',
        );

        expect(config.eventName, 'DevFest 2025');
        expect(config.description, isNull);
        expect(config.eventDates, isNull);
        expect(config.venue, isNull);
      });
    });

    group('EventDates Tests', () {
      test('EventDates.fromJson creates object correctly', () {
        final json = {
          'startDate': '2025-09-15',
          'endDate': '2025-09-16',
          'timezone': 'Europe/Madrid',
        };

        final eventDates = EventDates.fromJson(json);

        expect(eventDates.startDate, '2025-09-15');
        expect(eventDates.endDate, '2025-09-16');
        expect(eventDates.timezone, 'Europe/Madrid');
      });
    });

    group('Venue Tests', () {
      test('Venue.fromJson creates object correctly', () {
        final json = {
          'name': 'Test Venue',
          'address': '123 Test Street',
          'city': 'Test City',
        };

        final venue = Venue.fromJson(json);

        expect(venue.name, 'Test Venue');
        expect(venue.address, '123 Test Street');
        expect(venue.city, 'Test City');
      });
    });

    group('AgendaDay Tests', () {
      test('AgendaDay.fromJson creates object correctly', () {
        final json = {
          'date': '2025-09-15',
          'dayName': 'Day 1',
          'tracks': [
            {
              'name': 'Main Track',
              'color': '#1976D2',
              'sessions': [
                {
                  'title': 'Opening Keynote',
                  'time': '09:00 - 10:00',
                  'speaker': 'John Doe',
                  'description': 'Welcome to the event',
                  'type': 'keynote',
                },
              ],
            },
          ],
        };

        final agendaDay = AgendaDay.fromJson(json);

        expect(agendaDay.date, '2025-09-15');
        expect(agendaDay.dayName, 'Day 1');
        expect(agendaDay.tracks.length, 1);
        expect(agendaDay.tracks[0].name, 'Main Track');
        expect(agendaDay.tracks[0].sessions.length, 1);
        expect(agendaDay.tracks[0].sessions[0].title, 'Opening Keynote');
      });
    });

    group('Track Tests', () {
      test('Track.fromJson creates object correctly', () {
        final json = {
          'name': 'Mobile Track',
          'color': '#4CAF50',
          'sessions': [
            {
              'title': 'Flutter Best Practices',
              'time': '10:00 - 11:00',
              'speaker': 'Jane Smith',
              'description': 'Learn Flutter best practices',
              'type': 'talk',
            },
          ],
        };

        final track = Track.fromJson(json);

        expect(track.name, 'Mobile Track');
        expect(track.color, '#4CAF50');
        expect(track.sessions.length, 1);
        expect(track.sessions[0].title, 'Flutter Best Practices');
        expect(track.sessions[0].type, 'talk');
      });
    });

    group('Session Tests', () {
      test('Session.fromJson creates object correctly', () {
        final json = {
          'title': 'Advanced Flutter Techniques',
          'time': '14:00 - 15:00',
          'speaker': 'Tech Expert',
          'description': 'Deep dive into advanced Flutter techniques',
          'type': 'workshop',
        };

        final session = Session.fromJson(json);

        expect(session.title, 'Advanced Flutter Techniques');
        expect(session.time, '14:00 - 15:00');
        expect(session.speaker, 'Tech Expert');
        expect(
          session.description,
          'Deep dive into advanced Flutter techniques',
        );
        expect(session.type, 'workshop');
      });

      test('Session.fromJson handles empty fields correctly', () {
        final json = {
          'title': 'Coffee Break',
          'time': '10:30 - 11:00',
          'speaker': '',
          'description': '',
          'type': 'break',
        };

        final session = Session.fromJson(json);

        expect(session.title, 'Coffee Break');
        expect(session.time, '10:30 - 11:00');
        expect(session.speaker, '');
        expect(session.description, '');
        expect(session.type, 'break');
      });
    });
  });
}
