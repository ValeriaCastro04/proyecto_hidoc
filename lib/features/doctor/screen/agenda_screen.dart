import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/footer_doctor.dart';

class AgendaScreen extends StatelessWidget {
  static const String name = 'agenda_screen';
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Screen'),
      ),
      body: const Center(
        child: Text('Agenda Screen'),
      ),
      bottomNavigationBar: FooterGroup(buttons: doctorFooterButtons(context)),
    );
  }
}