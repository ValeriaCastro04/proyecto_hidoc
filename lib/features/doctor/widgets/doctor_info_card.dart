import 'package:flutter/material.dart';

class InfoTab extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const InfoTab({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    // --- Helper para obtener la inicial del nombre ---
    String getInitials(String? name) {
      if (name == null || name.isEmpty) return 'D';
      
      final parts = name.split(' ');
      String relevantName = name;
      
      // Ignora "Dr." o "Dra." para la inicial
      if (parts.length > 1 && (parts[0] == 'Dr.' || parts[0] == 'Dra.')) {
        relevantName = parts.skip(1).join(' '); // Ej: "Elena Martínez"
      }
      
      return relevantName.isNotEmpty ? relevantName[0].toUpperCase() : 'D';
    }

    // manejar los campos "No disponible" ---
    String getDisplayValue(dynamic value, [String suffix = '']) {
      String stringValue = value?.toString() ?? '';
      
      // Revisa si es nulo, vacío, "N/A..." o 0 (para experiencia)
      if (stringValue.isEmpty || stringValue.startsWith('N/A') || value == 0) {
        return 'No disponible';
      }
      
      // Añade sufijo si existe (para "años de experiencia")
      if (suffix.isNotEmpty) {
        return '$stringValue $suffix';
      }
      return stringValue;
    }

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: colors.primaryContainer,
                  foregroundColor: colors.onPrimaryContainer,
                  child: Text(
                    getInitials(doctor['name']), // Usa la inicial del nombre
                    style: textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor['name'] ?? 'Doctor No Disponible',
                        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        // Usa la llave 'specialty' del backend
                        doctor['specialty'] ?? 'Especialidad no definida',
                        style: textTheme.titleMedium?.copyWith(color: colors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Información de Contacto ---
            _InfoRow(
              icon: Icons.email_outlined,
              text: doctor['email'] ?? 'No disponible', // Usa la llave 'email'
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.phone_outlined,
              text: getDisplayValue(doctor['phone']), // Usa 'phone' y maneja "N/A"
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.location_on_outlined,
              text: getDisplayValue(doctor['location']), // Usa 'location' y maneja "N/A"
            ),

            const Divider(height: 32),

            // --- Información Profesional ---
            _InfoRow(
              icon: Icons.badge_outlined,
              // Usa 'license'
              text: 'Licencia: ${getDisplayValue(doctor['license'])}',
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.work_history_outlined,
              // Usa 'years_experience' y maneja el 0
              text: getDisplayValue(doctor['years_experience'], 'años de experiencia'),
            ),

            const Divider(height: 32),

            // --- Biografía ---
            Text(
              'Biografía',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              // Usa 'biography' del backend
              doctor['biography'] ?? 'No disponible.',
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// Pequeño widget helper para las filas con ícono
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}