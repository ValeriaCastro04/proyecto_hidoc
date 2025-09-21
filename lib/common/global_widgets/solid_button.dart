import 'package:flutter/material.dart';

/// Botón primario sólido de HiDoc.
/// - [expand]: si true ocupa todo el ancho disponible.
/// - [loading]: muestra un spinner y deshabilita el onPressed.
/// - [leading]/[trailing]: íconos opcionales.
/// Personaliza colores con [backgroundColor]/[foregroundColor].
class SolidButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  final bool expand;
  final bool loading;
  final double height;

  final Widget? leading;
  final Widget? trailing;

  final Color? backgroundColor;
  final Color? foregroundColor;

  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;

  const SolidButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.expand = false,
    this.loading = false,
    this.height = 52,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.padding = const EdgeInsets.symmetric(horizontal: 18),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.primary;
    final fg = foregroundColor ?? theme.colorScheme.onPrimary;

    final button = ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 0,
        minimumSize: Size.fromHeight(height),
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        textStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        padding: padding,
      ),
      child: loading
          ? SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation<Color>(fg),
              ),
            )
          : _content(fg),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }

  Widget _content(Color fg) {
    final children = <Widget>[];

    if (leading != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(right: 8),
        child: IconTheme(data: IconThemeData(color: fg, size: 20), child: leading!),
      ));
    }

    children.add(Flexible(child: Text(text, overflow: TextOverflow.ellipsis)));

    if (trailing != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconTheme(data: IconThemeData(color: fg, size: 20), child: trailing!),
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}