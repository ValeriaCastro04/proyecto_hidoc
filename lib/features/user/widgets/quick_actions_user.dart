import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/common/global_widgets/outline_button.dart';

class QuickActionsUser extends StatelessWidget {
  const QuickActionsUser({super.key});

  @override
  Widget build(BuildContext context) {
    // 3 botones iguales en una fila, con el estilo de tu OutlineButton
    return Row(
      children: [
        Expanded(
          child: OutlineButton(
            icon: Icons.volunteer_activism_rounded,
            text: 'General',
            onPressed: () => context.go('/consultas'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlineButton(
            icon: Icons.medical_services_rounded,
            text: 'Especializada',
            onPressed: () => context.go('/consultas'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlineButton(
            icon: Icons.child_care_rounded,
            text: 'Pediátrica',
            onPressed: () => context.go('/consultas'),
          ),
        ),
      ],
    );
  }
}