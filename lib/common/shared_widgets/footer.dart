import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final List<Widget> buttons;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

  const Footer({
    super.key,
    required this.buttons,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? cs.surface,
          border: Border(top: BorderSide(color: cs.outline.withOpacity(.15))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: padding,
        child: Row(
          children: buttons.map((w) => Expanded(child: Center(child: w))).toList(),
        ),
      ),
    );
  }
}

/// ✅ Ahora acepta [selected] (opcional).
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
    this.selected = false, // <- default
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = selected ? cs.primary : cs.onSurfaceVariant;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}