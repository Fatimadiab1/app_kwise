import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/historique.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'kwise.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // table des utilisateurs
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    // table historique
    await db.execute('''
      CREATE TABLE historique (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        difficulty TEXT,
        score INTEGER,
        date TEXT
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps.map((map) => User.fromMap(map)).toList();
  }

  Future<void> insertHistorique(Historique historique) async {
    final db = await database;
    await db.insert(
      'historique',
      historique.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Historique>> getHistorique() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'historique',
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Historique.fromMap(maps[i]);
    });
  }
}
