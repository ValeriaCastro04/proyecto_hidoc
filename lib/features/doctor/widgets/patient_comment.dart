import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/patients.dart';

class PatientCommentsCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> comments; // Lista de comentarios

  const PatientCommentsCard({
    super.key,
    this.title = "Comentarios de los pacientes",
    this.comments = const [], // Valor por defecto
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (comments.isEmpty) {
      return Center(
        child: Text(
          "No hay comentarios disponibles",
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        // Reemplazamos ListView.builder por Column para evitar tamaño infinito
        Column(
          children: comments.map((commentData) {
            final patient = Patients[commentData['patientIndex']];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    child: Text(patient['initials'] ?? ''),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient['name'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            commentData['comment'] ?? '',
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            commentData['date'] ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.onSurfaceVariant.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

