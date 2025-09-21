import 'package:go_router/go_router.dart';

// AUTH
import 'package:proyecto_hidoc/features/auth/screen/welcome_screen.dart';
import 'package:proyecto_hidoc/features/auth/screen/login_screen.dart';
import 'package:proyecto_hidoc/features/auth/screen/register_screen.dart';

// DOCTOR
import 'package:proyecto_hidoc/features/doctor/screen/homedoctor_screen.dart';
import 'package:proyecto_hidoc/features/doctor/screen/agenda_screen.dart';
import 'package:proyecto_hidoc/features/doctor/screen/pacientes_screen.dart';
import 'package:proyecto_hidoc/features/doctor/screen/reportes_screen.dart';

// PACIENTE
import 'package:proyecto_hidoc/features/user/screen/homeuser_screen.dart';

final GoRouter appRouter = GoRouter(
  // 👇 que arranque en la pantalla de bienvenida
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      name: WelcomeScreen.name,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/auth/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/register',
      name: RegisterScreen.name,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home_user',
      name: HomeUserScreen.name,
      builder: (context, state) => const HomeUserScreen(),
    ),
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
    ),
    // TODO: cuando tengas la pantalla Home de Paciente, agrega su ruta aquí
    // GoRoute(
    //   path: '/home_user',
    //   name: HomeUserScreen.name,
    //   builder: (context, state) => const HomeUserScreen(),
    // ),
  ],
);