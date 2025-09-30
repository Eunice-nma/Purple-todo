import 'package:flutter/material.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/utils_exports.dart';
import 'package:todo_sample_app/core/widgets/button.dart';
import 'package:todo_sample_app/core/widgets/text_field.dart';
import 'package:todo_sample_app/features/groups/presentation/widgets/group_tag.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_sample_app/features/groups/data/models/todo_model.dart';
import 'package:todo_sample_app/features/groups/providers.dart';

/// Bottom sheet widget for adding or editing a Todo item.
class TodoBottomSheet extends ConsumerStatefulWidget {
  const TodoBottomSheet({this.todo, this.predefinedGroupId, super.key});
  final Todo? todo; // If not null, this is an edit operation.
  final String? predefinedGroupId;

  @override
  ConsumerState<TodoBottomSheet> createState() => _TodoBottomSheetState();
}

class _TodoBottomSheetState extends ConsumerState<TodoBottomSheet> {
  bool setReminder = false; // Whether the reminder is enabled.
  TimeOfDay? selectedTime; // The selected reminder time.
  String? displayError; // Error message to display.
  final TextEditingController _controller = TextEditingController();
  late final bool isEdit; // Whether this is an edit operation.
  Todo? currentTodo; // The current todo being edited.

  @override
  void initState() {
    super.initState();
    isEdit = widget.todo != null;
    currentTodo = widget.todo;

    // If editing, initialize fields with existing todo data.
    if (isEdit) {
      _controller.text = currentTodo!.description;
      selectedGroupId = currentTodo!.groupId;
      setReminder = currentTodo!.reminderTime != null;
      selectedTime = currentTodo!.reminderTime;
    } else {
      selectedGroupId = widget.predefinedGroupId;
    }
  }

  /// Opens a time picker dialog and sets the reminder time.
  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (!mounted) return;

    if (picked != null) {
      final now = DateTime.now();
      final scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      // Only allow future times for today.
      if (scheduledDate.isBefore(now)) {
        setState(() {
          displayError = "You can only set a future time today.";
        });
        return;
      }

      setState(() {
        selectedTime = picked;
        displayError = null;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? selectedGroupId; // The selected group for the todo.

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(groupProvider); // List of available groups.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle at the top of the sheet.
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          20.hi,
          // Title row with optional delete button for edit mode.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isEdit ? 'Edit task' : 'Add new task',
                  style: AppTextStyles.body13w6),
              if (isEdit) ...[
                const Spacer(),
                InkWell(
                  onTap: () async {
                    // Delete the todo and close the sheet.
                    await ref
                        .read(todosProvider.notifier)
                        .deleteTodo(currentTodo!.id);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: AppColors.red,
                  ),
                ),
              ],
            ],
          ),
          12.hi,
          // Text field for entering the todo description.
          AppTextField(
            hintText: 'Make something',
            controller: _controller,
          ),
          20.hi,
          // Group selection row with add group button.
          Row(
            children: [
              Text('Group Task', style: AppTextStyles.lable11w7),
              // const Spacer(),
              // InkWell(
              //   onTap: () {
              //     // Show modal to add a new group.
              //     showAppDialog(
              //       context: context,
              //       child: GroupModal(),
              //     );
              //   },
              //   child: const Icon(Icons.add, color: AppColors.black31),
              // ),
            ],
          ),
          12.hi,
          // List of group tags to select from.
          Wrap(spacing: 12, runSpacing: 12, children: [
            ...groups.map(
              (group) => GroupTags(
                name: group.name,
                color: Color(group.colorValue),
                isActive: selectedGroupId == group.id,
                onTap: () => setState(() {
                  selectedGroupId =
                      selectedGroupId == group.id ? null : group.id;
                }),
              ),
            )
          ]),
          12.hi,
          // Reminder toggle row.
          Row(
            children: [
              Text('Remind me', style: AppTextStyles.lable11w7),
              const Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    setReminder = !setReminder;
                    if (!setReminder) {
                      selectedTime = null;
                      displayError = null;
                    }
                  });
                },
                child: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: setReminder
                        ? AppColors.lightPurple
                        : Colors.transparent,
                    border: Border.all(color: AppColors.lightPurple, width: 2),
                  ),
                  child: setReminder
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
              ),
            ],
          ),
          // Time picker for reminder, shown if reminder is enabled.
          if (setReminder) ...[
            4.hi,
            InkWell(
              onTap: () => _pickTime(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightPurple, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedTime != null
                          ? selectedTime!.format(context)
                          : '00:00 --',
                      style: AppTextStyles.lable11w7
                          .copyWith(color: AppColors.purple),
                    ),
                    4.wi,
                    const Icon(Icons.alarm, color: AppColors.purple, size: 16),
                  ],
                ),
              ),
            ),
          ],
          // Error message display.
          if (displayError != null) ...[
            8.hi,
            Text(displayError!,
                style:
                    AppTextStyles.lable10w5.copyWith(color: Colors.redAccent)),
          ],
          20.hi,
          // Done button to save the todo.
          Align(
            alignment: Alignment.centerRight,
            child: Button('Done', onTap: () async {
              final task = _controller.text.trim();
              if (task.isEmpty) {
                setState(() => displayError = "Task cannot be empty");
                return;
              }

              // Create or update the todo object.
              final todo = isEdit
                  ? currentTodo!.copyWith(
                      description: task,
                      groupId: selectedGroupId,
                      reminderTime: setReminder ? selectedTime : null)
                  : Todo(
                      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                      description: task,
                      isDone: false,
                      reminderTime: setReminder ? selectedTime : null,
                      groupId: selectedGroupId);

              // Save the todo and handle errors.
              final error = isEdit
                  ? await ref.read(todosProvider.notifier).updateTodo(todo,
                      timeChanged: selectedTime != currentTodo!.reminderTime)
                  : await ref.read(todosProvider.notifier).addTodo(todo);

              if (error != null) {
                setState(() => displayError = error);
              } else if (context.mounted) {
                Navigator.of(context).pop();
              }
            }),
          ),
          40.hi,
        ],
      ),
    );
  }
}
