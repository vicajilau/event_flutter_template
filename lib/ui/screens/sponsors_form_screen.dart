import 'package:flutter/material.dart';

class SponsorsFormScreen extends StatelessWidget {
  const SponsorsFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir Sponsor')),
      body: Center(child: const Text("Sponsors form Screen")),
    );
  }
}
