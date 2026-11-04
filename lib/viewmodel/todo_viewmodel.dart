import 'package:flutter/foundation.dart';

import '../model/todo_model.dart';
import '../services/todo_service.dart';

class TodoViewModel extends ChangeNotifier {
  final TodoService _service = TodoService();

  bool isLoading = false;
  String result = '';

  Future<void> createTodo(String title, bool completed) async {
    isLoading = true;
    result = '';
    notifyListeners();

    try {
      final todo = await _service.createTodo(
        TodoModel(title: title, completed: completed),
      );
      result = 'Todo created!\n'
          'ID: ${todo.id}\n'
          'Title: ${todo.title}\n'
          'Completed: ${todo.completed}';
    } catch (e) {
      result = 'Error: $e';
    }

    isLoading = false;
    notifyListeners();
  }
}