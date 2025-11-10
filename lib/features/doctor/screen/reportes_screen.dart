// features/doctor/screen/reportes_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/footer_doctor.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/seguridad.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/summary_card.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/summary_card_list.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/patient_comment.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/montly_income_card.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';
// import 'package:proyecto_hidoc/features/doctor/widgets/list/doctor.dart'; // Ya no se usa
import 'package:proyecto_hidoc/features/doctor/widgets/doctor_infor.dart';

// 1. Importar tu provider de TokenStorage
import 'package:proyecto_hidoc/main.dart';

// 2. Importar tu ruta de Login
import '../../auth/screen/login_screen.dart';

// 3. Importar el nuevo provider de perfil
// (Ajusta la ruta si lo pusiste en otro lugar)

// 4. Convertir a ConsumerWidget
class ReportesScreen extends ConsumerWidget {
  static const String name = 'reportes_screen';
  const ReportesScreen({super.key});

  @override
  // 5. Añadir 'ref' a la firma del build
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    // 6. YA NO USAMOS DATOS ESTÁTICOS
    // final doctor = Doctor[0]; // <-- Eliminado
    // final profileTabs = doctor['profile_tabs']; // <-- Eliminado

    // 7. OBSERVAMOS EL NUEVO PROVIDER
    final asyncProfile = ref.watch(doctorProfileProvider);

    // Ingresos simulados (pueden venir del backend luego)
    final List<double> ingresos = [
      3000, 3200, 2800, 3500, 4000, 4200,
      3800, 4500, 4300, 4700, 5000, 4800,
    ];

    // 8. Esta es la función de logout (sin cambios)
    void onLogoutTapped() async {
      try {
        final storage = ref.read(tokenStorageProvider);
        await storage.clear();

        if (context.mounted) {
          context.goNamed(LoginScreen.name);
        }

      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cerrar sesión: $e')),
          );
        }
      }
    }

    return Scaffold(
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        actions: [
          ThemeToggleButton(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_rounded,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            child: Text(
              'Dr.' // Esto podría venir del 'asyncProfile' luego
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              
              // 9. MANEJAMOS LOS ESTADOS DE CARGA DEL PROVIDER
              asyncProfile.when(
                
                // --- CUANDO LOS DATOS LLEGAN ---
                data: (doctorData) {
                  // Pasamos el Map 'doctorData' directamente al InfoTab
                  return InfoTab(doctor: doctorData);
                },

                // --- MIENTRAS CARGA ---
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                ),

                // --- SI HAY UN ERROR ---
                error: (err, stack) => Center(
                  child: Card(
                    color: colors.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Error al cargar el perfil: $err',
                        style: TextStyle(color: colors.onErrorContainer),
                      ),
                    ),
                  ),
                ),
              ),
              // -----------------------------------------------------------------

              const SizedBox(height: 16),

              // --- Widgets que ahora dependen de 'asyncProfile' ---
              // (Descomenta y ajústalos cuando tengas los datos)
              /*
              // Horario del doctor
              ScheduleTab(schedule: asyncProfile.value?['schedule'] ?? {}),
              const SizedBox(height: 16),

              // Diplomas del doctor
              DiplomasTab(diplomas: asyncProfile.value?['diplomas'] ?? []),
              const SizedBox(height: 16),

              // Comentarios de pacientes dinámicos
              PatientCommentsCard(
                title: "Reseñas de Pacientes",
                comments: asyncProfile.value?['reviews'] ?? [],
              ),
              const SizedBox(height: 16),
              */

              // Gráfica de ingresos (usa la lista local)
              MonthlyIncomeChart(monthlyIncome: ingresos),
              const SizedBox(height: 16),

              // Pasa la función de logout al widget
              SecuritySettingsCard(onLogoutTapped: onLogoutTapped),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FooterGroup(buttons: doctorFooterButtons(context)),
    );
  }
}