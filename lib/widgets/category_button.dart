import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class CategoryButton extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const CategoryButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: widget.isSelected
                ? AppColors.categoryButtonSelected.withOpacity(0.7)
                : (isHovered
                    ? AppColors.categoryButton.withOpacity(0.6)
                    : AppColors.categoryButton.withOpacity(0.4)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // More rounded corners
            ),
          ),
          onPressed: widget.onPressed,
          child: Text(
            widget.text,
            style: AppStyles.categoryButton,
          ),
        ),
      ),
    );
  }
}
