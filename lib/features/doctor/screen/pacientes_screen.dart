import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/component/patient_item_list.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/footer_doctor.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/patients.dart';

class PacientesScreen extends StatelessWidget {
  static const String name = 'pacientes_screen';
  const PacientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        title: 'Dra. Elena Martínez',
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded,
                color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: const Text('EM'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 12.0, bottom: 10.0),
        itemCount: mockPatients.length,
        itemBuilder: (context, index) {
          final patient = mockPatients[index];
          return PatientListItem(
            patientName: patient['name']!,
            initials: patient['initials']!,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Abrir detalle de ${patient['name']}')),
              );
            },
          );
        },
      ),
      bottomNavigationBar: FooterGroup(buttons: doctorFooterButtons(context)),
    );
  }
}
