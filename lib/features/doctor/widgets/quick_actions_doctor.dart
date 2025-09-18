import 'package:proyecto_hidoc/common/global_widgets/quick_action.dart'; // Asegúrate de que la ruta sea correcta
import 'package:flutter/material.dart';

final List<Widget> doctorButtons = [
      QuickActionsButton(
        onPressed: () {
          print('Nueva Receta');
        },
        text: 'Nueva Receta',
        icon: Icons.description,
      ),
      QuickActionsButton(
        onPressed: () {
          print('Pacientes');
        },
        /** ejemplo de enrutar otra página
         * onPressed: () {
            context.go('/nueva_receta'); // Usa el nombre de la ruta definido en tu enrutador
          },
         */
        text: 'Pacientes',
        icon: Icons.people,
      ),
      QuickActionsButton(
        onPressed: () {
          print('Estadísticas');
        },
        text: 'Estadísticas',
        icon: Icons.show_chart,
      ),
      QuickActionsButton(
        onPressed: () {
          print('Agenda');
        },
        text: 'Agenda',
        icon: Icons.calendar_today,
      ),
    ];
