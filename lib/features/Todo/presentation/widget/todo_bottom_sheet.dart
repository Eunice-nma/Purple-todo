import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/responsive_extensions.dart';
// import 'package:todo_sample_app/core/utils/utils_exports.dart';
import 'package:todo_sample_app/core/widgets/button.dart';
import 'package:todo_sample_app/core/widgets/check_circle.dart';
import 'package:todo_sample_app/core/widgets/ios_time_picker_widget.dart';
import 'package:todo_sample_app/core/widgets/text_field.dart';
import 'package:todo_sample_app/features/groups/presentation/widgets/group_tag.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_sample_app/features/todo/models/todo_model.dart';
import 'package:todo_sample_app/features/providers.dart';

/// Bottom sheet widget for adding or editing a Todo item.
class TodoBottomSheet extends ConsumerStatefulWidget {
  const TodoBottomSheet({this.todo, this.predefinedGroupId, super.key});
  final Todo? todo; // If not null, this is an edit operation.
  final String? predefinedGroupId; // Specify a group to be selected

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
    TimeOfDay? picked;

    // Check device OS to use appropriate time picker
    if (Platform.isIOS) {
      final result = await showCupertinoModalPopup<DateTime>(
        context: context,
        builder: (context) => CupertinoTimePickerModal(
          initialDateTime: DateTime.now(),
        ),
      );

      if (result != null) {
        picked = TimeOfDay.fromDateTime(result);
      }
    } else {
      // Android time picker
      picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
    }

    if (!mounted) return;
    if (picked != null) {
      final pickedTime = picked;
      final now = DateTime.now();
      // Fix selected time into current date
      final scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Check that time is in the future
      if (scheduledDate.isBefore(now)) {
        setState(() {
          displayError = "You can only set a future time today.";
        });
        return;
      }

      setState(() {
        selectedTime = pickedTime;
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

  void _deleteTodo(BuildContext ctx) async {
    await ref.read(todosProvider.notifier).deleteTodo(currentTodo!.id);
    if (context.mounted) {
      Navigator.of(ctx).pop();
    }
  }

  void _handleSave(BuildContext ctx) async {
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
        ? await ref.read(todosProvider.notifier).updateTodo(todo)
        : await ref.read(todosProvider.notifier).addTodo(todo);

    if (error != null) {
      setState(() => displayError = error);
    } else if (context.mounted) {
      Navigator.of(ctx).pop();
    }
  }

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
                  style: AppTextStyles.subHeading16w7.copyWith(height: 1)),
              if (isEdit) ...[
                const Spacer(),
                InkWell(
                  onTap: () => _deleteTodo(context),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: AppColors.red,
                  ),
                ),
              ],
            ],
          ),
          2.hi,
          // Text field for entering the todo description.
          AppTextField(
            hintText: 'Make something',
            controller: _controller,
          ),
          30.hi,
          // Group selection row with add group button.
          Text('Group Task', style: AppTextStyles.body13w7),
          8.hi,
          // List of group tags to select from.
          groups.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'No group yet',
                    style: AppTextStyles.body13w6
                        .copyWith(color: AppColors.grey7E, height: 1),
                  ),
                )
              : Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
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
                  ],
                ),
          16.hi,
          // Reminder toggle row.
          Row(
            children: [
              Text('Remind me', style: AppTextStyles.body13w7),
              const Spacer(),
              CheckCircle(
                isChecked: setReminder,
                activeColor: AppColors.lightPrimary,
                onTap: () {
                  setState(() {
                    setReminder = !setReminder;
                    if (!setReminder) {
                      selectedTime = null;
                      displayError = null;
                    }
                  });
                },
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
                  border: Border.all(color: AppColors.lightPrimary, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedTime != null
                          ? selectedTime!.format(context)
                          : '00:00 --',
                      style: AppTextStyles.body13w7
                          .copyWith(color: AppColors.primaryColor),
                    ),
                    4.wi,
                    const Icon(Icons.alarm, color: AppColors.primaryColor, size: 16),
                  ],
                ),
              ),
            ),
          ],
          // Error message display.
          if (displayError != null) ...[
            8.hi,
            Text(
              displayError!,
              style: AppTextStyles.lable12w5.copyWith(color: Colors.redAccent),
            ),
          ],
          40.hi,
          // Done button to save the todo.
          Align(
            alignment: Alignment.centerRight,
            child: Button(
              'Done',
              onTap: () => _handleSave(context),
            ),
          ),
          40.hi,
        ],
      ),
    );
  }
}
