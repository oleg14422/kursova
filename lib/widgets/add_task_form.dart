import 'package:flutter/material.dart';

class AddTaskForm extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onAddTask;

  const AddTaskForm({
    Key? key,
    required this.controller,
    required this.onAddTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Enter task",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              final taskText = controller.text.trim();
              if (taskText.isNotEmpty) {
                onAddTask(taskText);
                controller.clear();
              }
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
