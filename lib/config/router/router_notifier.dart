import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._isLoggedIn, this._isDoctor);

  bool _isLoggedIn;
  bool _isDoctor;

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  set isDoctor(bool value) {
    _isDoctor = value;
    notifyListeners();
  }

  // Rutas públicas que no requieren autenticación
  static final publicPaths = [
    '/welcome',
    '/auth/login',
    '/auth/register',
  ];

  // Rutas específicas para doctores
  static final doctorPaths = [
    '/home_doctor',
    '/agenda',
    '/pacientes',
    '/reportes',
    '/doctor-chat',
  ];

  // Rutas específicas para pacientes
  static final patientPaths = [
    '/home_user',
    '/consultas',
    '/pago',
    '/pago-exitoso',
    '/historial',
    '/perfil',
    '/chat',
  ];

  String? redirect(BuildContext context, GoRouterState state) {
    final path = state.uri.path;

    // Si la ruta es pública, permitir acceso
    if (publicPaths.contains(path)) {
      return null;
    }

    // Si no está autenticado, redirigir al login
    if (!_isLoggedIn) {
      return '/auth/login';
    }

    // Si es doctor intentando acceder a rutas de paciente
    if (_isDoctor && patientPaths.any((p) => path.startsWith(p))) {
      return '/home_doctor';
    }

    // Si es paciente intentando acceder a rutas de doctor
    if (!_isDoctor && doctorPaths.any((p) => path.startsWith(p))) {
      return '/home_user';
    }

    // Si todo está bien, permitir acceso
    return null;
  }
}

// Instancia compartida para que otras partes de la app puedan actualizar
// el estado de autenticación y rol.
final routerNotifier = RouterNotifier(false, false);