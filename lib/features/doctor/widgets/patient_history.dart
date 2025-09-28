import 'package:flutter/material.dart';

class PatientHistory extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const PatientHistory({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(child: Text("No hay historial disponible"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(4.0),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final episode = history[index];
        final colors = Theme.of(context).colorScheme;

        // Datos principales
        final date = episode['fecha_episodio'] ?? 'Fecha Desconocida';
        final generalDescription = episode['descripcion_general'] ?? 'Sin descripción';

        // Detalles
        final examResults = episode['resultados_examenes_fisicos']['detalle'] ?? 'N/A';
        final diagnosis = episode['diagnosticos']['detalle'] ?? 'N/A';
        final treatment = episode['tratamientos']['detalle'] ?? 'N/A';
        final evolution = episode['evolucion_enfermedad']['detalle'] ?? 'N/A';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: colors.onPrimary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.outline.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado
                Row(
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            generalDescription,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            date,
                            style: TextStyle(
                              color: colors.onSurface.withOpacity(0.75),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Divider(height: 24),

                // Detalles del episodio
                _DetailRow(title: 'Diagnóstico', detail: diagnosis, color: colors.error),
                _DetailRow(title: 'Tratamiento', detail: treatment, color: colors.secondary),
                _DetailRow(title: 'Exámenes y Hallazgos', detail: examResults, color: colors.tertiary),
                _DetailRow(title: 'Evolución', detail: evolution, color: colors.primary),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String detail;
  final Color color;

  const _DetailRow({required this.title, required this.detail, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}
