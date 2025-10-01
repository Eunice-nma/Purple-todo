import 'package:flutter/material.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/responsive_extensions.dart';

class GroupedTaskWidget extends StatelessWidget {
  const GroupedTaskWidget({
    super.key,
    required this.text,
    required this.subText,
    required this.bgColor,
    required this.totalTasks,
    this.completedTasks = 0,
    this.height,
    this.onDelete,
  });
  final String text;
  final String subText;
  final Color bgColor;
  final int totalTasks;
  final int completedTasks;
  final double? height;
  final Function? onDelete;
  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      height: height ?? 100,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: AppTextStyles.heading20w6
                      .copyWith(color: AppColors.darkPurple),
                ),
                8.hi,
                Text(
                  subText,
                  style: AppTextStyles.body14w4
                      .copyWith(color: AppColors.darkPurple),
                ),
                const Spacer(),
                Text(
                  totalTasks == 0
                      ? '0 Task'
                      : '$completedTasks / $totalTasks Tasks',
                  style: AppTextStyles.lable12w7
                      .copyWith(color: AppColors.darkPurple),
                ),
              ],
            ),
          ),
          20.wi,
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.whitefe,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  value: totalTasks == 0 ? 0.0 : completedTasks / totalTasks,
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round,
                  color: bgColor,
                  backgroundColor: bgColor.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Only make it dismissible if onDelete is provided
    if (onDelete != null) {
      return Dismissible(
        key: ValueKey(text + subText),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => onDelete!(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.red,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
        ),
        child: content,
      );
    }

    return content;
  }
}
