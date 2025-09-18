import 'package:flutter/material.dart';

class FooterGroup extends StatelessWidget {
  final List<Widget> buttons;

  const FooterGroup({
    super.key,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: buttons,
        ),
      )
    );
  }
}