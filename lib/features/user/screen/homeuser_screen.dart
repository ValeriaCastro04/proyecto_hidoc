import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:proyecto_hidoc/features/user/widgets/footer_user.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer.dart';
import 'package:proyecto_hidoc/features/user/widgets/quick_actions_user.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/common/shared_widgets/gradient_background.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';

import 'package:proyecto_hidoc/services/api_client.dart';
import 'package:proyecto_hidoc/services/token_storage.dart';

import 'package:proyecto_hidoc/features/user/services/doctor_service.dart';
import 'package:proyecto_hidoc/features/user/models/doctor_category.dart';
import 'package:proyecto_hidoc/features/user/widgets/quick_actions_user.dart';

/* ===========================
   Models
   =========================== */

class MeProfile {
  final String id;
  final String name;

  MeProfile({required this.id, required this.name});

  factory MeProfile.fromAny(dynamic raw) {
    final Map<String, dynamic> map =
        raw is String ? json.decode(raw) as Map<String, dynamic> : (raw as Map<String, dynamic>);

    Map<String, dynamic> root = map;
    if (root['data'] is Map<String, dynamic>) root = root['data'];
    if (root['user'] is Map<String, dynamic>) root = root['user'];

    final id = (root['id'] ?? root['_id'] ?? '').toString();
    final name = (root['name'] ?? root['fullName'] ?? root['fullname'] ?? '').toString();
    return MeProfile(id: id, name: name);
  }
}

enum AppointmentStatus { PENDING, CONFIRMED, CANCELLED, COMPLETED }

class AppointmentItem {
  final String id;
  final String doctorUserId;
  final DateTime scheduledAt;
  final AppointmentStatus status;
  final String? reason;
  final String? note;

  AppointmentItem({
    required this.id,
    required this.doctorUserId,
    required this.scheduledAt,
    required this.status,
    this.reason,
    this.note,
  });

  factory AppointmentItem.fromMap(Map<String, dynamic> j) {
    final st = (j['status'] ?? 'CONFIRMED').toString();
    final status = AppointmentStatus.values.firstWhere(
      (e) => e.name == st,
      orElse: () => AppointmentStatus.CONFIRMED,
    );
    return AppointmentItem(
      id: (j['id'] ?? '').toString(),
      doctorUserId: (j['doctorUserId'] ?? '').toString(),
      scheduledAt: DateTime.parse(j['scheduledAt'] as String),
      status: status,
      reason: j['reason'] as String?,
      note: j['note'] as String?,
    );
  }
}

/* ===========================
   Screen
   =========================== */

class HomeUserScreen extends StatefulWidget {
  static const String name = 'HomeUser';
  const HomeUserScreen({super.key});

  @override
  State<HomeUserScreen> createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  bool _loading = true;
  String _firstName = 'Usuario';
  List<AppointmentItem> _recent = [];

  @override
  void initState() {
    super.initState();
    _primeFromCache().then((_) => _load());
  }

  /// Muestra lo más rápido posible el nombre cacheado (si existe).
  Future<void> _primeFromCache() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final cached = sp.getString('user_name') ?? '';
      if (cached.isNotEmpty) {
        setState(() {
          _firstName = _extractFirstName(cached);
        });
      }
    } catch (_) {}
  }

  Future<void> _load() async {
    try {
      final me = await _fetchUserProfileWithManualRefresh();
      final appts = await _fetchMyAppointmentsWithManualRefresh();

      // Actualiza cache del nombre si vino desde /me
      if (me.name.isNotEmpty) {
        try {
          final sp = await SharedPreferences.getInstance();
          await sp.setString('user_name', me.name);
        } catch (_) {}
      }

      setState(() {
        _firstName = _extractFirstName(me.name);
        _recent = appts;
        _loading = false;
      });
    } catch (e, st) {
      if (kDebugMode) {
        print('[HomeUser] Error: $e');
        print(st);
      }
      setState(() => _loading = false);
    }
  }

  // ---------- Helpers de refresh manual ----------
  Future<bool> _manualRefresh() async {
    try {
      final refresh = await TokenStorage.getRefreshToken();
      if (refresh == null || refresh.isEmpty) {
        if (kDebugMode) print('[HomeUser] No refresh token guardado');
        return false;
      }
      final resp = await ApiClient.dio.post(
        '/auth/refresh',
        data: {'refreshToken': refresh},
        options: Options(
          extra: {'skipAuth': true}, // si tu interceptor lo respeta, evita Bearer
          validateStatus: (s) => true,
        ),
      );
      if ((resp.statusCode ?? 500) >= 400) {
        if (kDebugMode) print('[HomeUser] Refresh HTTP ${resp.statusCode}');
        await TokenStorage.clear();
        return false;
      }
      final data = resp.data is Map ? resp.data as Map : {};
      final access = (data['access_token'] ?? data['accessToken'])?.toString();
      final newRefresh = (data['refresh_token'] ?? data['refreshToken'])?.toString();

      if (access == null || access.isEmpty) {
        if (kDebugMode) print('[HomeUser] Refresh respondió sin access_token');
        return false;
      }
      await TokenStorage.saveAccessToken(access);
      if (newRefresh != null && newRefresh.isNotEmpty) {
        await TokenStorage.saveRefreshToken(newRefresh);
      }
      if (kDebugMode) print('[HomeUser] Refresh OK, access actualizado');
      return true;
    } catch (e) {
      if (kDebugMode) print('[HomeUser] Refresh FAILED: $e');
      await TokenStorage.clear();
      return false;
    }
  }

  Future<Response<dynamic>> _safeGet(String url, {Map<String, dynamic>? qp}) {
    return ApiClient.dio.get(
      url,
      queryParameters: qp,
      options: Options(validateStatus: (s) => true), // no lanzar por 401/400
    );
  }

  // ---------- Perfil con refresh manual ----------
  Future<MeProfile> _fetchUserProfileWithManualRefresh() async {
    // 1) Intentar /v1/users/me
    var res = await _safeGet('/v1/users/me');
    if ((res.statusCode ?? 500) == 200) {
      return MeProfile.fromAny(res.data);
    }
    if (res.statusCode == 401) {
      if (kDebugMode) print('[HomeUser] 401 en /v1/users/me, intentando refresh...');
      final ok = await _manualRefresh();
      if (ok) {
        res = await _safeGet('/v1/users/me');
        if ((res.statusCode ?? 500) == 200) {
          return MeProfile.fromAny(res.data);
        }
      }
    }

    // 2) Fallback a /auth/me
    var res2 = await _safeGet('/auth/me');
    if ((res2.statusCode ?? 500) == 200) {
      return MeProfile.fromAny(res2.data);
    }
    if (res2.statusCode == 401) {
      if (kDebugMode) print('[HomeUser] 401 en /auth/me, intentando refresh...');
      final ok = await _manualRefresh();
      if (ok) {
        res2 = await _safeGet('/auth/me');
        if ((res2.statusCode ?? 500) == 200) {
          return MeProfile.fromAny(res2.data);
        }
      }
    }

    // 3) Último recurso: nombre cacheado
    try {
      final sp = await SharedPreferences.getInstance();
      final cached = sp.getString('user_name') ?? '';
      if (cached.isNotEmpty) {
        return MeProfile(id: '', name: cached);
      }
    } catch (_) {}
    return MeProfile(id: '', name: 'Usuario');
  }

  // ---------- Citas con refresh manual ----------
  Future<List<AppointmentItem>> _fetchMyAppointmentsWithManualRefresh() async {
    var res = await _safeGet('/v1/appointments/me', qp: {'limit': 10});
    if ((res.statusCode ?? 500) == 200) {
      final list = res.data is String ? json.decode(res.data) : res.data;
      if (list is List) {
        return list.map((e) => AppointmentItem.fromMap(e as Map<String, dynamic>)).toList();
      }
    } else if (res.statusCode == 401) {
      if (kDebugMode) print('[HomeUser] 401 en /v1/appointments/me, intentando refresh...');
      final ok = await _manualRefresh();
      if (ok) {
        res = await _safeGet('/v1/appointments/me', qp: {'limit': 10});
        if ((res.statusCode ?? 500) == 200) {
          final list = res.data is String ? json.decode(res.data) : res.data;
          if (list is List) {
            return list.map((e) => AppointmentItem.fromMap(e as Map<String, dynamic>)).toList();
          }
        }
      }
    }
    return [];
  }

  String _extractFirstName(String name) {
    final n = name.trim();
    if (n.isEmpty) return 'Usuario';
    final parts = n.split(RegExp(r'\s+'));
    return parts.first;
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Buenos días';
    if (h < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final initialLetter = _firstName.isNotEmpty ? _firstName.characters.first.toUpperCase() : 'U';

    return Scaffold(
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        title: 'HiDoc!',
        actions: [
          const ThemeToggleButton(),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded, color: cs.onSurface),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            child: Text(initialLetter),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _load,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: GradientBackground(
                    padding: const EdgeInsets.only(bottom: 88),
                    child: Column(
                      children: [
                        _HomeHeader(greeting: _greeting(), firstName: _firstName),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Transform.translate(
                                offset: const Offset(0, -30),
                                child: const _QuickActionsCard(),
                              ),
                              const SizedBox(height: 8),
                              _RecentActivityCard(items: _recent),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      bottomNavigationBar: Footer(
        buttons: userFooterButtons(context, current: UserTab.home),
      ),
    );
  }
}

/* ===========================
   Header
   =========================== */

class _HomeHeader extends StatelessWidget {
  final String greeting;
  final String firstName;
  const _HomeHeader({required this.greeting, required this.firstName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [cs.primary.withOpacity(0.85), cs.primary.withOpacity(0.6)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            '$greeting, $firstName',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: cs.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '¿Cómo podemos ayudarte hoy?',
            style: theme.textTheme.titleMedium?.copyWith(
              color: cs.onPrimary.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

/* ===========================
   Quick Actions + Recent
   =========================== */

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: cs.shadow.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nueva Consulta',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          FutureBuilder<List<DoctorCategoryDto>>(
            future: DoctorService().fetchCategories(),
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final categories = snap.data ?? const <DoctorCategoryDto>[];
              if (categories.isEmpty) {
                return Text(
                  'No hay categorías disponibles por ahora',
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              }
              // Importante: quita el `const` porque ahora hay parámetros dinámicos.
              return QuickActionsUser(categories: categories);
            },
          ),
        ],
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  final List<AppointmentItem> items;
  const _RecentActivityCard({required this.items});

  String _humanize(DateTime when) {
    final now = DateTime.now();
    final diff = now.difference(when);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${when.day}/${when.month}';
  }

  (IconData, Color, Color) _statusVisuals(BuildContext ctx, AppointmentStatus st) {
    final cs = Theme.of(ctx).colorScheme;
    switch (st) {
      case AppointmentStatus.COMPLETED:
        return (Icons.check_circle_outline_rounded, cs.secondary, cs.secondary.withOpacity(0.1));
      case AppointmentStatus.CANCELLED:
        return (Icons.cancel_outlined, cs.error, cs.error.withOpacity(0.1));
      case AppointmentStatus.PENDING:
        final c = cs.tertiary ?? cs.primary;
        return (Icons.schedule_rounded, c, c.withOpacity(0.1));
      default:
        return (Icons.medical_services_outlined, cs.primary, cs.primary.withOpacity(0.1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: cs.shadow.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Actividad Reciente',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          if (items.isEmpty)
            Text('Aún no tienes actividad reciente.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7))),
          for (final it in items) ...[
            Builder(builder: (ctx) {
              final (icon, icColor, bg) = _statusVisuals(ctx, it.status);
              final subtitle =
                  (it.reason?.isNotEmpty ?? false) ? it.reason! : 'Consulta ${it.status.name.toLowerCase()}';
              return _ActivityItem(
                icon: icon,
                iconBackground: bg,
                iconColor: icColor,
                title: 'Consulta',
                subtitle: subtitle,
                badgeText: _humanize(it.scheduledAt),
                badgeColor: icColor.withOpacity(0.15),
                badgeTextColor: icColor,
              );
            }),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;

  const _ActivityItem({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(color: iconBackground, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7))),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(30)),
          child: Text(
            badgeText,
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: badgeTextColor),
          ),
        ),
      ],
    );
  }
}