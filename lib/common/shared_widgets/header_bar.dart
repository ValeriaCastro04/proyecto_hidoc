import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// AppBar reutilizable con dos variantes:
/// - HeaderBar.brand(...): logo + (opcional) título + acciones
/// - HeaderBar.category(...): botón atrás + tarjeta de categoría + acciones
class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Widget child;

  const HeaderBar._({
    super.key,
    required this.child,
    required this.height,
  });

  /// Variante para pantallas de marca (ej. Home/Consultas/Perfil)
  factory HeaderBar.brand({
    required String logoAsset,
    String? title,
    double logoHeight = 28,
    List<Widget>? actions,
  }) {
    return HeaderBar._(
      height: 64,
      child: Row(
        children: [
          Row(
            children: [
              Image.asset(logoAsset, height: logoHeight),
              if (title != null) ...[
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
          const Spacer(),
          ...(actions ?? const []),
        ],
      ),
    );
  }

  /// Variante para pantallas de categoría (ej. Búsqueda de médicos, Pago)
  /// [onBack]: acción personalizada al retroceder (opcional)
  /// [fallbackPath]: ruta a la que se navega si no hay stack para hacer pop
  factory HeaderBar.category({
    required String title,
    String? subtitle,
    IconData icon = Icons.medical_services_rounded,
    VoidCallback? onBack,
    String fallbackPath = '/',
    List<Widget>? actions,
    double height = 124,
  }) {
    return HeaderBar._(
      height: height,
      child: Row(
        children: [
          _BackCircleButton(onBack: onBack, fallbackPath: fallbackPath),
          const SizedBox(width: 12),
          Expanded(
            child: _CategoryTile(
              icon: icon,
              title: title,
              subtitle: subtitle,
            ),
          ),
          if (actions != null && actions.isNotEmpty) ...[
            const SizedBox(width: 8),
            ...actions,
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      elevation: 3, // separa visualmente del contenido
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: child,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _BackCircleButton extends StatelessWidget {
  final VoidCallback? onBack;
  final String fallbackPath;

  const _BackCircleButton({this.onBack, this.fallbackPath = '/'});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onBack ??
          () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(fallbackPath);
            }
          },
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cs.surfaceVariant.withOpacity(.6),
          shape: BoxShape.circle,
          border: Border.all(color: cs.outline.withOpacity(.2)),
        ),
        child: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const _CategoryTile({
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withOpacity(.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: cs.primary),
          ),
          const SizedBox(width: 12),
          // Texto con control de overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}