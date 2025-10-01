import 'package:flutter/material.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/utils_exports.dart';

class AppTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final Color? fillColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final int maxLines;

  const AppTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.maxLines = 1,
    this.fillColor = AppColors.white,
    this.borderColor,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText ?? '',
          style: labelStyle ??
              AppTextStyles.body14w5.copyWith(color: AppColors.black36),
        ),
        4.hi,
        TextField(
          controller: controller,
          style: textStyle ?? AppTextStyles.body14w5,
          maxLines: maxLines,
          decoration: InputDecoration(
            // labelText: labelText,
            hintText: hintText,
            hintStyle: hintStyle ??
                AppTextStyles.body14w5.copyWith(color: AppColors.grey7E),
            // labelStyle: hintStyle ?? AppTextStyles.body14w5,
            contentPadding: const EdgeInsets.all(12),
            filled: true,
            fillColor: fillColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor ?? AppColors.lightPurple,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: borderColor ?? AppColors.lightPurple,
                width: 1.5,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: borderColor ?? AppColors.lightPurple,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
