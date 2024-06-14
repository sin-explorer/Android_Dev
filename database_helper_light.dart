import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'light_solutions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE light_solutions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        solutionNumber INTEGER,
        driverType TEXT,
        lightType TEXT,
        useCCTDimmer INTEGER
      )
    ''');
  }

  Future<void> insertLightSolution(Map<String, dynamic> solution) async {
    final db = await database;
    await db.insert('light_solutions', solution);
  }

  Future<List<Map<String, dynamic>>> getLightSolutions() async {
    final db = await database;
    return await db.query('light_solutions');
  }

  Future<void> clearLightSolutions() async {
    final db = await database;
    await db.delete('light_solutions');
  }
}
