import 'package:flutter/material.dart';

class QuickActionsButton extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const QuickActionsButton({
    super.key,
    this.icon = Icons.add,
    this.text = 'Button',
    required this.onPressed,
  });

  @override
  _QuickActionsButtonState createState() => _QuickActionsButtonState();
}

class _QuickActionsButtonState extends State<QuickActionsButton> {
  bool _isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    final Color baseColor = Theme.of(context).colorScheme.primary;
    final Color currentBorderColor = _isPressed ? baseColor : baseColor;
    final Color currentContentColor = _isPressed ? Theme.of(context).colorScheme.onPrimary : baseColor;
    final Color currentBackgroundColor = _isPressed ? baseColor : Theme.of(context).colorScheme.onPrimary;
    
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
        duration: const Duration (milliseconds: 100),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: currentBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: currentBorderColor,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: currentContentColor,
              size: 30,
            ),
            const SizedBox(height: 4),
            Text(
              widget.text,
              style: TextStyle(
                color: currentContentColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
