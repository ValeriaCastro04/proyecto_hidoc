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
import 'package:proyecto_hidoc/features/doctor/widgets/doctor_infor.dart';

// provider de TokenStorage
import 'package:proyecto_hidoc/main.dart';

// ruta de Login
import '../../auth/screen/login_screen.dart';

class ReportesScreen extends ConsumerWidget {
  static const String name = 'reportes_screen';
  const ReportesScreen({super.key});

  @override
  // 'ref' a la firma del build
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    // NUEVO PROVIDER
    final asyncProfile = ref.watch(doctorProfileProvider);

    // Ingresos simulados (pueden venir del backend luego)
    final List<double> ingresos = [
      3000, 3200, 2800, 3500, 4000, 4200,
      3800, 4500, 4300, 4700, 5000, 4800,
    ];

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
              
              // ESTADOS DE CARGA DEL PROVIDER
              asyncProfile.when(
                
                data: (doctorData) {
                  return InfoTab(doctor: doctorData);
                },

                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                ),

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