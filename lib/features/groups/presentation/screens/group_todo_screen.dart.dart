import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/utils_exports.dart';
import 'package:todo_sample_app/core/widgets/app_bottom_sheet.dart';
import 'package:todo_sample_app/core/widgets/app_modal.dart';
import 'package:todo_sample_app/core/widgets/empty_state.dart';
import 'package:todo_sample_app/features/groups/presentation/widgets/group_modal.dart';
import 'package:todo_sample_app/features/groups/presentation/widgets/grouped_task_widget.dart';
import 'package:todo_sample_app/features/todo/presentation/widget/todo_bottom_sheet.dart';
import 'package:todo_sample_app/features/providers.dart';
import 'package:todo_sample_app/features/todo/presentation/widget/todo_item_widget.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen(this.groupId, {super.key});
  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todosProvider);
    final groups = ref.watch(groupProvider);

    final group = groups.firstWhere((g) => g.id == groupId);

    final displayTodos = todoList
        .where((todo) => todo.groupId == group.id)
        .toList(growable: false);

    final completedTaskLenght = displayTodos
        .where((todo) => todo.isDone)
        .toList(growable: false)
        .length;
    final groupColor = Color(group.colorValue);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      weight: 700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => showAppDialog(
                      context: context,
                      child: GroupModal(
                        group: group,
                      ),
                    ),
                    icon: Icon(
                      Icons.edit,
                      color: Color.lerp(
                          Color(group.colorValue), Colors.black, 0.1)!,
                      size: 18,
                    ),
                  )
                ],
              ),
              20.hi,
              GroupedTaskWidget(
                text: group.name,
                subText: group.description,
                bgColor: groupColor,
                completedTasks: completedTaskLenght,
                totalTasks: displayTodos.length,
              ),
              10.hi,
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => showAppBottomSheet(
                    context: context,
                    child: TodoBottomSheet(
                      predefinedGroupId: group.id,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color.lerp(
                          Color(group.colorValue), Colors.black, 0.1)!,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, color: AppColors.whitefe, size: 24),
                  ),
                ),
              ),
              10.hi,
              Expanded(
                child: displayTodos.isEmpty
                    ? EmptyState('No Task Yet')
                    : ListView(
                        children: displayTodos.map((todo) {
                          return TodoItemWidget(
                            task: todo,
                            groupColor: Color(group.colorValue),
                            useGroupStyle: true,
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
                            onDelete: () {
                              ref
                                  .read(todosProvider.notifier)
                                  .toggleTodo(todo.id);
                            },
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
