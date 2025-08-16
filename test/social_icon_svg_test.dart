import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:event_flutter_template/ui/widgets/social_icon_svg.dart';

void main() {
  group('Social Icon SVG Widget Tests', () {
    /// Creates a test app wrapper
    Widget createTestApp(Widget child) {
      return MaterialApp(home: Scaffold(body: child));
    }

    testWidgets('SocialIconSvg displays correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          const SocialIconSvg(
            svgPath: 'assets/test_icon.svg',
            url: 'https://example.com',
            color: Colors.blue,
            tooltip: 'Test Social',
          ),
        ),
      );

      // Verify tooltip is present
      expect(find.byTooltip('Test Social'), findsOneWidget);

      // Verify InkWell is present for tap functionality
      expect(find.byType(InkWell), findsOneWidget);

      // Verify Container with decoration is present
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('SocialIconSvg with custom size displays correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          const SocialIconSvg(
            svgPath: 'assets/test_icon.svg',
            url: 'https://example.com',
            color: Colors.red,
            tooltip: 'Custom Size Icon',
            iconSize: 24,
            padding: 12,
          ),
        ),
      );

      // Verify tooltip is present
      expect(find.byTooltip('Custom Size Icon'), findsOneWidget);

      // Verify widget structure
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('SocialIconsRow displays correctly with social data', (
      WidgetTester tester,
    ) async {
      final socialData = {
        'twitter': 'https://twitter.com/test',
        'linkedin': 'https://linkedin.com/in/test',
        'github': 'https://github.com/test',
        'website': 'https://test.com',
      };

      await tester.pumpWidget(
        createTestApp(SocialIconsRow(social: socialData)),
      );

      // Verify Row widget is present
      expect(find.byType(Row), findsOneWidget);

      // Verify multiple SocialIconSvg widgets are present
      expect(find.byType(SocialIconSvg), findsNWidgets(4));

      // Verify specific tooltips
      expect(find.byTooltip('Twitter/X'), findsOneWidget);
      expect(find.byTooltip('LinkedIn'), findsOneWidget);
      expect(find.byTooltip('GitHub'), findsOneWidget);
      expect(find.byTooltip('Website'), findsOneWidget);
    });

    testWidgets('SocialIconsRow handles null social data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(const SocialIconsRow(social: null)),
      );

      // Should display SizedBox.shrink() for null data
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(SocialIconSvg), findsNothing);
    });

    testWidgets('SocialIconsRow handles empty social data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp(const SocialIconsRow(social: {})));

      // Should display SizedBox.shrink() for empty data
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(SocialIconSvg), findsNothing);
    });

    testWidgets('SocialIconsRow displays partial social data', (
      WidgetTester tester,
    ) async {
      final socialData = {
        'twitter': 'https://twitter.com/test',
        'linkedin': 'https://linkedin.com/in/test',
        // Missing github and website
      };

      await tester.pumpWidget(
        createTestApp(SocialIconsRow(social: socialData)),
      );

      // Verify Row widget is present
      expect(find.byType(Row), findsOneWidget);

      // Verify only 2 SocialIconSvg widgets are present
      expect(find.byType(SocialIconSvg), findsNWidgets(2));

      // Verify specific tooltips present
      expect(find.byTooltip('Twitter/X'), findsOneWidget);
      expect(find.byTooltip('LinkedIn'), findsOneWidget);

      // Verify missing tooltips are not present
      expect(find.byTooltip('GitHub'), findsNothing);
      expect(find.byTooltip('Website'), findsNothing);
    });

    testWidgets('SocialIconSvg with tint parameter works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          const SocialIconSvg(
            svgPath: 'assets/test_icon.svg',
            url: 'https://example.com',
            color: Colors.green,
            tooltip: 'Tinted Icon',
            tint: true,
          ),
        ),
      );

      // Verify tooltip is present
      expect(find.byTooltip('Tinted Icon'), findsOneWidget);

      // Verify InkWell is present for tap functionality
      expect(find.byType(InkWell), findsOneWidget);
    });
  });
}
