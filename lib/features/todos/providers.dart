import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_sample_app/core/services/storage_service.dart';
import 'package:todo_sample_app/features/todos/data/models/grouped_todo_model.dart';
import 'package:todo_sample_app/features/todos/data/models/todo_model.dart';
import 'package:todo_sample_app/features/todos/presentation/notifiers/grouped_todo_notifier.dart';
import 'package:todo_sample_app/features/todos/presentation/notifiers/todo_notifier.dart';

// Service provider (storage)
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// Todos state
final todosProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return TodoNotifier(storage);
});

// Sections (groups) state
final groupProvider =
    StateNotifierProvider<GroupNotifier, List<GroupedTodo>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return GroupNotifier(storage);
});
