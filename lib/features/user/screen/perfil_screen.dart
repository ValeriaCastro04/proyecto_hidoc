import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/common/shared_widgets/gradient_background.dart';
import 'package:proyecto_hidoc/features/user/widgets/footer_user.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool notifPush = true;
  bool notifEmail = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      // Header con marca (como en Home/Consultas)
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        title: 'HiDoc!',
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded,
                color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            child: const Text('JP'),
          ),
        ],
      ),

      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: GradientBackground(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text('Perfil',
                    style:
                        tt.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  'Configura tu cuenta y tu plan',
                  style: tt.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(.7),
                  ),
                ),
                const SizedBox(height: 16),

                // Card: Información de usuario
                _SectionCard(
                  title: 'Mi Cuenta',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: cs.primary.withOpacity(.15),
                            child: Icon(Icons.person, color: cs.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Juana Pérez',
                                    style: tt.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text('juana.perez@correo.com',
                                    style: tt.bodyMedium?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(.7),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 0),
                      const SizedBox(height: 12),
                      _InfoRow(icon: Icons.phone_rounded, label: 'Teléfono', value: '+503 7777-8888'),
                      const SizedBox(height: 10),
                      _InfoRow(icon: Icons.badge_rounded, label: 'Documento', value: '01234567-8'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Card: Membresía / Plan
                _SectionCard(
                  title: 'Membresía',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PlanBadge(text: 'Plan Básico'),
                      const SizedBox(height: 10),
                      _InfoRow(
                          icon: Icons.calendar_month_rounded,
                          label: 'Renueva',
                          value: '12/12/2025'),
                      const SizedBox(height: 10),
                      _InfoRow(
                          icon: Icons.payments_rounded,
                          label: 'Costo mensual',
                          value: '\$8.00'),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.workspace_premium_rounded),
                              label: const Text('Cambiar plan / Membresías'),
                              onPressed: () {
                                // TODO: cuando tengas la ruta:
                                // context.pushNamed('Membresias');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Próximamente: selección de membresías'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Card: Preferencias
                _SectionCard(
                  title: 'Preferencias',
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: notifPush,
                        onChanged: (v) => setState(() => notifPush = v),
                        secondary: const Icon(Icons.notifications_active_rounded),
                        title: const Text('Notificaciones push'),
                      ),
                      const Divider(height: 0),
                      SwitchListTile(
                        value: notifEmail,
                        onChanged: (v) => setState(() => notifEmail = v),
                        secondary: const Icon(Icons.email_rounded),
                        title: const Text('Notificaciones por correo'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Card: Seguridad (acciones simples)
                _SectionCard(
                  title: 'Seguridad',
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.lock_reset_rounded),
                        title: const Text('Cambiar contraseña'),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Próximamente: cambio de contraseña'),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 0),
                      ListTile(
                        leading: const Icon(Icons.logout_rounded),
                        title: const Text('Cerrar sesión'),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sesión cerrada (demo)')),
                          );
                          // TODO: Implementa tu flujo real de sign-out
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Footer con pestaña activa
      bottomNavigationBar: Footer(
        buttons: userFooterButtons(context, current: UserTab.perfil),
      ),
    );
  }
}

/// ---------- Widgets de apoyo ----------

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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: tt.titleMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w800,
              )),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, color: cs.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label,
              style: tt.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.7),
              )),
        ),
        Text(value, style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _PlanBadge extends StatelessWidget {
  final String text;
  const _PlanBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.primary.withOpacity(.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, size: 18, color: cs.primary),
          const SizedBox(width: 6),
          Text(text,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: cs.primary, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}