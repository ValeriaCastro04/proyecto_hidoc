import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final List<Color>? colors;
  final List<double>? stops;

  const GradientBackground({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.colors,
    this.stops,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final _colors = colors ??
        [
          cs.primary.withOpacity(.25),
          cs.primary.withOpacity(.12),
          const Color(0xFF81C784).withOpacity(.10), // verde suave
          Colors.transparent,
        ];

    final _stops = stops ?? const [0.0, 0.35, 0.65, 1.0];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _colors,
          stops: _stops,
        ),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}