import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_sample_app/core/services/notification_service.dart';
import 'package:todo_sample_app/core/services/storage_service.dart';
import 'package:todo_sample_app/features/todo/models/todo_model.dart';

// StateNotifier to manage the list of todos
class TodoNotifier extends StateNotifier<List<Todo>> {
  final StorageService storage;

  // Constructor initializes the state and loads todos from storage
  TodoNotifier(this.storage) : super([]) {
    _loadTodos();
  }

  // Loads todos from persistent storage
  Future<void> _loadTodos() async {
    final data = await storage.getTodoList();
    if (data != null) {
      final decoded =
          (jsonDecode(data) as List).map((e) => Todo.fromJson(e)).toList();
      state = decoded;
    }
  }

  // Adds a new todo and persists the updated list
  // Future<void> addTodo(Todo todo) async {
  //   state = [...state, todo];
  //   await _persist();
  // }
  Future<String?> addTodo(Todo todo) async {
    if (todo.reminderTime != null) {
      await NotificationService.cancelNotification(todo.id);
      final error = await NotificationService.scheduleNotification(
        id: todo.id,
        body: todo.description,
        scheduledTime: todo.reminderTime!,
      );
      if (error != null) return error; // Return error instead of throwing
    }

    state = [...state, todo];
    await _persist();
    return null; // Success
  }

  Future<String?> updateTodo(Todo updated, {bool timeChanged = false}) async {
    if (updated.reminderTime != null && timeChanged) {
      await NotificationService.cancelNotification(updated.id);
      final error = await NotificationService.scheduleNotification(
        id: updated.id,
        body: updated.description,
        scheduledTime: updated.reminderTime!,
      );
      if (error != null) return error;
    } else {
      await NotificationService.cancelNotification(updated.id);
    }

    state = state.map((t) => t.id == updated.id ? updated : t).toList();
    await _persist();
    return null;
  }

  /// Toggles the completion status (`isDone`) of a todo item with the given [id].
  ///
  /// This method searches the current list of todos ([state]) for the todo item
  /// matching the provided [id]. If found, it creates a new `Todo` instance with
  /// the same properties as the original, but with the `isDone` property inverted.
  /// All other todos remain unchanged. The updated list replaces the current state.
  ///
  /// After updating the state, the method persists the changes by calling [_persist].
  Future<void> toggleTodo(int id) async {
    state = state
        .map((t) => t.id == id ? t.copyWith(isDone: !t.isDone) : t)
        .toList();
    await _persist();
  }

  /// Updates an existing todo by [id] using a [Todo] object with new values.
  /// Only fields provided in the [updated] object will change.
  // Future<void> updateTodo(Todo updated) async {
  //   state = state
  //       .map((t) => t.id == updated.id
  //           ? t.copyWith(
  //               description: updated.description,
  //               isDone: updated.isDone,
  //               reminderTime: updated.reminderTime,
  //               groupId: updated.groupId,
  //             )
  //           : t)
  //       .toList();
  //   await _persist();
  // }

  /// Deletes a todo item by its [id].
  Future<void> deleteTodo(int id) async {
    NotificationService.cancelNotification(id);
    state = state.where((t) => t.id != id).toList();
    await _persist();
  }

  // Persists the current state of todos to storage
  Future<void> _persist() async {
    final encoded = jsonEncode(state.map((t) => t.toJson()).toList());
    await storage.saveTodoList(encoded);
  }
}
