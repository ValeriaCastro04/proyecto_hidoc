import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/config/global_widgets/quick_actions.dart';

class HomeDoctorScreen extends StatelessWidget  {
  static const String name = 'homedoctor_screen';
  const HomeDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen Doctor'),
      ),
      body: Center(
        child: QuickActionsButton(
          onPressed: () {
            print('Quick Actions Pressed');
          },
          text: 'Nueva receta',
          icon: Icons.description
        )
      ),    
    );
  }
}