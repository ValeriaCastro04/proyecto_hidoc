import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/global_widgets/outline_button.dart';

final List<Widget> userQuickActions = [
  const OutlineButton(text: 'General',       icon: Icons.volunteer_activism, onPressed: _noop),
  const OutlineButton(text: 'Especializada', icon: Icons.medical_services,   onPressed: _noop),
  const OutlineButton(text: 'Pediátrica',    icon: Icons.child_care,         onPressed: _noop),
];

void _noop() {}