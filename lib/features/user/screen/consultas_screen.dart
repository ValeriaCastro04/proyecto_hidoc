import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/features/user/widgets/footer_user.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';
import 'package:proyecto_hidoc/features/user/widgets/quick_actions_user.dart';
import 'package:proyecto_hidoc/features/user/services/doctor_service.dart';
import 'package:proyecto_hidoc/features/user/models/doctor_category.dart';
import 'package:proyecto_hidoc/services/token_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/config/router/router_notifier.dart';

class ConsultasScreen extends StatelessWidget {
  const ConsultasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        title: 'HiDoc!',
        actions: [
          const ThemeToggleButton(),
          IconButton(
            tooltip: 'Notificaciones',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente: notificaciones')),
              );
            },
            icon: Icon(Icons.notifications_none_rounded, color: cs.onSurface),
          ),
          // Avatar con menú (Perfil / Cerrar sesión)
          PopupMenuButton<String>(
            tooltip: 'Cuenta',
            position: PopupMenuPosition.under,
            onSelected: (v) async {
              if (v == 'profile') {
                context.go('/perfil');
              } else if (v == 'logout') {
                await TokenStorage.clear();
                // actualiza el notifier global para evitar redirecciones incorrectas
                routerNotifier.isLoggedIn = false;
                routerNotifier.isDoctor = false;
                if (context.mounted) context.go('/auth/login');
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'profile', child: Text('Perfil')),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Cerrar sesión'),
                  ],
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: CircleAvatar(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                child: const Text('V', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<DoctorCategoryDto>>(
          future: DoctorService().fetchCategories(),
          builder: (context, snap) {
            final loading = snap.connectionState != ConnectionState.done;
            final categories = snap.data ?? [];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 96),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        cs.primary.withOpacity(.25),
                        cs.primary.withOpacity(.12),
                        Colors.green.withOpacity(.10),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.35, 0.65, 1.0],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Consultas', style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        Text(
                          'Mira las diferentes especialidades disponibles',
                          style: tt.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(.7)),
                        ),
                        const SizedBox(height: 16),

                        _SectionCard(
                          title: 'Elige tu consulta',
                          child: loading
                              ? const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(child: CircularProgressIndicator()),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Contamos con ${categories.length} especialidades',
                                      style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    QuickActionsUser(categories: categories),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 16),
                        _StepsCard(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Footer(
        buttons: userFooterButtons(context, current: UserTab.consultas),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withOpacity(.15)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: tt.titleMedium?.copyWith(color: cs.primary, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }
}

class _StepsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final steps = const [
      'Elige el tipo de especialidad',
      'Escoge a uno de los doctores disponibles',
      'Haz el pago de tu consulta en 5 min',
      'Cuando el pago sea verificado podrás comenzar tu consulta por chat, llamada o videollamada',
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withOpacity(.15)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Pasos a seguir para una consulta\nen HiDoc!:',
            style: tt.titleMedium?.copyWith(color: cs.primary, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        for (int i = 0; i < steps.length; i++) ...[
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${i + 1}. ', style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
            Expanded(child: Text(steps[i], style: tt.bodyMedium)),
          ]),
          const SizedBox(height: 8),
        ],
      ]),
    );
  }
}