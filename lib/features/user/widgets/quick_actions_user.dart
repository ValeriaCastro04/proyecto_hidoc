import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/common/global_widgets/outline_button.dart';
import 'package:proyecto_hidoc/features/user/pages/doctores_disponibles.dart';

class QuickActionsUser extends StatelessWidget {
  const QuickActionsUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlineButton(
            icon: Icons.volunteer_activism_rounded,
            text: 'General',
            onPressed: () => context.goNamed(
              DoctoresDisponiblesPage.name,           // 'DoctoresDisponibles'
              pathParameters: {'category': 'general'},
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlineButton(
            icon: Icons.medical_services_rounded,
            text: 'Especializada',
            onPressed: () => context.goNamed(
              DoctoresDisponiblesPage.name,
              pathParameters: {'category': 'especializada'},
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlineButton(
            icon: Icons.child_care_rounded,
            text: 'Pediátrica',
            onPressed: () => context.goNamed(
              DoctoresDisponiblesPage.name,
              pathParameters: {'category': 'pediatrica'},
            ),
          ),
        ),
      ],
    );
  }
}