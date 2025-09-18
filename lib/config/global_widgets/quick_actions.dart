import 'package:flutter/material.dart';

class QuickActionsButton extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const QuickActionsButton({
    super.key,
    this.icon = Icons.add,
    this.text = 'Buttom',
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
    final Color currentContentColor = _isPressed ? Colors.white : baseColor;
    final Color currentBackgroundColor = _isPressed ? baseColor : Colors.white;
    
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
        duration: const Duration (milliseconds: 200),
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: currentBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: currentBorderColor,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: currentContentColor,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              widget.text,
              style: TextStyle(
                color: currentContentColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
