import 'package:flutter/material.dart';
import 'package:kursova/screens/sign_in_screen.dart';
import '../widgets/add_task_form.dart';
import '../widgets/task_card.dart';
import '../services/database_helper.dart';

class HomeScreen extends StatefulWidget {
  final int userId; // Тепер передається лише userId

  const HomeScreen({
    Key? key,
    required this.userId, // Використовуємо userId
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int currentUserId;
  List<Map<String, dynamic>> tasks = [];
  final TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUserId = widget.userId; // Ініціалізація currentUserId
    loadTasks(); // Завантаження завдань при старті екрану
  }

  // Завантаження завдань з бази даних
  Future<void> loadTasks() async {
    List<Map<String, dynamic>> tasksFromDb = await DatabaseHelper().getTasks(currentUserId);

    setState(() {
      tasks = List.from(tasksFromDb);
    });
  }
  void _toggleTaskCompletion(int index) async {
    // Отримуємо завдання за індексом
    Map<String, dynamic> task = tasks[index];

    // Змінюємо статус на протилежний
    bool isCurrentlyComplete = task['isComplete'] == 1;
    await DatabaseHelper().updateTaskStatus(task['id'], !isCurrentlyComplete);

    // Перезавантажуємо список завдань
    loadTasks();
  }



  // Додавання нового завдання в базу даних
  void addTask(String taskText) async {
    await DatabaseHelper().addTask(taskText, DateTime.now().toString(), currentUserId);
    loadTasks(); // Перезавантаження завдань після додавання
  }

  void _editTask(BuildContext context, int index) {
    TextEditingController _editController = TextEditingController(text: tasks[index]['task']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(hintText: 'Edit your task'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String updatedTask = _editController.text.trim();
                if (updatedTask.isNotEmpty) {
                  // Оновлення завдання в базі даних
                  await DatabaseHelper().updateTask(tasks[index]['id'], updatedTask);
                  // Перезавантажуємо список завдань
                  loadTasks();
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()), // Повернення на екран входу
                );
              } else if (value == 'delete_account') {
                bool confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Підтвердження"),
                    content: Text("Ви впевнені, що хочете видалити акаунт?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("Скасувати"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text("Видалити"),
                      ),
                    ],
                  ),
                );
                if (confirm) {
                  await DatabaseHelper().deleteUser(currentUserId); // Видалення акаунта з бази
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()), // Повернення на екран входу
                  );
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Text("Вийти"),
              ),
              PopupMenuItem(
                value: 'delete_account',
                child: Text("Видалити акаунт"),
              ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          // Форма для додавання завдання
          AddTaskForm(
            controller: taskController,
            onAddTask: (taskText) {
              addTask(taskText);
            },
          ),
          // Список завдань
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  task: tasks[index]['task'],
                  createdAt: tasks[index]['created_at'],
                  isComplete: tasks[index]['isComplete'] == 1, // Додаємо статус
                  onDelete: () {
                    setState(() {
                      tasks.removeAt(index);
                    });
                    DatabaseHelper().deleteTask(tasks[index]['id']);
                  },
                  onEdit: () {
                    _editTask(context, index);
                  },
                  onComplete: () {
                    _toggleTaskCompletion(index); // Перемикаємо статус завдання
                  },

                );

              },
            ),
          ),
        ],
      ),
    );
  }
}
