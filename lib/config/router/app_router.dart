import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/config/router/router_notifier.dart';

// AUTH
import 'package:proyecto_hidoc/features/auth/screen/welcome_screen.dart';
import 'package:proyecto_hidoc/features/auth/screen/login_screen.dart';
import 'package:proyecto_hidoc/features/auth/screen/register_screen.dart';

// DOCTOR
import 'package:proyecto_hidoc/features/doctor/screen/homedoctor_screen.dart';
import 'package:proyecto_hidoc/features/doctor/screen/agenda_screen.dart';
import 'package:proyecto_hidoc/features/doctor/screen/pacientes_screen.dart';
import 'package:proyecto_hidoc/features/doctor/screen/reportes_screen.dart';
import 'package:proyecto_hidoc/features/doctor/screen/doctor_chat_screen.dart';

// PACIENTE
import 'package:proyecto_hidoc/features/user/screen/homeuser_screen.dart';
import 'package:proyecto_hidoc/features/user/screen/consultas_screen.dart';
import 'package:proyecto_hidoc/features/user/screen/perfil_screen.dart';
import 'package:proyecto_hidoc/features/user/pages/pago_exitoso_page.dart';
import 'package:proyecto_hidoc/features/user/screen/patient_medical_history_screen.dart';

// CHAT
import 'package:proyecto_hidoc/features/user/screen/patient_chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_hidoc/providers/chat_provider.dart';

// Pages reutilizables de paciente
import 'package:proyecto_hidoc/features/user/pages/doctores_disponibles.dart';
import 'package:proyecto_hidoc/features/user/pages/pago_page.dart';
import 'package:proyecto_hidoc/features/user/models/payment_models.dart';

final GoRouter appRouter = GoRouter(
  // arranque en la pantalla de bienvenida
  initialLocation: '/welcome',
  refreshListenable: routerNotifier,
  redirect: routerNotifier.redirect,
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

    // ================== PACIENTE ==================
    GoRoute(
      path: '/home_user',
      name: HomeUserScreen.name,
      builder: (context, state) => const HomeUserScreen(),
    ),
    GoRoute(
  path: '/consultas',
  name: 'ConsultasUser',
  builder: (context, state) => const ConsultasScreen(),
  routes: [
    // Acepta /consultas/general | /consultas/especializada | /consultas/pediatrica
    GoRoute(
      path: ':category',
      name: DoctoresDisponiblesPage.name, // 'DoctoresDisponibles'
      builder: (context, state) {
        final slug = (state.pathParameters['category'] ?? '').toLowerCase();

        // Mapeo slug -> code y name para tu página
        String code = 'GENERAL';
        String name = 'Medicina General';
        switch (slug) {
          case 'especializada':
            code = 'ESPECIALIZADA';
            name = 'Especializada';
            break;
          case 'pediatrica':
            code = 'PEDIATRIA';
            name = 'Pediatría';
            break;
          case 'general':
          default:
            code = 'GENERAL';
            name = 'Medicina General';
        }

        return DoctoresDisponiblesPage(
          categoryCode: code,
          categoryName: name,
        );
      },
    ),
  ],
),


    GoRoute(
      path: '/pago',
      name: PagoPage.name,
      builder: (context, state) {
        // lee query params: ?concept=Consulta%20m%C3%A9dica&amount=8&type=consulta&doctorId=123&doctorName=Dr.%20Lopez
        final qp = state.uri.queryParameters;
        final concept = qp['concept'] ?? 'Consulta médica';
        final amount = double.tryParse(qp['amount'] ?? '') ?? 8.0;
        final kind = (qp['type'] == 'membresia')
            ? PaymentKind.membresia
            : PaymentKind.consulta;
        final doctorId = qp['doctorId'] ?? '';
        final doctorName = qp['doctorName'] ?? '';

        return PagoPage(
          concept: concept,
          amount: amount,
          kind: kind,
          doctorId: doctorId,
          doctorName: doctorName,
        );
      },
    ),

    GoRoute(
      path: '/pago-exitoso',
      name: PagoExitosoPage.name,
      builder: (context, state) {
        final qp = state.uri.queryParameters;
        final concept = qp['concept'] ?? 'Consulta médica';
        final amount = double.tryParse(qp['amount'] ?? '') ?? 8.0;
        final doctor = qp['doctor'] ?? 'Dr. María López';
        final id = qp['id'] ?? 'CITA-000001';
        final metodo = qp['metodo']; // opcional
        return PagoExitosoPage(
          concept: concept,
          amount: amount,
          doctorName: doctor,
          appointmentId: id,
          metodo: metodo,
        );
      },
    ),

    GoRoute(
      path: '/historial',
      name: 'HistorialUser',
      builder: (context, state) => const PatientMedicalHistoryScreen(),
    ),
    GoRoute(
      path: '/perfil',
      name: 'PerfilUser',
      builder: (context, state) => const PerfilScreen(),
    ),
    GoRoute(
      path: '/chat',
      name: 'Chat',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return ChangeNotifierProvider(
          create: (_) => ChatProvider(),
          child: PatientChatScreen(
            doctorId: extra['doctorId'] ?? 'dr_001',
            doctorName: extra['doctorName'] ?? 'Dr Lopez',
            doctorInitials: extra['doctorInitials'] ?? 'DrL',
          ),
        );
      },
    ),

    // ================== DOCTOR ==================
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
    GoRoute(
      path: '/doctor-chat',
      name: 'DoctorChat',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return ChangeNotifierProvider(
          create: (_) => ChatProvider(),
          child: DoctorChatScreen(
            patientId: extra['patientId'] ?? 'patient_001',
            patientName: extra['patientName'] ?? 'Paciente',
            patientInitials: extra['patientInitials'] ?? 'P',
          ),
        );
      },
    ),
  ],
);