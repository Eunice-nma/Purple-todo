import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/utils_exports.dart';
import 'package:todo_sample_app/core/widgets/app_bottom_sheet.dart';
import 'package:todo_sample_app/features/todos/presentation/widgets/todo_bottom_sheet.dart';
import 'package:todo_sample_app/features/todos/presentation/widgets/todo_item_widget.dart';
import 'package:todo_sample_app/features/todos/presentation/screens/todo_list_screen.dart';
import 'package:todo_sample_app/features/todos/providers.dart';

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
                      Text('Good Morning!', style: AppTextStyles.heading24w7),
                      Text(
                        'It\'s about the journey',
                        style: AppTextStyles.body13w5,
                      ),
                    ],
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundColor: AppColors.purple,
                    radius: 20,
                  )
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Your Tasks" section header and navigation
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
                      12.hi,
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
                      ...todoList.map((todo) {
                        final group = groups
                            .where((g) => g.id == todo.groupId)
                            .firstOrNull;
                        final groupColor =
                            group != null ? Color(group.colorValue) : null;
                        return TodoItemWidget(
                          task: todo,
                          groupColor: groupColor,
                          onTap: () {
                            // Tap to edit todo
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
                      }),
                      12.hi,
                      // Button to add a new todo
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => showAppBottomSheet(
                            context: context,
                            child: const TodoBottomSheet(),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: AppColors.lightPurple,
                                shape: BoxShape.circle),
                            child: Icon(Icons.add,
                                color: AppColors.whitefe, size: 30),
                          ),
                        ),
                      ),
                      16.hi,

// move to greoup page

                      // "Grouped Tasks" section header
                      // Text(
                      //   'Grouped Tasks',
                      //   style: AppTextStyles.subHeading16w6,
                      // ),
                      // 8.hi,
                      // // Show message if no groups exist
                      // if (groups.isEmpty)
                      //   Center(
                      //     child: Column(
                      //       children: [
                      //         Text(
                      //           'No Groups Yet',
                      //           style: AppTextStyles.subHeading16w6.copyWith(
                      //             color: AppColors.greyBF,
                      //           ),
                      //         ),
                      //         Text(
                      //           'Create groups to organize your tasks',
                      //           style: AppTextStyles.body12w4.copyWith(
                      //             color: AppColors.grey71,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   )
                      // else
                      //   // Render each group with its tasks
                      //   ...groups.map((group) {
                      //     final color = Color(group.colorValue);
                      //     final groupTodos = todoList
                      //         .where((todo) => todo.groupId == group.id)
                      //         .toList();
                      //     final completedTodos =
                      //         groupTodos.where((t) => t.isDone).length;
                      //     return GestureDetector(
                      //       onTap: () {
                      //         // Navigate to filtered todo list for this group
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => TodoListScreen(
                      //               group: group,
                      //               // filterGroupId: group.id,
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //       onLongPress: () {
                      //         // Long press to edit group
                      //         showAppDialog(
                      //           context: context,
                      //           child: GroupModal(
                      //             group: group,
                      //           ),
                      //         );
                      //       },
                      //       child: GroupedTaskWidget(
                      //         text: group.name,
                      //         subText: group.description,
                      //         bgColor: color,
                      //         completedTasks: completedTodos,
                      //         totalTasks: groupTodos.length,
                      //       ),
                      //     );
                      //   })
                    ],
                  ),
                ),
              ),
              4.hi,
              // Floating add button at the bottom
              // Align(
              //   alignment: Alignment.center,
              //   child: InkWell(
              //     onTap: () async {
              //       // await NotificationService.testNowNotification();
              //       // await NotificationService.showInstantNotification(
              //       //   id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
              //       //   title: "Hello from Todo App",
              //       //   body: "This is a test notification",
              //       // );
              //     },
              //     child: Container(
              //       width: 50,
              //       height: 50,
              //       decoration: BoxDecoration(
              //         color: AppColors.white,
              //         borderRadius: BorderRadius.circular(12),
              //         boxShadow: [
              //           BoxShadow(
              //             color: AppColors.purple.withValues(alpha: 0.3),
              //             blurRadius: 10,
              //             offset: const Offset(0, 4),
              //           ),
              //         ],
              //       ),
              //       child: Icon(Icons.add, color: AppColors.purple, size: 30),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
