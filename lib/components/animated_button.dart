import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatefulWidget {
  final String text;
  final void Function()? onTap;
  const MyButton({super.key, required this.text, this.onTap});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;

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
        if (widget.onTap != null) widget.onTap!();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color:
              _isPressed ? primaryColor.withValues(alpha: 0.4) : primaryColor,
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.6),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
        ),
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Text(widget.text,
              style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.bold,
                  color: surfaceColor,
                  fontSize: 18)),
        ),
      ),
    );
  }
}
