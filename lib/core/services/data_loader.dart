import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../models/models.dart';

/// Service class responsible for loading event data from various sources
/// Supports both local asset loading and remote HTTP loading based on configuration
class DataLoader {
  /// Site configuration containing base URL and other settings
  final SiteConfig config;

  /// Creates a new DataLoader with the specified configuration
  DataLoader(this.config);

  /// Generic method to load data from a specified path
  /// Automatically determines whether to load from local assets or remote URL
  /// based on the configuration's base URL
  ///
  /// [path] The relative path to the data file
  /// Returns a Future containing the parsed JSON data as a dynamic list
  /// Throws an Exception if the data cannot be loaded
  Future<List<dynamic>> _loadData(String path) async {
    String content;
    if (config.baseUrl.startsWith('http')) {
      // Remote loading
      final url = '${config.baseUrl}/$path';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) {
        throw Exception("Error loading data from $url");
      }
      content = res.body;
    } else {
      // Local loading
      final localPath = '${config.baseUrl}/$path';
      content = await rootBundle.loadString(localPath);
    }
    return json.decode(content);
  }

  /// Loads speaker information from the speakers.json file
  /// Returns a Future containing a list of speaker data
  Future<List<dynamic>> loadSpeakers() async {
    return _loadData('speakers/speakers.json');
  }

  /// Loads event agenda information from the agenda.json file
  /// Parses the JSON structure and returns a list of AgendaDay objects
  /// with proper type conversion and validation
  /// Returns a Future containing a list of AgendaDay models
  Future<List<AgendaDay>> loadAgenda() async {
    String content;
    if (config.baseUrl.startsWith('http')) {
      // Remote loading
      final url = '${config.baseUrl}/config/agenda.json';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) {
        throw Exception("Error loading agenda from $url");
      }
      content = res.body;
    } else {
      // Local loading
      final localPath = '${config.baseUrl}/config/agenda.json';
      content = await rootBundle.loadString(localPath);
    }
    final agendaData = json.decode(content);
    return (agendaData['days'] as List)
        .map((day) => AgendaDay.fromJson(day))
        .toList();
  }

  /// Loads sponsor information from the sponsors.json file
  /// Returns a Future containing a list of sponsor data with logos and details
  Future<List<dynamic>> loadSponsors() async {
    return _loadData('sponsors/sponsors.json');
  }
}
