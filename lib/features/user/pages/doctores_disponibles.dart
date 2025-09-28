import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/features/user/models/doctor_category.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer.dart';
import 'package:proyecto_hidoc/features/user/widgets/footer_user.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/features/user/pages/pago_page.dart'; 
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';

// —— Ejemplo de “repositorio” que luego puedes cambiar por API/DB —— //
class Doctor {
  final String nombre;
  final String especialidad;
  final double rating;
  final int precio;
  final String disponibilidad;
  Doctor({
    required this.nombre,
    required this.especialidad,
    required this.rating,
    required this.precio,
    required this.disponibilidad,
  });
}

abstract class DoctorRepository {
  Future<List<Doctor>> getByCategory(DoctorCategory category);
}

// Mock simple por ahora (luego cambias la implementación sin tocar la UI)
class InMemoryDoctorRepo implements DoctorRepository {
  @override
  Future<List<Doctor>> getByCategory(DoctorCategory category) async {
    await Future.delayed(const Duration(milliseconds: 250)); // simula carga
    return switch (category) {
      DoctorCategory.general => [
        Doctor(nombre: 'Dr. María López', especialidad: 'Medicina General', rating: 4.9, precio: 8, disponibilidad: 'Disponible ahora'),
        Doctor(nombre: 'Dra. Ana Martínez', especialidad: 'Medicina Interna', rating: 4.7, precio: 5, disponibilidad: 'En 30 min'),
        Doctor(nombre: 'Dr. Carlos Ruiz', especialidad: 'Medicina Familiar', rating: 4.8, precio: 8, disponibilidad: 'En 15 min'),
      ],
      DoctorCategory.especializada => [
        Doctor(nombre: 'Dr. Pablo Gómez', especialidad: 'Cardiología', rating: 4.8, precio: 12, disponibilidad: 'Mañana'),
        Doctor(nombre: 'Dra. Sofía Rivas', especialidad: 'Dermatología', rating: 4.6, precio: 10, disponibilidad: 'Hoy 5:00 PM'),
      ],
      DoctorCategory.pediatrica => [
        Doctor(nombre: 'Dra. Elisa Torres', especialidad: 'Pediatría', rating: 4.9, precio: 9, disponibilidad: 'Disponible ahora'),
      ],
    };
  }
}

// ———————————————— PAGE ———————————————— //
class DoctoresDisponiblesPage extends StatelessWidget {
  static const String name = 'DoctoresDisponibles';
  final String? categoryPath;
  const DoctoresDisponiblesPage({super.key, this.categoryPath});

  @override
  Widget build(BuildContext context) {
    final category = DoctorCategoryX.fromPath(categoryPath);
    final repo = InMemoryDoctorRepo(); // luego inyectas via Provider/Riverpod

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: HeaderBar.category(
        title: category.title,
        subtitle: 'Consultas médicas generales y evaluaciones de salud',
        icon: Icons.medical_services_rounded,
        onBack: () {
          if (context.canPop()) context.pop(); else context.go('/consultas');
        },
        actions: const [ ThemeToggleButton() ], 
      ),
      body: SafeArea(
        child: FutureBuilder<List<Doctor>>(
          future: repo.getByCategory(category),
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
                    // Título de lista
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Especialistas disponibles',
                              style: tt.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              )),
                          const SizedBox(height: 6),
                          Text(
                            'Selecciona un médico para iniciar tu consulta',
                            style: tt.bodyMedium?.copyWith(
                              color: cs.onSurface.withOpacity(.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Lista de doctores
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          for (final d in items) ...[
                            _DoctorCard(doctor: d, onTap: () {
                              // TODO: ir a detalle (con id cuando tengas BD)
                              // context.goNamed('DoctorDetalle', pathParameters:{'id': '...'});
                            }),
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

class _CategoryHeader extends StatelessWidget {
  final String title;
  const _CategoryHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withOpacity(.15)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.medical_services_rounded, color: cs.primary),
        ),
        title: Text(title, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        subtitle: const Text('Consultas médicas y evaluaciones de salud'),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onTap;
  const _DoctorCard({required this.doctor, required this.onTap});

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
                  Expanded(child: Text(doctor.nombre, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 6),
                  Icon(Icons.star_rounded, size: 18, color: Colors.amber.shade600),
                  const SizedBox(width: 2),
                  Text(doctor.rating.toStringAsFixed(1), style: tt.bodyMedium),
                ]),
                const SizedBox(height: 2),
                Text(doctor.especialidad, style: tt.bodySmall?.copyWith(color: cs.onSurface.withOpacity(.7))),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.teal.withOpacity(.12), borderRadius: BorderRadius.circular(999)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.circle, size: 8, color: Colors.teal),
                    const SizedBox(width: 6),
                    Text(doctor.disponibilidad, style: tt.labelSmall?.copyWith(color: Colors.teal, fontWeight: FontWeight.w700)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('\$${doctor.precio}', 
              style: tt.titleMedium?.copyWith(
                color: cs.primary, 
                fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              FilledButton(
                  onPressed: () {
                    context.pushNamed(            
                      PagoPage.name,
                      queryParameters: {
                        'concept': 'Consulta médica',
                        'amount': doctor.precio.toString(),
                        'type': 'consulta',
                      },
                    );
                  },
                  child: const Text('Consultar'),
),
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
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Colors.yellow.shade600, borderRadius: BorderRadius.circular(999)),
              child: Text('Línea de Emergencia', style: tt.labelMedium?.copyWith(color: Colors.black87, fontWeight: FontWeight.w800)),
            ),
          ]),
        ),
      ]),
    );
  }
}