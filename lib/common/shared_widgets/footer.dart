import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final List<Widget> buttons;
  final double height;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  const Footer({
    super.key,
    required this.buttons,
    this.height = 72, // 👈 altura fija segura (puedes usar kBottomNavigationBarHeight + 16)
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: backgroundColor ?? cs.surface,
      elevation: 8, // 👈 reemplaza la sombra manual
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: height, // 👈 clave: constrain en vertical
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttons
                  // 👇 distribución horizontal uniforme sin afectar altura
                  .map((w) => Expanded(child: Center(child: w)))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class FooterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final bool selected;

  const FooterButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = selected ? cs.primary : cs.onSurfaceVariant;

    // Hay un Material arriba (en Footer), así que InkWell está bien.
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min, // 👈 no crecer verticalmente
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
