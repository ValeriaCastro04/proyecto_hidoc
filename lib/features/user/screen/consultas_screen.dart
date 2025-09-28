import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/features/user/widgets/footer_user.dart';
import 'package:proyecto_hidoc/features/user/widgets/quick_actions_user.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';

class ConsultasScreen extends StatelessWidget {
  const ConsultasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      // Header de marca (logo + acciones)
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        title: 'HiDoc!',
        actions: [
          ThemeToggleButton(), 
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
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
          child: Padding(
            padding: const EdgeInsets.only(bottom: 96),
            child: Container(
              // Fondo con gradiente suave (azul → verde claro)
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
                    // Título de página
                    Text(
                      'Consultas',
                      style: tt.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Mira las diferentes especialidades disponibles',
                      style: tt.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.7),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card: Nueva Consulta
                    _SectionCard(
                      title: 'Elige tu consulta',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contamos con 3 diferentes especialidades para ti',
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const QuickActionsUser(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card: Pasos a seguir
                    _StepsCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      // Footer con pestaña Consultas activa
      bottomNavigationBar: Footer(
        buttons: userFooterButtons(context, current: UserTab.consultas),
      ),
    );
  }
}

/// Card genérica de sección
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

/// Card con los pasos a seguir (estilo del prototipo)
class _StepsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    TextStyle stepStyle = tt.bodyMedium!;
    final steps = const [
      'Elige el tipo de especialidad',
      'Escoge a uno de los doctores disponibles',
      'Haz el pago de tu consulta en 5 min',
      'Cuando el pago sea verificado podrás comenzar tu consulta de la forma que más prefieras, ya sea chat, llamada o videollamada',
    ];

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
          Text(
            'Pasos a seguir para una consulta\nen HiDoc!:',
            style: tt.titleMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < steps.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${i + 1}. ', style: stepStyle.copyWith(fontWeight: FontWeight.w700)),
                Expanded(child: Text(steps[i], style: stepStyle)),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
