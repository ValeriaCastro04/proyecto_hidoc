import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/features/user/widgets/footer_user.dart';

/// Pantalla de historial médico para el paciente
class PatientMedicalHistoryScreen extends StatelessWidget {
  static const String name = 'patient_medical_history';
  
  const PatientMedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        title: 'Mi Historial',
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded, color: cs.onSurface),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            child: const Text('JP'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información personal
              _SectionCard(
                title: "Mi Información",
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: cs.primary.withOpacity(.15),
                          child: Icon(Icons.person, color: cs.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Juan Carlos Pérez Gómez',
                                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'juan.perez@ejemplo.com',
                                style: tt.bodyMedium?.copyWith(
                                  color: cs.onSurface.withOpacity(.7),
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
                    _InfoRow(icon: Icons.cake_rounded, label: 'Edad', value: '35 años'),
                    const SizedBox(height: 10),
                    _InfoRow(icon: Icons.monitor_weight_rounded, label: 'Peso', value: '75 kg'),
                    const SizedBox(height: 10),
                    _InfoRow(icon: Icons.height_rounded, label: 'Altura', value: '1.75 m'),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Consultas recientes
              Text(
                'Consultas Recientes',
                style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              
              _ConsultationCard(
                doctorName: 'Dra. Elena Martínez',
                specialty: 'Medicina General',
                date: '15 Sept 2024',
                diagnosis: 'Cefalea tensional',
                status: 'Completada',
                statusColor: Colors.green,
              ),
              
              const SizedBox(height: 12),
              
              _ConsultationCard(
                doctorName: 'Dr. Carlos López',
                specialty: 'Cardiología',
                date: '3 Sept 2024',
                diagnosis: 'Control de presión arterial',
                status: 'Completada',
                statusColor: Colors.green,
              ),
              
              const SizedBox(height: 12),
              
              _ConsultationCard(
                doctorName: 'Dra. Ana Rodríguez',
                specialty: 'Dermatología',
                date: '20 Ago 2024',
                diagnosis: 'Consulta preventiva',
                status: 'Completada',
                statusColor: Colors.green,
              ),
              
              const SizedBox(height: 24),
              
              // Medicamentos actuales
              Text(
                'Medicamentos Actuales',
                style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              
              _MedicationCard(
                medication: 'Losartán 50mg',
                dosage: '1 tableta diaria',
                prescribedBy: 'Dr. Carlos López',
                date: '3 Sept 2024',
              ),
              
              const SizedBox(height: 12),
              
              _MedicationCard(
                medication: 'Ibuprofeno 400mg',
                dosage: '1 tableta cada 8 horas (si es necesario)',
                prescribedBy: 'Dra. Elena Martínez',
                date: '15 Sept 2024',
              ),
              
              const SizedBox(height: 24),
              
              // Alergias y condiciones
              Text(
                'Alergias y Condiciones',
                style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              
              _AlertCard(
                icon: Icons.warning_amber_rounded,
                title: 'Alergias',
                content: 'Penicilina, Mariscos',
                color: Colors.orange,
              ),
              
              const SizedBox(height: 12),
              
              _AlertCard(
                icon: Icons.medical_information_rounded,
                title: 'Condiciones Médicas',
                content: 'Hipertensión arterial controlada',
                color: Colors.blue,
              ),
              
              const SizedBox(height: 12),
              
              _AlertCard(
                icon: Icons.family_restroom_rounded,
                title: 'Antecedentes Familiares',
                content: 'Diabetes tipo 2 (padre), Hipertensión (madre)',
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(
        buttons: userFooterButtons(context, current: UserTab.historial),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withOpacity(.15)),
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
            style: tt.titleMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  
  const _InfoRow({required this.icon, required this.label, required this.value});

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
              color: cs.onSurface.withOpacity(.7),
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

class _ConsultationCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String date;
  final String diagnosis;
  final String status;
  final Color statusColor;
  
  const _ConsultationCard({
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.diagnosis,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withOpacity(.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      specialty,
                      style: tt.bodySmall?.copyWith(color: cs.onSurface.withOpacity(.7)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: tt.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            diagnosis,
            style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: tt.bodySmall?.copyWith(color: cs.onSurface.withOpacity(.6)),
          ),
        ],
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final String medication;
  final String dosage;
  final String prescribedBy;
  final String date;
  
  const _MedicationCard({
    required this.medication,
    required this.dosage,
    required this.prescribedBy,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withOpacity(.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.medication, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication,
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  dosage,
                  style: tt.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Prescrito por $prescribedBy - $date',
                  style: tt.bodySmall?.copyWith(color: cs.onSurface.withOpacity(.6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;
  
  const _AlertCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: tt.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}