import 'package:flutter/material.dart';

/// Envuelve contenido para:
/// - ocupar toda la altura si hay espacio
/// - scrollear solo si el contenido no cabe (sin overflow)
class ScrollFill extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget child;

  const ScrollFill({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: child),
          ),
        );
      },
    );
  }
}