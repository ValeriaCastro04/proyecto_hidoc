import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/common/shared_widgets/quick_actions_grid.dart'; // Asegúrate de que la ruta sea correcta
import 'package:proyecto_hidoc/features/doctor/widgets/quick_actions_doctor.dart'; // Asegúrate de que la ruta sea correcta
import 'package:proyecto_hidoc/features/doctor/widgets/footer_doctor.dart';

class HomeDoctorScreen extends StatelessWidget {
  static const String name = 'homedoctor_screen';
  const HomeDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen Doctor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Agregamos el widget de la cuadrícula de botones
            QuickActionsGrid(
              title: 'Acciones Rápidas',
              buttons: doctorButtons,
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterGroup(buttons: doctorFooterButtons),
    );
  }
}