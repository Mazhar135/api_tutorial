import 'package:flutter/material.dart';

import '../viewmodel/todo_viewmodel.dart';

class CreateTodoScreen extends StatefulWidget {
  const CreateTodoScreen({super.key});

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  final viewModel = TodoViewModel();
  final titleController = TextEditingController();
  bool completed = false;

  @override
  void initState() {
    super.initState();
    viewModel.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    viewModel.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('POST API Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Todo title'),
            ),
            SwitchListTile(
              title: const Text('Completed'),
              value: completed,
              onChanged: (value) => setState(() => completed = value),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: viewModel.isLoading
                  ? null
                  : () => viewModel.createTodo(
                titleController.text,
                completed,
              ),
              child: viewModel.isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text('Create Todo'),
            ),
            const SizedBox(height: 20),
            Text(viewModel.result),
          ],
        ),
      ),
    );
  }
}