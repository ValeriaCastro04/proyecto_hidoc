import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double height;
  final String heroTag;
  final String assetPath;

  const AppLogo({
    super.key,
    this.height = 70,
    this.heroTag = 'hidoc-logo',
    this.assetPath = 'assets/brand/hidoc_logo.png',
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Hero(
      tag: heroTag,
      child: Image.asset(
        assetPath,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
          Icons.local_hospital_rounded,
          size: height * 0.8,
          color: cs.primary,
        ),
      ),
    );
  }
}