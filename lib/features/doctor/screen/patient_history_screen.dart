import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/patient_history.dart';
import 'package:proyecto_hidoc/features/doctor/screen/doctor_chat_screen.dart';
import 'package:go_router/go_router.dart';

class PatientHistoryScreen extends StatelessWidget {
  final String name;
  final String correo;
  final String telefono;
  final String numero_DUI;
  final String initials;
  final List<Map<String, dynamic>> history;

  const PatientHistoryScreen({
    super.key,
    required this.name,
    required this.initials,
    required this.correo,
    required this.telefono,
    required this.numero_DUI,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(name, style: const TextStyle(fontSize: 17))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              title: "Información del paciente",
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: colors.primary.withOpacity(.15),
                        child: Icon(Icons.person, color: colors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: text.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              correo,
                              style: text.bodyMedium?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 0),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.phone_rounded,
                    label: 'Teléfono',
                    value: telefono,
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.badge_rounded,
                    label: 'Documento',
                    value: numero_DUI,
                  ),
                  const SizedBox(height: 10),
                  _ChatRow(
                    patientId: 'patient_001', // O el ID real del paciente
                    patientName: name,
                    patientInitials: initials,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 24),
            const Text(
              "Historial clínico:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: history.isEmpty
                  ? const Center(child: Text("No hay historial disponible"))
                  : PatientHistory(history: history),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, color: cs.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: tt.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.7),
            ),
          ),
        ),
        Text(
          value,
          style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.onPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline.withOpacity(.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              title,
                style: text.titleMedium?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                )
              ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ChatRow extends StatelessWidget {
  final String patientId;
  final String patientName;
  final String patientInitials;
  
  const _ChatRow({
    required this.patientId,
    required this.patientName,
    required this.patientInitials,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    
    return Row(
      children: [
        Icon(Icons.chat_bubble_outline, color: cs.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Chat médico',
            style: tt.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.7),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            // Usar GoRouter en lugar de Navigator.push
            context.push('/doctor-chat', extra: {
              'patientId': patientId,
              'patientName': patientName,
              'patientInitials': patientInitials,
            });
          },
          icon: Icon(Icons.chat, size: 18),
          label: Text(
            'Iniciar chat',
            style: tt.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: cs.primary,
            ),
          ),
        ),
      ],
    );
  }
}