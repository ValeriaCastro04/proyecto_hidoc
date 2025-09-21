import 'package:flutter/material.dart';

class HomeUserScreen extends StatelessWidget {
  static const String name = 'HomeUser';

  const HomeUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HiDoc — Paciente')),
      body: const Center(child: Text('Home de Paciente')),
    );
  }
}