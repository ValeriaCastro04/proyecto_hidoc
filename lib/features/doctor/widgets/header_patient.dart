import 'package:flutter/material.dart';

class PatientHeader extends StatelessWidget implements PreferredSizeWidget {
  final String patientName;
  final String initials;

  const PatientHeader({
    super.key,
    required this.patientName,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Botón de regreso
            const SizedBox(width: 8.0),
            // Avatar del paciente
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              child: Text(
                initials,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            // Nombre del paciente
            Text(
              patientName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            // Botones de llamada y video
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.phone_outlined, color: Theme.of(context).colorScheme.onSurface),
                  onPressed: () {
                    // Lógica para iniciar llamada
                  },
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.videocam_outlined, color: Theme.of(context).colorScheme.onSurface),
                  onPressed: () {
                    // Lógica para iniciar videollamada
                  },
                ),
                const SizedBox(width: 8.0),
                // Menú de opciones
                IconButton(
                  icon: Icon(Icons.more_vert_rounded, color: Theme.of(context).colorScheme.onSurface),
                  onPressed: () {
                    // Lógica para opciones adicionales
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}