import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton для DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  // Конструктор
  DatabaseHelper._internal();

  static Database? _database;

  // Отримання інстансу бази даних
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Ініціалізація бази даних
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;'); // Увімкнення зовнішніх ключів
      },
    );
  }

  // Створення таблиць
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task TEXT,
        created_at TEXT,
        user_id INTEGER,
        isComplete BOOLEAN DEFAULT 0,
        FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE        
      )
    ''');

  }


  Future<int> addUser(String name, String email, String password) async {
    final db = await database;
    return await db.insert('users', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> deleteUser(int userId) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }

  // Методи роботи із завданнями
  Future<int> addTask(String task, String createdAt, int userId) async {
    final db = await database;
    return await db.insert('tasks', {
      'task': task,
      'created_at': createdAt,
      'user_id': userId,
    });
  }

  Future<List<Map<String, dynamic>>> getTasks(int userId) async {
    final db = await database;
    return await db.query(
      'tasks',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'isComplete ASC, created_at DESC', // Спочатку невиконані, потім новіші завдання.
    );
  }


  Future<void> updateTask(int taskId, String newTask) async {
    final db = await database;
    await db.update(
      'tasks',
      {'task': newTask},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }
  Future<void> updateTaskStatus(int taskId, bool isComplete) async {
    final db = await database;
    await db.update(
      'tasks',
      {'isComplete': isComplete ? 1 : 0},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<void> deleteTask(int taskId) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
  }
}
