import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';
import 'package:proyecto_hidoc/features/user/widgets/footer_user.dart';
import 'package:proyecto_hidoc/features/user/models/doctor_model.dart';
import 'package:proyecto_hidoc/features/user/services/doctor_service.dart';

class DoctoresDisponiblesPage extends StatelessWidget {
  static const String name = 'DoctoresDisponibles';
  final String? categoryCode; // GENERAL / ESPECIALIZADA / PEDIATRIA
  final String? categoryName;
  const DoctoresDisponiblesPage({super.key, this.categoryCode, this.categoryName});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final code = categoryCode ?? 'GENERAL';

    return Scaffold(
      appBar: HeaderBar.category(
        title: categoryName ?? code,
        subtitle: 'Selecciona un médico para iniciar tu consulta',
        icon: Icons.medical_services_rounded,
        onBack: () => context.canPop() ? context.pop() : context.go('/consultas'),
        actions: const [ ThemeToggleButton() ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<DoctorLite>>(
          future: DoctorService().fetchDoctorsByCategoryCode(code),
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final items = snap.data ?? [];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 88),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Especialistas disponibles',
                              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 6),
                          Text('Selecciona un médico para iniciar tu consulta',
                              style: tt.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(.7))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          for (final d in items) ...[
                            _DoctorCard(doctor: d),
                            const SizedBox(height: 12),
                          ],
                          _EmergencyCard(),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar:
          Footer(buttons: userFooterButtons(context, current: UserTab.consultas)),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final DoctorLite doctor;
  const _DoctorCard({required this.doctor});

  String _availabilityLabel(List<AvailabilitySlot> slots) {
    if (slots.isEmpty) return 'Sin horarios';
    final now = DateTime.now();
    for (final s in slots) {
      if (!s.isBooked && now.isAfter(s.start) && now.isBefore(s.end)) {
        return 'Disponible ahora';
      }
    }
    slots.sort((a, b) => a.start.compareTo(b.start));
    final next = slots.firstWhere((s) => s.start.isAfter(now), orElse: () => slots.first);
    final isToday = DateTime(now.year, now.month, now.day) ==
        DateTime(next.start.year, next.start.month, next.start.day);
    return isToday ? 'Hoy ${_hhmm(next.start)}' : '${_ddmmyy(next.start)}';
  }

  String _hhmm(DateTime d) => '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  String _ddmmyy(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withOpacity(.15)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(radius: 22, backgroundColor: cs.primary.withOpacity(.15), child: Icon(Icons.person, color: cs.primary)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(doctor.fullName, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 6),
                  Icon(Icons.star_rounded, size: 18, color: Colors.amber.shade600),
                  const SizedBox(width: 2),
                  Text(doctor.rating.toStringAsFixed(1), style: tt.bodyMedium),
                ]),
                const SizedBox(height: 2),
                Text(doctor.specialty, style: tt.bodySmall?.copyWith(color: cs.onSurface.withOpacity(.7))),
                const SizedBox(height: 8),

                FutureBuilder<List<AvailabilitySlot>>(
                  future: DoctorService().fetchAvailability(doctor.id),
                  builder: (context, snap) {
                    final label = (snap.hasData)
                        ? _availabilityLabel(snap.data!)
                        : 'Cargando disponibilidad…';
                    final availableNow = (snap.hasData) && label == 'Disponible ahora';
                    final color = availableNow ? Colors.teal : cs.onSurface.withOpacity(.7);
                    final dot = availableNow ? Colors.teal : cs.onSurface.withOpacity(.35);
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: dot.withOpacity(.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.circle, size: 8, color: dot),
                        const SizedBox(width: 6),
                        Text(label, style: tt.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w700)),
                      ]),
                    );
                  },
                ),
              ]),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('\$${doctor.price}', style: tt.titleMedium?.copyWith(color: cs.primary, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              FilledButton(onPressed: () {
                // En el siguiente paso conectamos flujo de appointments/payments/consultations
              }, child: const Text('Consultar')),
            ]),
          ],
        ),
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.errorContainer.withOpacity(.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.error.withOpacity(.4)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(radius: 20, backgroundColor: cs.error.withOpacity(.1), child: Icon(Icons.emergency_share_rounded, color: cs.error)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('¿Es una emergencia?', style: tt.titleMedium?.copyWith(color: cs.error, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text('Si tienes una emergencia médica, llama al 911 o acude al hospital más cercano.',
                style: tt.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(.85))),
          ]),
        ),
      ]),
    );
  }
}