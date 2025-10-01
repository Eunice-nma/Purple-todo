import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/utils_exports.dart';
import 'package:todo_sample_app/core/widgets/app_bottom_sheet.dart';
import 'package:todo_sample_app/core/widgets/empty_state.dart';
import 'package:todo_sample_app/features/groups/presentation/widgets/grouped_task_widget.dart';
import 'package:todo_sample_app/features/todo/presentation/widget/todo_bottom_sheet.dart';
import 'package:todo_sample_app/features/todo/presentation/widget/todo_item_widget.dart';
import 'package:todo_sample_app/features/providers.dart';

// Main screen widget for displaying and managing todos
class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  // Returns a header text based on the progress of completed tasks
  String getHeaderText(double progress) {
    if (progress == 0) {
      return 'Ready to start your day?';
    } else if (progress <= 0.7) {
      return 'Keep going';
    } else if (progress < 1.0) {
      return 'Almost done';
    } else {
      return 'All done!';
    }
  }

  // Returns a greeting based on the current time of day
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the todo list and groups from Riverpod providers
    final todoList = ref.watch(todosProvider);
    final groups = ref.watch(groupProvider);
    final completedCount = todoList.where((t) => t.isDone).length;
    final double progress =
        todoList.isEmpty ? 0 : completedCount / todoList.length;

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
              // Header section with greeting and subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getGreeting(),
                    style: AppTextStyles.heading24w7,
                  ),
                  Text(
                    'It\'s about the journey',
                    style: AppTextStyles.body14w5,
                  ),
                ],
              ),
              8.hi,

              // Banner container showing progress and motivational text
              GroupedTaskWidget(
                text: getHeaderText(progress),
                subText: todoList.isEmpty ? '' : 'Overall progress for the day',
                bgColor: AppColors.purple,
                completedTasks: completedCount,
                totalTasks: todoList.length,
                height: 120,
              ),

              24.hi,
              // Main content area header with "Your Tasks" and add button
              Row(
                children: [
                  Text(
                    'Your Tasks',
                    style: AppTextStyles.subHeading16w7,
                  ),
                  const Spacer(),
                  // Button to open bottom sheet for adding a new todo
                  IconButton(
                    onPressed: () => showAppBottomSheet(
                      context: context,
                      child: const TodoBottomSheet(),
                    ),
                    icon: Icon(
                      Icons.add,
                      color: AppColors.purple,
                      size: 24,
                      weight: 900,
                    ),
                  ),
                ],
              ),
              8.hi,
              // Show message if no tasks exist, otherwise show the list of todos
              Expanded(
                child: todoList.isEmpty
                    ? GestureDetector(
                        // Tap to add a new task if list is empty
                        onTap: () => showAppBottomSheet(
                              context: context,
                              child: const TodoBottomSheet(),
                            ),
                        child: EmptyState('No Task Yet'))
                    : ListView.builder(
                        itemCount: todoList.length,
                        itemBuilder: (context, index) {
                          final todo = todoList[index];
                          // Find the group for the current todo, if any
                          final group = groups
                              .where((g) => g.id == todo.groupId)
                              .firstOrNull;
                          final groupColor =
                              group != null ? Color(group.colorValue) : null;
                          // Widget for displaying a single todo item
                          return TodoItemWidget(
                            task: todo,
                            groupColor: groupColor,
                            onTap: () {
                              // Open bottom sheet to edit the todo
                              showAppBottomSheet(
                                context: context,
                                child: TodoBottomSheet(
                                  todo: todo,
                                ),
                              );
                            },
                            onToggle: () {
                              // Toggle completion status of the todo
                              ref
                                  .read(todosProvider.notifier)
                                  .toggleTodo(todo.id);
                            },
                            onDelete: () {
                              // Delete the todo
                              ref
                                  .read(todosProvider.notifier)
                                  .deleteTodo(todo.id);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
