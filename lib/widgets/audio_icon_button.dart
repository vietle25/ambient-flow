import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AudioIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;

  const AudioIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  State<AudioIconButton> createState() => _AudioIconButtonState();
}

class _AudioIconButtonState extends State<AudioIconButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        decoration: BoxDecoration(
          color: widget.isActive
              ? AppColors.categoryButtonSelected
                  .withOpacity(0.7) // Active state
              : (isHovered
                  ? AppColors.categoryButton.withOpacity(0.6) // Hover state
                  : AppColors.categoryButton.withOpacity(0.4)), // Default state
          borderRadius: BorderRadius.circular(20.0), // Rounded corners
          border: Border.all(
              color: widget.isActive
                  ? Colors.white
                      .withOpacity(0.3) // More visible border when active
                  : Colors.white.withOpacity(0.1),
              width: widget.isActive ? 1.0 : 0.5), // Thicker border when active
        ),
        // Make the button size appropriate for the icon
        constraints: const BoxConstraints(
          minWidth: 60,
          minHeight: 60,
          maxWidth: 70,
          maxHeight: 70,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.0), // Matching border radius
            onTap: widget.onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: isHovered
                  ? (Matrix4.identity()..scale(1.05))
                  : Matrix4.identity(),
              padding: const EdgeInsets.all(
                  4.0), // Minimal padding to make icon larger
              child: Center(
                child: Icon(
                  widget.icon,
                  color: widget.isActive
                      ? Colors.white // Brighter color when active
                      : AppColors.textPrimary.withOpacity(0.9),
                  size: 32, // Icon size
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
