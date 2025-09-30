// import 'package:todo_sample_app/features/todos/data/models/todo_model.dart';
/// Model representing a group of todos.
class GroupedTodo {
  final String id;
  final String name;
  final String description;
  // /// List of tasks (todos) in the group.
  // final List<Todo> tasks;
  /// Color value associated with the group.
  final int colorValue;

  /// Creates a [GroupedTodo] instance.
  GroupedTodo({
    required this.id,
    required this.name,
    required this.description,
    // required this.tasks,
    required this.colorValue,
  });

  /// Creates a copy of this [GroupedTodo] but with the given fields replaced with new values.
  GroupedTodo copyWith({
    String? id,
    String? name,
    String? description,
    // List<Todo>? tasks,
    int? colorValue,
  }) {
    return GroupedTodo(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      // tasks: tasks ?? this.tasks,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  /// Converts the [GroupedTodo] instance to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        // 'tasks': tasks.map((t) => t.toJson()).toList(),
        'colorValue': colorValue,
      };

  /// Creates a [GroupedTodo] instance from a JSON map.
  factory GroupedTodo.fromJson(Map<String, dynamic> json) => GroupedTodo(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        // tasks: ((json['tasks'] ?? []) is List
        //     ? ((json['tasks'] ?? []) as List).map((e) => Todo.fromJson(e)).toList()
        //     : <Todo>[]),
        colorValue: json['colorValue'] ?? 0,
      );
}
