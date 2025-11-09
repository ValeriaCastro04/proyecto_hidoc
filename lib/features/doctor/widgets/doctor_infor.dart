import 'package:flutter/material.dart';

class InfoTab extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const InfoTab({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.onPrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar con iniciales
          CircleAvatar(
            radius: 36,
            backgroundColor: colors.primaryContainer,
            child: Text(
              (doctor['name'] ?? 'Dr')[0], // Primera letra del nombre
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colors.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Nombre
          Text(
            doctor['name'] ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),

          // Especialidad
          Text(
            doctor['specialty'] ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: colors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),

          // Contacto
          _buildInfoRow(Icons.email, doctor['email'] ?? '', colors),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.phone, doctor['phone'] ?? '', colors),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.location_on, doctor['location'] ?? '', colors),
          const Divider(height: 32),

          // Licencia y experiencia
          _buildInfoRow(Icons.badge, "Licencia: ${doctor['license'] ?? ''}", colors),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.work, "${doctor['years_experience'] ?? 0} años de experiencia", colors),
          const Divider(height: 32),

          // Biografía
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Biografía",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            doctor['biography'] ?? '',
            style: TextStyle(
              fontSize: 14,
              color: colors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Helper para filas de información con ícono
  Widget _buildInfoRow(IconData icon, String text, ColorScheme colors) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: colors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
