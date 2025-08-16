import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

/// Extensions for Widget class to add common functionality
extension WidgetExtensions on Widget {
  /// Launches a URL with proper error handling and formatting
  ///
  /// Automatically adds https:// protocol if missing
  /// Shows debug messages on errors
  ///
  /// Usage:
  /// ```dart
  /// widget.openUrl('https://example.com');
  /// widget.openUrl('example.com'); // automatically adds https://
  /// ```
  Future<void> openUrl(String url) async {
    try {
      // Asegurar que la URL tenga el protocolo correcto
      String formattedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        formattedUrl = 'https://$url';
      }

      final uri = Uri.parse(formattedUrl);

      if (await url_launcher.canLaunchUrl(uri)) {
        await url_launcher.launchUrl(
          uri,
          mode: url_launcher.LaunchMode.externalApplication,
        );
      } else {
        debugPrint('No se pudo abrir la URL: $formattedUrl');
      }
    } catch (e) {
      debugPrint('Error al abrir URL: $e');
    }
  }
}

/// Extensions for BuildContext to add common functionality
extension BuildContextExtensions on BuildContext {
  /// Launches a URL with proper error handling and formatting
  ///
  /// This is a convenience method that can be called from any BuildContext
  ///
  /// Usage:
  /// ```dart
  /// context.openUrl('https://example.com');
  /// ```
  Future<void> openUrl(String url) async {
    try {
      // Asegurar que la URL tenga el protocolo correcto
      String formattedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        formattedUrl = 'https://$url';
      }

      final uri = Uri.parse(formattedUrl);

      if (await url_launcher.canLaunchUrl(uri)) {
        await url_launcher.launchUrl(
          uri,
          mode: url_launcher.LaunchMode.externalApplication,
        );
      } else {
        debugPrint('No se pudo abrir la URL: $formattedUrl');
      }
    } catch (e) {
      debugPrint('Error al abrir URL: $e');
    }
  }

  /// Shows a snackbar with the given message
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Shows an error snackbar with red background
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(this).colorScheme.error,
      ),
    );
  }
}
