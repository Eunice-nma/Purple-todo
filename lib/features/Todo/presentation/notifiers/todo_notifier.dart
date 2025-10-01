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
  Future<String?> addTodo(Todo todo) async {
    if (todo.reminderTime != null) {
      await NotificationService.cancelNotification(todo.id);
      final error = await NotificationService.scheduleNotification(
        id: todo.id,
        body: todo.description,
        scheduledTime: todo.reminderTime!,
      );
      if (error != null) return error; // Return error
    }

    state = [todo, ...state];
    await _persist();
    return null; // Success
  }

  Future<String?> updateTodo(
    Todo updated,
  ) async {
    /// Handle reminder
    ///
    /// Always attempt to cancel reminder if the update does not have a [reminderTime]
    if (updated.reminderTime == null) {
      await NotificationService.cancelNotification(updated.id);
    } else {
      // Check for current time
      final now = DateTime.now();
      final scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        updated.reminderTime!.hour,
        updated.reminderTime!.minute,
      );

      // Reschedule with updated information if reminder is still in the future
      if (scheduledDateTime.isAfter(now)) {
        await NotificationService.cancelNotification(updated.id);

        // Await for any error that may handle during [scheduleNotification]
        final error = await NotificationService.scheduleNotification(
          id: updated.id,
          body: updated.description,
          scheduledTime: updated.reminderTime!,
        );

        if (error != null) return error;
      } else {
        // Cancel Reminders that are past
        await NotificationService.cancelNotification(updated.id);
      }
    }

    // Update state
    state = state.map((t) => t.id == updated.id ? updated : t).toList();
    await _persist();
    return null;
  }

  /// Toggles the completion status (`isDone`) of a todo item with the given [id].
  Future<void> toggleTodo(int id) async {
    state = state
        .map((t) => t.id == id ? t.copyWith(isDone: !t.isDone) : t)
        .toList();
    await _persist();
  }

  /// Deletes a todo item by its [id].
  Future<void> deleteTodo(int id) async {
    NotificationService.cancelNotification(id);
    state = state.where((t) => t.id != id).toList();
    await _persist();
  }

  /// Persists the current state of todos to storage
  Future<void> _persist() async {
    final encoded = jsonEncode(state.map((t) => t.toJson()).toList());
    await storage.saveTodoList(encoded);
  }

  /// Delete all stored Todos and cancel any available Notifications
  /// Clear immediate app state
  Future<void> clearAll() async {
    await storage.clearAll();
    NotificationService.cancelAllNotifications();
    state = [];
  }
}
