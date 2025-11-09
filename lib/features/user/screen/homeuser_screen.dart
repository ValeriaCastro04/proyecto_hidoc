import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:proyecto_hidoc/features/user/widgets/footer_user.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer.dart';
import 'package:proyecto_hidoc/features/user/widgets/quick_actions_user.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/common/shared_widgets/gradient_background.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';

import 'package:proyecto_hidoc/services/api_client.dart'; // <- usa ApiClient.dio

/* ===========================
   Modelos livianos para la UI
   =========================== */

class MeProfile {
  final String id;
  final String fullName;
  MeProfile({required this.id, required this.fullName});

  factory MeProfile.fromMap(Map<String, dynamic> j) => MeProfile(
        id: (j['id'] ?? '') as String,
        fullName: (j['fullName'] ?? j['name'] ?? '') as String,
      );
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
    final statusStr = (j['status'] ?? 'CONFIRMED') as String;
    final parsed = AppointmentStatus.values.firstWhere(
      (e) => e.name == statusStr,
      orElse: () => AppointmentStatus.CONFIRMED,
    );
    return AppointmentItem(
      id: (j['id'] ?? '') as String,
      doctorUserId: (j['doctorUserId'] ?? '') as String,
      scheduledAt: DateTime.parse(j['scheduledAt'] as String),
      status: parsed,
      reason: j['reason'] as String?,
      note: j['note'] as String?,
    );
  }
}

/* ===========================
   Pantalla principal HomeUser
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
  String _greeting = 'Hola';
  List<AppointmentItem> _recent = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final me = await _fetchMe();
      final appts = await _fetchMyAppointments();

      setState(() {
        _firstName = _firstFrom(me.fullName).isEmpty ? 'Usuario' : _firstFrom(me.fullName);
        _greeting = _greetByHour(DateTime.now());
        _recent = appts;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<MeProfile> _fetchMe() async {
    final res = await ApiClient.dio.get('/v1/users/me'); // o '/auth/me' si ese usas
    // si tu backend devuelve application/json nativo, res.data ya es Map
    final data = res.data is String ? json.decode(res.data) : res.data;
    return MeProfile.fromMap(data as Map<String, dynamic>);
  }

  Future<List<AppointmentItem>> _fetchMyAppointments() async {
    final Response res = await ApiClient.dio.get('/v1/appointments/me', queryParameters: {
      'limit': 10,
    });
    final list = (res.data is String) ? json.decode(res.data) : res.data;
    return (list as List)
        .map((e) => AppointmentItem.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  String _firstFrom(String name) => name.trim().split(RegExp(r'\s+')).firstOrNull ?? '';

  String _greetByHour(DateTime now) {
    final h = now.hour;
    if (h < 12) return 'Buenos días';
    if (h < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        title: 'HiDoc!',
        actions: [
          ThemeToggleButton(),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            child: Text(_firstName.isNotEmpty ? _firstName.characters.first.toUpperCase() : 'U'),
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
                        _HomeHeader(greeting: _greeting, firstName: _firstName),
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
   Header (mismo estilo)
   =========================== */

class _HomeHeader extends StatelessWidget {
  final String greeting;
  final String firstName;
  const _HomeHeader({required this.greeting, required this.firstName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.primary.withOpacity(0.85),
            colorScheme.primary.withOpacity(0.6),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            '$greeting, $firstName',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '¿Cómo podemos ayudarte hoy?',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

/* ===========================
   Quick Actions (tu widget)
   =========================== */

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nueva Consulta',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const QuickActionsUser(), // mantiene tu widget
        ],
      ),
    );
  }
}

/* ===========================
   Actividad Reciente (Appointments)
   =========================== */

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
    // dd/MM sin intl
    final two = (int n) => n.toString().padLeft(2, '0');
    return '${two(when.day)}/${two(when.month)}';
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
      case AppointmentStatus.CONFIRMED:
      default:
        return (Icons.medical_services_outlined, cs.primary, cs.primary.withOpacity(0.1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Actividad Reciente',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),

          if (items.isEmpty)
            Text(
              'Aún no tienes actividad reciente.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),

          for (final it in items) ...[
            Builder(builder: (ctx) {
              final (icon, icColor, bg) = _statusVisuals(ctx, it.status);
              final subtitle = (it.reason?.isNotEmpty ?? false)
                  ? it.reason!
                  : 'Consulta ${it.status.name.toLowerCase()}';
              return _ActivityItem(
                icon: icon,
                iconBackground: bg,
                iconColor: icColor,
                title: 'Consulta', // si luego traes nombre del doctor, cámbialo aquí
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
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(30)),
          child: Text(
            badgeText,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: badgeTextColor,
            ),
          ),
        ),
      ],
    );
  }
}

/* ===========================
   Extensión pequeña de List
   =========================== */

extension _SafeFirst<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}