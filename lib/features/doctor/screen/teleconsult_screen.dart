import 'package:flutter/material.dart';

class TeleconsultScreen extends StatelessWidget {
  static const String name = 'teleconsult_screen';
  const TeleconsultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teleconsult Screen'),
      ),
      body: const Center(
        child: Text('Teleconsult Screen'),
      ),
    );
  }
} 