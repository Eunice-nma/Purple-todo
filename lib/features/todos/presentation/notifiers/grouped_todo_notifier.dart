import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_sample_app/core/services/storage_service.dart';
import 'package:todo_sample_app/features/todos/data/models/grouped_todo_model.dart';
import 'dart:convert';

/// StateNotifier to manage the list of groups
class GroupNotifier extends StateNotifier<List<GroupedTodo>> {
  final StorageService storage;

  // Constructor initializes the state and loads groups from storage
  GroupNotifier(this.storage) : super([]) {
    _loadGroups();
  }

  // Loads groups from persistent storage
  Future<void> _loadGroups() async {
    final data = await storage.getGroups(); // returns String?
    if (data != null) {
      final decoded = (jsonDecode(data) as List)
          .map((e) => GroupedTodo.fromJson(e))
          .toList();
      state = decoded;
    }
  }

  // Adds a new group and persists
  Future<void> addGroup(GroupedTodo group) async {
    state = [...state, group];
    await _persist();
  }

// Updates an existing group by merging changes via copyWith
  Future<void> updateGroup(GroupedTodo group) async {
    state = state.map((g) {
      if (g.id == group.id) {
        // Only update the fields provided, keep others the same
        return g.copyWith(
          name: group.name,
          description: group.description,
          colorValue: group.colorValue,
        );
      }
      return g;
    }).toList();

    await _persist();
  }

  // Deletes a group and persists
  Future<void> deleteGroup(String id) async {
    state = state.where((g) => g.id != id).toList();
    await _persist();
  }

  // Persists the current state of groups to storage
  Future<void> _persist() async {
    final encoded = jsonEncode(state.map((g) => g.toJson()).toList());
    await storage.saveGroups(encoded);
  }
}
