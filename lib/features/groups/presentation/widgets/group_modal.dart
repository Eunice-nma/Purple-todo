// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/responsive_extensions.dart';
import 'package:todo_sample_app/core/widgets/button.dart';
import 'package:todo_sample_app/core/widgets/text_field.dart';
import 'package:todo_sample_app/features/groups/models/grouped_todo_model.dart';
import 'package:todo_sample_app/features/providers.dart';

class GroupModal extends ConsumerStatefulWidget {
  const GroupModal({this.group, super.key});
  final GroupedTodo? group; // If not null, this is an edit operation.

  @override
  ConsumerState<GroupModal> createState() => _GroupModalState();
}

class _GroupModalState extends ConsumerState<GroupModal> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  Color selectedColor = AppColors.lightPrimary;
  String? displayError;
  late final bool isEdit;
  GroupedTodo? currentGroup;

  @override
  void initState() {
    super.initState();
    isEdit = widget.group != null;
    currentGroup = widget.group;

    if (isEdit) {
      final group = widget.group!;
      _nameCtrl.text = group.name;
      _descCtrl.text = group.description;
      selectedColor = Color(group.colorValue);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isEdit ? 'Edit Group' : 'Create New Group',
              style: AppTextStyles.subHeading16w7),
          20.hi,
          AppTextField(
            controller: _nameCtrl,
            labelText: "Group Name",
            hintText: "Work",
          ),
          8.hi,
          AppTextField(
            controller: _descCtrl,
            labelText: "Description",
            hintText: "Tasks for the day and meetings",
          ),
          12.hi,
          Text('Choose Color', style: AppTextStyles.body13w7),
          6.hi,
          Row(
            children: [
              ...AppColors.groupColors.map(
                (color) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            selectedColor == color ? color : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          16.hi,
          Align(
            alignment: Alignment.centerRight,
            child: Button(
              'Done',
              onTap: () => _handleSaveGroup(context),
            ),
          ),
          12.hi,
          if (displayError != null) ...[
            Center(
              child: Text(
                displayError!,
                style: AppTextStyles.lable12w5.copyWith(color: AppColors.red),
              ),
            ),
            12.hi,
          ]
        ],
      ),
    );
  }

  Future<void> _handleSaveGroup(BuildContext ctx) async {
    final name = _nameCtrl.text.trim();
    final description = _descCtrl.text.trim();

    if (name.isEmpty) {
      setState(() => displayError = "Group name cannot be empty");
      return;
    }

    final notifier = ref.read(groupProvider.notifier);

    if (isEdit) {
      final updatedGroup = currentGroup!.copyWith(
        name: name,
        description: description,
        colorValue: selectedColor.value,
      );
      await notifier.updateGroup(updatedGroup);
    } else {
      final group = GroupedTodo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        colorValue: selectedColor.value,
      );
      await notifier.addGroup(group);
    }

    if (context.mounted) {
      Navigator.of(ctx).pop();
    }
  }
}
