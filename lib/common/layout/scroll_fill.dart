import 'package:flutter/material.dart';

/// Envuelve contenido para:
/// - ocupar toda la altura si hay espacio
/// - scrollear solo si el contenido no cabe
/// - y soportar hijos con flex (Spacer/Expanded)
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
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: padding,
          sliver: SliverFillRemaining(
            hasScrollBody: false, // <- permite Spacer/Expanded dentro de [child]
            child: child,
          ),
        ),
      ],
    );
  }
}
