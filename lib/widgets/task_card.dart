import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String task;
  final String createdAt;
  final bool isComplete;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onComplete;

  const TaskCard({
    required this.task,
    required this.createdAt,
    required this.isComplete,
    required this.onDelete,
    required this.onEdit,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          task,
          style: TextStyle(
            decoration: isComplete ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(createdAt),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(
                isComplete ? Icons.check_box : Icons.check_box_outline_blank,
                color: isComplete ? Colors.green : null,
              ),
              onPressed: onComplete,
            ),

            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

