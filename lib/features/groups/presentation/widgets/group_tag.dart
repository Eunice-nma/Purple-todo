import 'package:flutter/material.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';

class GroupTags extends StatelessWidget {
  const GroupTags({
    super.key,
    required this.name,
    required this.color,
    required this.isActive,
    this.onTap,
  });
  final String name;
  final Color color;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isActive ? color : AppColors.whitefe,
          border: Border.all(
            color: color,
          ),
        ),

        child: Text(
          name,
          style: AppTextStyles.lable12w5.copyWith(color: AppColors.darkPurple),
        ),
        // ),
      ),
    );
  }
}
