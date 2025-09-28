import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controlador de tema con Riverpod 2 (Notifier)
class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system; // arranca con el tema del sistema

  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  void set(ThemeMode mode) => state = mode;
}

/// Provider que expone el ThemeMode actual y permite mutarlo
final themeModeProvider =
    NotifierProvider<ThemeController, ThemeMode>(ThemeController.new);