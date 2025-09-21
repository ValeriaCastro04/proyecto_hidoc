import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer.dart';
import 'package:proyecto_hidoc/features/user/widgets/footer_user.dart';

class HistorialScreen extends StatelessWidget {
  static const String name = 'HomeUser';
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HiDoc — Paciente')),
      body: const Center(child: Text('Home de Paciente')),
      bottomNavigationBar: Footer(
        buttons: userFooterButtons(context, current: UserTab.home),
      ),
    );
  }
}