import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/todo_model.dart';

class TodoService {
  static const _url = 'https://jsonplaceholder.typicode.com/todos';

  Future<TodoModel> createTodo(TodoModel todo) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 201) {
      return TodoModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed. Status code: ${response.statusCode}');
    }
  }
}