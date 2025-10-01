import 'package:flutter/material.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';

class Button extends StatelessWidget {
  const Button(
    this.text, {
    super.key,
    this.color,
    required this.onTap,
  });
  final String text;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: color ?? AppColors.primaryColor,
        foregroundColor: AppColors.whitefe,
        padding: const EdgeInsets.all(8),
        minimumSize: const Size(96, 38),
        maximumSize: const Size(96, 38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: AppTextStyles.body13w7.copyWith(
          color: AppColors.whitefe,
        ),
      ),
    );
  }
}
