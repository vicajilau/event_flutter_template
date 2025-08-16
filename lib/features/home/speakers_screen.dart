import 'package:flutter/material.dart';
import '../../core/data_loader.dart';

class SpeakersScreen extends StatelessWidget {
  final DataLoader dataLoader;
  const SpeakersScreen({super.key, required this.dataLoader});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: dataLoader.loadSpeakers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error cargando ponentes'));
        }
        final speakers = snapshot.data ?? [];
        return ListView.builder(
          itemCount: speakers.length,
          itemBuilder: (context, index) {
            final speaker = speakers[index];
            return ListTile(
              leading: speaker['image'] != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(speaker['image']),
                    )
                  : null,
              title: Text(speaker['name'] ?? ''),
              subtitle: Text(speaker['bio'] ?? ''),
            );
          },
        );
      },
    );
  }
}
