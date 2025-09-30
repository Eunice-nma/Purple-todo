import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing and retrieving todo data.
class StorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Key for storing the todo list.
  final String todoKey = 'todos';
  // Key for storing grouped todo list.
  final String groupedTodoKey = 'grouped_todos';

  /// Saves the todo list as a JSON string.
  Future<void> saveTodoList(String todosJson) async {
    await _storage.write(key: todoKey, value: todosJson);
  }

  /// Retrieves the todo list JSON string.
  Future<String?> getTodoList() async {
    return await _storage.read(key: todoKey);
  }

  /// Saves the grouped todo list as a JSON string.
  Future<void> saveGroups(String todosJson) async {
    await _storage.write(key: groupedTodoKey, value: todosJson);
  }

  /// Retrieves the grouped todo list JSON string.
  Future<String?> getGroups() async {
    return await _storage.read(key: groupedTodoKey);
  }

  /// Clears all stored data.
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
