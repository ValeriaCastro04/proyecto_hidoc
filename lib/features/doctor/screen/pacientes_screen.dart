import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/footer_doctor.dart';

class PacientesScreen extends StatelessWidget {
  static const String name = 'pacientes_screen';
  const PacientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes Screen'),
      ),
      body: const Center(
        child: Text('Pacientes Screen'),
      ),
      bottomNavigationBar: FooterGroup(buttons: doctorFooterButtons(context)) ,
    );
  }
}