import 'package:flutter/material.dart';

class HomeDoctorScreen extends StatelessWidget  {
  static const String name = 'homedoctor_screen';
  const HomeDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen Doctor'),
      ),
      body: const Center(
        child: Text('Home Screen Doctor'),
      ),
    );
  }
}