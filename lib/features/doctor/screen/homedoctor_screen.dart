import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/common/shared_widgets/outline_button_grid.dart'; 
import 'package:proyecto_hidoc/features/doctor/widgets/quick_actions_doctor.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/footer_doctor.dart';

class HomeDoctorScreen extends StatelessWidget {
  static const String name = 'homedoctor_screen';
  const HomeDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Hola, Dr.!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Text(
              '¿Preparado para salvar vidas?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 14),
            OutlineButtonGrid(
              title: 'Acciones Rápidas',
              buttons: doctorButtons,
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterGroup(buttons: doctorFooterButtons(context)),
    );
  }
}