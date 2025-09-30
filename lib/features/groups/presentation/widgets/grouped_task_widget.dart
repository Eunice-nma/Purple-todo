import 'package:flutter/material.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';

class GroupedTaskWidget extends StatelessWidget {
  const GroupedTaskWidget({
    super.key,
    required this.text,
    required this.subText,
    required this.bgColor,
    required this.totalTasks,
    this.completedTasks = 0,
  });
  final String text;
  final String subText;
  final Color bgColor;
  final int totalTasks;
  final int completedTasks;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: AppTextStyles.heading20w6
                    .copyWith(color: AppColors.darkPurple),
              ),
              Text(
                subText,
                style: AppTextStyles.body12w4
                    .copyWith(color: AppColors.darkPurple),
              ),
              Spacer(),
              Text(
                totalTasks == 0
                    ? '0 Task'
                    : '$completedTasks / $totalTasks Tasks',
                style: AppTextStyles.lable10w7
                    .copyWith(color: AppColors.darkPurple),
              ),
            ],
          ),
          const Spacer(),
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
  }
}
