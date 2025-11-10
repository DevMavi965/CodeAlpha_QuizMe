import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/flashcard.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'flashcards.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE flashcards(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        options TEXT NOT NULL,
        correctAnswerIndex INTEGER NOT NULL,
        explanation TEXT
      )
    ''');
  }

  // CRUD operations
  Future<int> insertFlashcard(Flashcard flashcard) async {
    final db = await database;
    return await db.insert('flashcards', flashcard.toMap());
  }

  Future<List<Flashcard>> getFlashcards() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('flashcards');
    return List.generate(maps.length, (i) => Flashcard.fromMap(maps[i]));
  }

  Future<int> updateFlashcard(Flashcard flashcard) async {
    final db = await database;
    return await db.update(
      'flashcards',
      flashcard.toMap(),
      where: 'id = ?',
      whereArgs: [flashcard.id],
    );
  }

  Future<int> deleteFlashcard(int id) async {
    final db = await database;
    return await db.delete(
      'flashcards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}