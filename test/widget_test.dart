// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:event_flutter_template/core/core.dart';
import 'package:event_flutter_template/ui/screens/home_screen.dart';
import 'package:event_flutter_template/l10n/app_localizations.dart';

void main() {
  group('Event Flutter Template Tests', () {
    /// Creates a test app with proper localization setup
    Widget createTestApp(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('es')],
        home: child,
      );
    }

    /// Creates a mock SiteConfig for testing
    SiteConfig createMockConfig() {
      return SiteConfig(
        eventName: 'Test Event 2025',
        year: '2025',
        baseUrl: 'https://example.com',
        primaryColor: '#1976D2',
        secondaryColor: '#FFC107',
        eventDates: EventDates(
          startDate: '2025-09-15',
          endDate: '2025-09-16',
          timezone: 'Europe/Madrid',
        ),
        venue: Venue(
          name: 'Test Venue',
          address: '123 Test Street',
          city: 'Test City',
        ),
        description: 'A test event for testing purposes',
      );
    }

    /// Creates a mock DataLoader for testing
    DataLoader createMockDataLoader() {
      final config = createMockConfig();
      return DataLoader(config);
    }

    testWidgets('HomeScreen displays correctly with navigation tabs', (
      WidgetTester tester,
    ) async {
      final config = createMockConfig();
      final dataLoader = createMockDataLoader();

      await tester.pumpWidget(
        createTestApp(HomeScreen(config: config, dataLoader: dataLoader, locale: const Locale('en'), localeChanged: (_) {})),
      );

      // Wait for any async operations
      await tester.pumpAndSettle();

      // Verify the app bar displays the event name
      expect(find.text('Test Event 2025'), findsOneWidget);

      // Verify navigation tabs are present
      expect(find.text('Agenda'), findsOneWidget);
      expect(find.text('Speakers'), findsOneWidget);
      expect(find.text('Sponsors'), findsOneWidget);

      // Verify the info button is present
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('Navigation between tabs works correctly', (
      WidgetTester tester,
    ) async {
      final config = createMockConfig();
      final dataLoader = createMockDataLoader();

      await tester.pumpWidget(
        createTestApp(HomeScreen(config: config, dataLoader: dataLoader, locale: const Locale('en'), localeChanged: (_) {})),
      );

      await tester.pumpAndSettle();

      // Initially should be on Agenda tab (index 0)
      expect(find.text('Agenda'), findsOneWidget);

      // Tap on Speakers tab
      await tester.tap(find.text('Speakers'));
      await tester.pumpAndSettle();

      // Verify we're still seeing the navigation
      expect(find.text('Speakers'), findsOneWidget);

      // Tap on Sponsors tab
      await tester.tap(find.text('Sponsors'));
      await tester.pumpAndSettle();

      // Verify we're still seeing the navigation
      expect(find.text('Sponsors'), findsOneWidget);
    });

    testWidgets('Event info dialog displays correctly', (
      WidgetTester tester,
    ) async {
      final config = createMockConfig();
      final dataLoader = createMockDataLoader();

      await tester.pumpWidget(
        createTestApp(HomeScreen(config: config, dataLoader: dataLoader, locale: const Locale('en'), localeChanged: (_) {})),
      );

      await tester.pumpAndSettle();

      // Tap the info button
      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();

      // Verify dialog content
      expect(find.text('Test Event 2025'), findsWidgets);
      expect(find.text('2025-09-15 - 2025-09-16'), findsOneWidget);
      expect(find.text('Test Venue'), findsOneWidget);
      expect(find.textContaining('Test'), findsWidgets);
      expect(find.text('A test event for testing purposes'), findsOneWidget);

      // Verify close button
      expect(find.text('Close'), findsOneWidget);

      // Close the dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.text('Close'), findsNothing);
    });

    testWidgets('Localization works correctly for English', (
      WidgetTester tester,
    ) async {
      final config = createMockConfig();
      final dataLoader = createMockDataLoader();

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('es')],
          home: HomeScreen(config: config, dataLoader: dataLoader, locale: const Locale('en'), localeChanged: (_) {}),
        ),
      );

      await tester.pumpAndSettle();

      // Verify English navigation labels
      expect(find.text('Agenda'), findsOneWidget);
      expect(find.text('Speakers'), findsOneWidget);
      expect(find.text('Sponsors'), findsOneWidget);
    });

    testWidgets('Localization works correctly for Spanish', (
      WidgetTester tester,
    ) async {
      final config = createMockConfig();
      final dataLoader = createMockDataLoader();

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('es')],
          home: HomeScreen(config: config, dataLoader: dataLoader, locale: const Locale('es'), localeChanged: (_) {}),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Spanish navigation labels
      expect(find.text('Agenda'), findsOneWidget);
      expect(find.text('Ponentes'), findsOneWidget);
      expect(find.text('Patrocinadores'), findsOneWidget);
    });
  });
}
