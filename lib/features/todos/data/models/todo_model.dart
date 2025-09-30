import 'package:flutter/material.dart';

/// Model class representing a Todo item.
class Todo {
  /// Unique identifier for the todo.
  final int id;
  final String description;
  final bool isDone;

  /// Optional reminder time for the todo.
  final TimeOfDay? reminderTime;

  /// Optional group identifier for categorizing todos.
  final String? groupId;

  /// Creates a [Todo] instance.
  Todo({
    required this.id,
    required this.description,
    this.isDone = false,
    this.reminderTime,
    this.groupId,
  });

  /// Creates a copy of this [Todo] with optional new values.
  Todo copyWith({
    int? id,
    String? description,
    bool? isDone,
    TimeOfDay? reminderTime,
    String? groupId,
  }) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      reminderTime: reminderTime ?? this.reminderTime,
      groupId: groupId ?? this.groupId,
    );
  }

  /// Converts the [Todo] instance to a JSON map for storage.
  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'isDone': isDone,
        'reminderTime': reminderTime != null
            ? {'hour': reminderTime!.hour, 'minute': reminderTime!.minute}
            : null,
        'groupId': groupId
      };

  /// Creates a [Todo] instance from a JSON map.
  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'] as int,
        description: json['description'] as String,
        isDone: json['isDone'],
        reminderTime: json['reminderTime'] != null
            ? TimeOfDay(
                hour: json['reminderTime']['hour'],
                minute: json['reminderTime']['minute'])
            : null,
        groupId: json['groupId'] as String?,
      );
}
