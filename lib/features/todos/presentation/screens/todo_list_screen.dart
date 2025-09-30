import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/utils_exports.dart';
import 'package:todo_sample_app/core/widgets/app_bottom_sheet.dart';
import 'package:todo_sample_app/features/todos/data/models/grouped_todo_model.dart';
import 'package:todo_sample_app/features/todos/presentation/widgets/grouped_task_widget.dart';
import 'package:todo_sample_app/features/todos/presentation/widgets/todo_bottom_sheet.dart';
import 'package:todo_sample_app/features/todos/providers.dart';
import 'package:todo_sample_app/features/todos/presentation/widgets/todo_item_widget.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({this.group, super.key});
  final GroupedTodo? group;

//   @override
//   State<TodoListScreen> createState() => _TodoListScreenState();
// }

// class _TodoListScreenState extends State<TodoListScreen> {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todosProvider);

    final groups = ref.watch(groupProvider);

    final displayTodos = group == null
        ? todoList
        : todoList
            .where((todo) => todo.groupId == group!.id)
            .toList(growable: false);

    final completedTaskLenght = displayTodos
        .where((todo) => todo.isDone)
        .toList(growable: false)
        .length;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      weight: 700,
                    ),
                  ),
                  //     Text(
                  //       'All Task',
                  //       style: AppTextStyles.body15w7,
                  //     ),
                  // SizedBox.shrink()
                  Icon(
                    Icons.edit,
                    size: 20,
                    color: Color.lerp(AppColors.lightPink, Colors.black, 0.1)!,
                    weight: 700,
                  ),
                ],
              ),
              20.hi,
              GroupedTaskWidget(
                text: group?.name ?? 'All Tasks',
                subText: group?.description ?? 'Overall Progress for the day',
                bgColor: group != null
                    ? Color(group!.colorValue)
                    : AppColors.lightPurple,
                completedTasks: completedTaskLenght,
                totalTasks: displayTodos.length,
              ),
              20.hi,

              Expanded(
                child: ListView(
                  children: displayTodos.map((todo) {

                        final group = groups
                            .where((g) => g.id == todo.groupId)
                            .firstOrNull;
                        final groupColor =
                            group != null ? Color(group.colorValue) : null;
                    return TodoItemWidget(
                      task: todo,
                      groupColor:groupColor,
                      useGroupStyle: group != null,
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
                        ref.read(todosProvider.notifier).toggleTodo(todo.id);
                      },
                      onDelete: () {},
                    );
                  }).toList(),
                ),
              ),
              // TodoItemWidget(
              //   text: 'Build a To-do App',
              //   borderColor: AppColors.lightPink,
              //   // isChecked: true,
              //   time: '10:00 AM',
              // ),
              // TodoItemWidget(
              //   text: 'Something else Build a To-do App',
              //   borderColor: AppColors.lightPink,
              //   isChecked: true,
              //   // time: '10:00 AM',
              // ),
              // TodoItemWidget(
              //   text: 'Another thing Build a To-do App',
              //   borderColor: AppColors.lightPink,
              //   // isChecked: true,
              // ),
              // TodoItemWidget(
              //   text: 'Another thing Build a To-do App',
              //   borderColor: AppColors.lightPink,
              //   // isChecked: true,
              // ),
              // TodoItemWidget(
              //   text: 'Another thing Build a To-do App',
              //   borderColor: AppColors.lightPink,
              //   isChecked: true,
              // ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () {}),
    );
  }
}
