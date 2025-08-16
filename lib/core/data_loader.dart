import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'models.dart';

class DataLoader {
  final SiteConfig config;

  DataLoader(this.config);

  Future<List<dynamic>> _loadData(String path) async {
    String content;
    if (config.baseUrl.startsWith('http')) {
      // Carga remota
      final url = '${config.baseUrl}/$path';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200)
        throw Exception("Error cargando datos desde $url");
      content = res.body;
    } else {
      // Carga local
      final localPath = '${config.baseUrl}/$path';
      content = await rootBundle.loadString(localPath);
    }
    return json.decode(content);
  }

  Future<List<dynamic>> loadSpeakers() async {
    return _loadData('speakers/speakers.json');
  }

  Future<List<AgendaDay>> loadAgenda() async {
    String content;
    if (config.baseUrl.startsWith('http')) {
      // Carga remota
      final url = '${config.baseUrl}/config/agenda.json';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200)
        throw Exception("Error cargando agenda desde $url");
      content = res.body;
    } else {
      // Carga local
      final localPath = '${config.baseUrl}/config/agenda.json';
      content = await rootBundle.loadString(localPath);
    }
    final agendaData = json.decode(content);
    return (agendaData['days'] as List)
        .map((day) => AgendaDay.fromJson(day))
        .toList();
  }

  Future<List<dynamic>> loadSponsors() async {
    return _loadData('sponsors/sponsors.json');
  }
}
