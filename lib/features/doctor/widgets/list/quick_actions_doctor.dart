import 'package:proyecto_hidoc/common/global_widgets/outline_button.dart';  
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/features/doctor/screen/new_appointment_screen.dart';

List<Widget> doctorButtons(BuildContext context) {
  
  return [
    OutlineButton(
      onPressed: () async {
        final created = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          builder: (ctx) => Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: NewAppointmentForm(initialDay: DateTime.now()),
          ),
        );

        if (created == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Cita creada correctamente")),
          );
        }
      },
      text: 'Nueva Cita',
      icon: Icons.note_add,
    ),

    OutlineButton(
      onPressed: () => context.go('/pacientes'),
      text: 'Pacientes',
      icon: Icons.people,
    ),
    OutlineButton(
      onPressed: () => context.go('/reportes'),
      text: 'Estadísticas',
      icon: Icons.show_chart,
    ),
    OutlineButton(
      onPressed: () => context.go('/agenda'),
      text: 'Agenda',
      icon: Icons.calendar_today,
    ),
  ];
}
