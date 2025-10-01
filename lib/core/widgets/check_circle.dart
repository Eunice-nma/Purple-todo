import 'package:flutter/material.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';

/// A reusable circle checkbox for toggling task state.
/// 
/// [isChecked] determines if the circle is filled.
/// [onTap] is called when the circle is tapped.
class CheckCircle extends StatelessWidget {
  const CheckCircle({
    super.key,
    required this.isChecked,
    required this.onTap,
    this.activeColor = AppColors.lightPrimary,
    this.size = 24,
    this.iconSize = 16,
  });

  final bool isChecked;
  final VoidCallback onTap;
  final Color activeColor;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isChecked ? activeColor : Colors.transparent,
          border: Border.all(color: activeColor, width: 2),
        ),
        child: isChecked
            ? Icon(Icons.check, color: Colors.white, size: iconSize)
            : null,
      ),
    );
  }
}
