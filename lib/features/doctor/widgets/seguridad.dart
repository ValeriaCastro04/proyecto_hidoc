import 'package:flutter/material.dart';

class SecuritySettingsCard extends StatelessWidget {
  /// Esta función es OBLIGATORIA.
  /// La pantalla "padre" le pasará la lógica de logout aquí.
  final VoidCallback onLogoutTapped;

  const SecuritySettingsCard({
    super.key,
    required this.onLogoutTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la tarjeta
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Seguridad',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Única opción: Cerrar Sesión
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Cerrar sesión'),
            // Llama a la función que recibimos del "padre"
            onTap: onLogoutTapped,
          ),
        ],
      ),
    );
  }
}