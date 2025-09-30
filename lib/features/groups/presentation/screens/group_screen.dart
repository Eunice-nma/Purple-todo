import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/utils_exports.dart';
import 'package:todo_sample_app/core/widgets/app_modal.dart';
import 'package:todo_sample_app/features/groups/presentation/screens/group_todo_screen.dart.dart';
import 'package:todo_sample_app/features/groups/presentation/widgets/group_modal.dart';
import 'package:todo_sample_app/features/groups/presentation/widgets/grouped_task_widget.dart';
import 'package:todo_sample_app/features/groups/providers.dart';

class GroupScreen extends ConsumerWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todosProvider);
    final groups = ref.watch(groupProvider);
    return Scaffold(
      backgroundColor: AppColors.whitefe,
      resizeToAvoidBottomInset:
          true, // This makes the UI move up when keyboard appears
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section with greeting and avatar
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Grouped Task', style: AppTextStyles.heading24w7),
                      Text(
                        'Organise your task in groups',
                        style: AppTextStyles.body13w5,
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
                          color: AppColors.lightPurple, shape: BoxShape.circle),
                      child:
                          Icon(Icons.add, color: AppColors.whitefe, size: 24),
                    ),
                  ),
                ],
              ),
              8.hi,

              Expanded(
                child: groups.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No Groups Yet',
                              style: AppTextStyles.subHeading16w6.copyWith(
                                color: AppColors.greyBF,
                              ),
                            ),
                            Text(
                              'Create groups to organize your tasks',
                              style: AppTextStyles.body12w4.copyWith(
                                color: AppColors.grey71,
                              ),
                            ),
                          ],
                        ),
                      )
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
                                  builder: (context) => TodoListScreen(
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
