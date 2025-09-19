import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/features/doctor/screen/homedoctor_screen.dart';
import 'package:proyecto_hidoc/features/doctor/screen/agenda_screen.dart';
import 'package:proyecto_hidoc/features/doctor/screen/pacientes_screen.dart';
import 'package:proyecto_hidoc/features/doctor/screen/reportes_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home_doctor',
  routes: [
    GoRoute(
      path: '/home_doctor',
      name: HomeDoctorScreen.name,
      builder: (context, state) => const HomeDoctorScreen(),
    ),
    GoRoute(
      path: '/agenda',
      name: AgendaScreen.name,
      builder: (context, state) => const AgendaScreen(),
    ),
    GoRoute(
      path: '/pacientes',
      name: PacientesScreen.name,
      builder: (context, state) => const PacientesScreen(),
    ),
    GoRoute(
      path: '/reportes',
      name: ReportesScreen.name,
      builder: (context, state) => const ReportesScreen(),
    )
  ]
);