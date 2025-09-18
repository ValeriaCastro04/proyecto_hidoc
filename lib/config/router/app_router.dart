import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/doctor/screen/homedoctor_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home_doctor',
  routes: [
    GoRoute(
      path: '/home_doctor',
      name: HomeDoctorScreen.name,
      builder: (context, state) => const HomeDoctorScreen(),
    )
  ]
);