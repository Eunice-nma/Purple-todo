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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 96,
        height: 38,
        decoration: BoxDecoration(
          color: color ?? AppColors.purple,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppTextStyles.body13w7.copyWith(
                color: AppColors.whitefe,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
