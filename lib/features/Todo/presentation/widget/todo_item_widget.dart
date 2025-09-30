import 'package:flutter/material.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/utils_exports.dart';
import 'package:todo_sample_app/features/todo/models/todo_model.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo task;
  final Color? groupColor;
  final bool useGroupStyle;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const TodoItemWidget({
    super.key,
    required this.task,
    this.onToggle,
    this.onDelete,
    this.onTap,
    this.groupColor,
    this.useGroupStyle = false,
  });

  Color get borderColor =>
      useGroupStyle ? (groupColor ?? AppColors.lightPurple) : AppColors.lightPurple;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      width: double.infinity,
      constraints: const BoxConstraints(
        maxHeight: 72,
        minHeight: 48,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // Make only the text area tappable
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
                    style: AppTextStyles.body12w4.copyWith(
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
                            color: Color.lerp(borderColor, Colors.black, 0.2),
                            size: 14,
                          ),
                          2.wi,
                          Text(
                            task.reminderTime!.format(context),
                            style: AppTextStyles.lable10w7.copyWith(
                              color:
                                  Color.lerp(borderColor, Colors.black, 0.2)!,
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
          InkWell(
            onTap: onToggle,
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.isDone ? borderColor : Colors.transparent,
                border: Border.all(color: borderColor, width: 2),
              ),
              child: task.isDone
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
