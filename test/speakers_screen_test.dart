import 'package:event_flutter_template/core/core.dart';
import 'package:event_flutter_template/l10n/app_localizations.dart';
import 'package:event_flutter_template/ui/screens/speakers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SpeakersScreen Tests', () {
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
        home: Scaffold(body: child),
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
      );
    }

    /// Creates a mock DataLoader for testing
    DataLoader createMockDataLoader() {
      final config = createMockConfig();
      return DataLoader(config);
    }

    testWidgets('SpeakersScreen displays loading state initially', (
      WidgetTester tester,
    ) async {
      final dataLoader = createMockDataLoader();

      await tester.pumpWidget(
        createTestApp(SpeakersScreen(dataLoader: dataLoader)),
      );

      // Initially should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading speakers...'), findsOneWidget);
    });

    testWidgets('SpeakersScreen displays correctly in English', (
      WidgetTester tester,
    ) async {
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
          home: Scaffold(body: SpeakersScreen(dataLoader: dataLoader)),
        ),
      );

      // Should show English loading text
      expect(find.text('Loading speakers...'), findsOneWidget);
    });

    testWidgets('SpeakersScreen displays correctly in Spanish', (
      WidgetTester tester,
    ) async {
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
          home: Scaffold(body: SpeakersScreen(dataLoader: dataLoader)),
        ),
      );

      // Should show Spanish loading text
      expect(find.text('Cargando ponentes...'), findsOneWidget);
    });

    testWidgets('SpeakersScreen has correct widget structure', (
      WidgetTester tester,
    ) async {
      final dataLoader = createMockDataLoader();

      await tester.pumpWidget(
        createTestApp(SpeakersScreen(dataLoader: dataLoader)),
      );

      // Verify it's a FutureBuilder
      expect(find.byType(FutureBuilder<List<dynamic>>), findsOneWidget);
    });
  });
}
