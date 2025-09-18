import 'package:flutter/material.dart';

class PrescriptionScreen extends StatelessWidget {
  static const String name = 'prescription_screen';
  const PrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Screen'),
      ),
      body: const Center(
        child: Text('Prescription Screen'),
      ),
    );
  }
}