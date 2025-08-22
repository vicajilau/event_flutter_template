import 'package:flutter/material.dart';

class SpeakersFormScreen extends StatelessWidget {
  const SpeakersFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir Speaker')),
      body: Center(child: const Text("Speakers form Screen")),
    );
  }
}
