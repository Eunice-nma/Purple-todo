import 'package:flutter/material.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/responsive_extensions.dart';
import 'package:todo_sample_app/core/widgets/check_circle.dart';
import 'package:todo_sample_app/features/todo/models/todo_model.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo task;
  final Color? groupColor;
  final bool useGroupStyle;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TodoItemWidget({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
    this.groupColor,
    this.useGroupStyle = false,
  });

  Color get borderColor => useGroupStyle
      ? (groupColor ?? AppColors.lightPrimary)
      : AppColors.lightPrimary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Dismissible(
        key: ValueKey(task.id),
        direction: DismissDirection.endToStart,
        background: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: AppColors.lightRed,
            child:
                const Icon(Icons.delete_outline_rounded, color: Colors.white),
          ),
        ),
        onDismissed: (direction) {
          // Delete todo on swipe from Right to Left
          if (direction == DismissDirection.endToStart) {
            onDelete();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
          width: double.infinity,
          constraints: const BoxConstraints(
            maxHeight: 80,
            minHeight: 50,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: task.reminderTime != null
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      Text(
                        task.description,
                        style: AppTextStyles.body14w4.copyWith(
                          decoration:
                              task.isDone ? TextDecoration.lineThrough : null,
                          color: task.isDone
                              ? Color.lerp(borderColor, Colors.black, 0.4)
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Row(
                          children: [
                            if (task.reminderTime != null) ...[
                              Icon(
                                Icons.notifications,
                                color:
                                    Color.lerp(borderColor, Colors.black, 0.2),
                                size: 14,
                              ),
                              2.wi,
                              Text(
                                task.reminderTime!.format(context),
                                style: AppTextStyles.lable12w7.copyWith(
                                  color: Color.lerp(
                                      borderColor, Colors.black, 0.2)!,
                                ),
                              ),
                              8.wi,
                            ],
                            if (!useGroupStyle)
                              groupColor != null
                                  ? Container(
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: groupColor,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              12.wi,
              CheckCircle(
                isChecked: task.isDone,
                onTap: onToggle,
                activeColor: borderColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
