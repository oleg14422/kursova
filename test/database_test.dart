import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/services/database_helper.dart';

void main() async {
  final db = DatabaseHelper();

  // Тестові дані
  const testUserName = 'Test User';
  const testUserEmail = 'test@example.com';
  const testUserPassword = 'password123';

  const testTask1 = 'Test Task 1';
  const testTask2 = 'Test Task 2';
  const testCreatedAt = '2024-01-01 10:00:00';

  group('Database Tests', () {
    test('Add and fetch user', () async {
      // Додавання користувача
      final userId = await db.addUser(testUserName, testUserEmail, testUserPassword);
      expect(userId, isNotNull);

      // Отримання користувача
      final user = await db.getUser(testUserEmail, testUserPassword);
      expect(user, isNotNull);
      expect(user?['name'], testUserName);
    });

    test('Add and fetch tasks', () async {
      // Отримання ID користувача
      final user = await db.getUser(testUserEmail, testUserPassword);
      final userId = user?['id'];
      expect(userId, isNotNull);

      // Додавання завдань
      final taskId1 = await db.addTask(testTask1, testCreatedAt, userId!);
      final taskId2 = await db.addTask(testTask2, testCreatedAt, userId);
      expect(taskId1, isNotNull);
      expect(taskId2, isNotNull);

      // Отримання завдань
      final tasks = await db.getTasks(userId);
      expect(tasks.length, 2);
      expect(tasks[0]['task'], testTask1);
      expect(tasks[1]['task'], testTask2);
    });

    test('Update and delete task', () async {
      // Отримання ID користувача
      final user = await db.getUser(testUserEmail, testUserPassword);
      final userId = user?['id'];
      expect(userId, isNotNull);

      // Отримання завдань
      final tasks = await db.getTasks(userId!);
      final taskId = tasks[0]['id'];
      expect(taskId, isNotNull);

      // Оновлення завдання
      const updatedTask = 'Updated Task 1';
      await db.updateTask(taskId, updatedTask);

      // Перевірка оновлення
      final updatedTasks = await db.getTasks(userId);
      expect(updatedTasks[0]['task'], updatedTask);

      // Видалення завдання
      await db.deleteTask(taskId);

      // Перевірка видалення
      final remainingTasks = await db.getTasks(userId);
      expect(remainingTasks.length, 1);
    });

    test('Delete user and cascade tasks', () async {
      // Отримання ID користувача
      final user = await db.getUser(testUserEmail, testUserPassword);
      final userId = user?['id'];
      expect(userId, isNotNull);

      // Видалення користувача
      await db.deleteUser(userId!);

      // Перевірка видалення користувача
      final deletedUser = await db.getUser(testUserEmail, testUserPassword);
      expect(deletedUser, isNull);

      // Перевірка видалення завдань
      final tasks = await db.getTasks(userId);
      expect(tasks.isEmpty, true);
    });
  });
}
