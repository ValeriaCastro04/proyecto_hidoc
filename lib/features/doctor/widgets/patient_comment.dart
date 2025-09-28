import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/patients.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/patients_comments.dart';

class PatientCommentsCard extends StatelessWidget {
  final String title;

  const PatientCommentsCard({
    super.key,
    this.title = "Comentarios de los pacientes",
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: patientComments.length,
          itemBuilder: (context, index) {
            final commentData = patientComments[index];
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
          },
        ),
      ],
    );
  }
}
