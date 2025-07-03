import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/historique.dart';
import '../database/password_hasher.dart';

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
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

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
    try {
      String hashedPassword = PasswordHasher.hashPassword(user.password);
      User userWithHashedPassword = User(
        id: user.id,
        username: user.username,
        email: user.email,
        password: hashedPassword,
      );
      return await db.insert('users', userWithHashedPassword.toMap());
    } catch (e) {
      return -1;
    }
  }

  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      final user = User.fromMap(maps.first);
      if (PasswordHasher.verifyPassword(password, user.password)) {
        return user;
      }
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
    return List.generate(maps.length, (i) => Historique.fromMap(maps[i]));
  }
}