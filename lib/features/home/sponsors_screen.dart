import 'package:flutter/material.dart';
import '../../core/data_loader.dart';

class SponsorsScreen extends StatelessWidget {
  final DataLoader dataLoader;
  const SponsorsScreen({super.key, required this.dataLoader});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: dataLoader.loadSponsors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error cargando sponsors'));
        }
        final sponsors = snapshot.data ?? [];
        return ListView.builder(
          itemCount: sponsors.length,
          itemBuilder: (context, index) {
            final sponsor = sponsors[index];
            return ListTile(
              leading: sponsor['logo'] != null
                  ? Image.network(sponsor['logo'], width: 40, height: 40)
                  : null,
              title: Text(sponsor['name'] ?? ''),
              subtitle: Text(sponsor['type'] ?? ''),
            );
          },
        );
      },
    );
  }
}
