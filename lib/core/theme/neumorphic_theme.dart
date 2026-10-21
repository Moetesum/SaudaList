import 'package:flutter/material.dart';

class NeumorphicColors {
  static const Color background = Color(0xFFE0E5EC);
  static const Color lightShadow = Colors.white;
  static const Color darkShadow = Color(0xFFA3B1C6);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentDarkGreen = Color(0xFF388E3C);
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color cardBackground = Color(0xFFE0E5EC);
}

class NeumorphicStyles {
  // Raised Effect
  static BoxDecoration raised({
    double radius = 16.0,
    Color backgroundColor = NeumorphicColors.background,
    bool isPressed = false,
  }) {
    if (isPressed) {
      return BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: NeumorphicColors.darkShadow,
            offset: const Offset(2, 2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: NeumorphicColors.lightShadow,
            offset: const Offset(-2, -2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      );
    }
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: NeumorphicColors.darkShadow,
          offset: const Offset(6, 6),
          blurRadius: 15,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: NeumorphicColors.lightShadow,
          offset: const Offset(-6, -6),
          blurRadius: 15,
          spreadRadius: 1,
        ),
      ],
    );
  }

  // Pressed / Inset Effect
  static BoxDecoration pressed({
    double radius = 16.0,
    Color backgroundColor = NeumorphicColors.background,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: NeumorphicColors.darkShadow.withOpacity(0.6),
          offset: const Offset(3, 3),
          blurRadius: 6,
          spreadRadius: -1,
        ),
        BoxShadow(
          color: NeumorphicColors.lightShadow,
          offset: const Offset(-3, -3),
          blurRadius: 6,
          spreadRadius: -1,
        ),
      ],
    );
  }
}

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final bool isPressed;
  final VoidCallback? onTap;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.radius = 16.0,
    this.isPressed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: padding ?? const EdgeInsets.all(16.0),
        margin: margin,
        decoration: NeumorphicStyles.raised(
          radius: radius,
          isPressed: isPressed,
        ),
        child: child,
      ),
    );
  }
}

class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;
  final double radius;

  const NeumorphicButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.padding,
    this.radius = 16.0,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: NeumorphicStyles.raised(
          radius: widget.radius,
          isPressed: _isPressed,
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}

class NeumorphicTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;

  const NeumorphicTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NeumorphicColors.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: NeumorphicColors.darkShadow.withOpacity(0.5),
            offset: const Offset(3, 3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: NeumorphicColors.lightShadow,
            offset: const Offset(-3, -3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: NeumorphicColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: NeumorphicColors.textSecondary),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: NeumorphicColors.accentGreen) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
