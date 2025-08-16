import 'package:flutter/material.dart';
import '../../core/data_loader.dart';

class AgendaScreen extends StatelessWidget {
  final DataLoader dataLoader;
  const AgendaScreen({super.key, required this.dataLoader});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: dataLoader.loadAgenda(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error cargando agenda'));
        }
        final agenda = snapshot.data ?? [];
        return ListView.builder(
          itemCount: agenda.length,
          itemBuilder: (context, index) {
            final item = agenda[index];
            return ListTile(
              title: Text(item['title'] ?? ''),
              subtitle: Text(item['time'] ?? ''),
            );
          },
        );
      },
    );
  }
}
