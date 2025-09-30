import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/utils_exports.dart';
import 'package:todo_sample_app/core/widgets/app_bottom_sheet.dart';
import 'package:todo_sample_app/features/groups/presentation/widgets/todo_bottom_sheet.dart';
import 'package:todo_sample_app/features/groups/presentation/widgets/todo_item_widget.dart';
import 'package:todo_sample_app/features/groups/providers.dart';

// HomeScreen displays the main dashboard with tasks and groups
class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the todo list and groups from Riverpod providers
    final todoList = ref.watch(todosProvider);
    final groups = ref.watch(groupProvider);

    return Scaffold(
      backgroundColor: AppColors.whitefe,
      resizeToAvoidBottomInset:
          true, // This makes the UI move up when keyboard appears
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section with greeting and avatar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Morning!', style: AppTextStyles.heading24w7),
                  Text(
                    'It\'s about the journey',
                    style: AppTextStyles.body13w5,
                  ),
                ],
              ),
              8.hi,

              // Banner container
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              24.hi,
              // Main content area
              Row(
                children: [
                  Text(
                    'Your Tasks',
                    style: AppTextStyles.subHeading16w6,
                  ),
                  const Spacer(),
                  if (todoList.isNotEmpty)
                    InkWell(
                      onTap: () => showAppBottomSheet(
                        context: context,
                        child: const TodoBottomSheet(),
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppColors.purple,
                        size: 24,
                        weight: 900,
                      ),
                    ),
                ],
              ),
              8.hi,
              // Show message if no tasks exist
              todoList.isEmpty
                  ? Center(
                      child: Text(
                        'No tasks yet, add a task',
                        style: AppTextStyles.subHeading16w6.copyWith(
                          color: AppColors.greyBF,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              // Render each todo item
              // Use Expanded to let the list take up available space
              todoList.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: todoList.length,
                        itemBuilder: (context, index) {
                          final todo = todoList[index];
                          final group = groups
                              .where((g) => g.id == todo.groupId)
                              .firstOrNull;
                          final groupColor =
                              group != null ? Color(group.colorValue) : null;
                          return TodoItemWidget(
                            task: todo,
                            groupColor: groupColor,
                            onTap: () {
                              showAppBottomSheet(
                                context: context,
                                child: TodoBottomSheet(
                                  todo: todo,
                                ),
                              );
                            },
                            onToggle: () {
                              ref
                                  .read(todosProvider.notifier)
                                  .toggleTodo(todo.id);
                            },
                            onDelete: () {},
                          );
                        },
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
