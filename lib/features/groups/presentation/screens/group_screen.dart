import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/responsive_extensions.dart';
import 'package:todo_sample_app/core/widgets/app_modal.dart';
import 'package:todo_sample_app/core/widgets/empty_state.dart';
import 'package:todo_sample_app/features/groups/presentation/screens/group_todo_screen.dart.dart';
import 'package:todo_sample_app/features/groups/presentation/widgets/group_modal.dart';
import 'package:todo_sample_app/features/groups/presentation/widgets/grouped_task_widget.dart';
import 'package:todo_sample_app/features/providers.dart';

/// Screen displaying all task groups in the app.
/// Shows a list of groups or an empty state if none exist.
/// Allows adding, long press to edit, and swipe to delete groups.

class GroupScreen extends ConsumerWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todosProvider);
    final groups = ref.watch(groupProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Grouped Task', style: AppTextStyles.heading24w7),
                      Text(
                        'Organise your task in groups',
                        style: AppTextStyles.body14w5,
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => showAppDialog(
                      context: context,
                      child: GroupModal(),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: AppColors.lightPrimary,
                          shape: BoxShape.circle),
                      child:
                          Icon(Icons.add, color: AppColors.whitefe, size: 24),
                    ),
                  ),
                ],
              ),
              8.hi,
              Expanded(
                child: groups.isEmpty
                    ? EmptyState('No Group Yet')
                    : ListView.separated(
                        itemCount: groups.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final group = groups[index];
                          final color = Color(group.colorValue);
                          final groupTodos = todoList
                              .where((todo) => todo.groupId == group.id)
                              .toList();
                          final completedTodos =
                              groupTodos.where((t) => t.isDone).length;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupTodoListScreen(
                                    group.id,
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              showAppDialog(
                                context: context,
                                child: GroupModal(
                                  group: group,
                                ),
                              );
                            },
                            child: GroupedTaskWidget(
                              text: group.name,
                              subText: group.description,
                              bgColor: color,
                              completedTasks: completedTodos,
                              totalTasks: groupTodos.length,
                              onDelete: () async {
                                await ref
                                    .read(groupProvider.notifier)
                                    .deleteGroup(group.id);
                              },
                            ),
                          );
                        },
                      ),
              ),
              4.hi,
            ],
          ),
        ),
      ),
    );
  }
}
