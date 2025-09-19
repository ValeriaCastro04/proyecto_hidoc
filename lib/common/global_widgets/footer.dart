import 'package:flutter/material.dart';

class FooterButton extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const FooterButton({
    super.key,
    this.icon = Icons.add,
    this.text = 'Button',
    required this.onPressed,
  });

  @override
  _FooterButtonState createState() => _FooterButtonState();
}

class _FooterButtonState extends State<FooterButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color currentContentColor = _isPressed ? Theme.of(context).colorScheme.surfaceTint : Theme.of(context).colorScheme.outline;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: currentContentColor,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              widget.text,
              style: TextStyle(
                color: currentContentColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}