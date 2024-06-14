import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'smart_lock.db');

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE smart_locks (
        id INTEGER PRIMARY KEY,
        doorType TEXT,
        fingerprint INTEGER,
        otp INTEGER,
        card INTEGER,
        keyLock INTEGER
      )
    ''');
  }

  Future<int> insertSmartLock(Map<String, dynamic> row) async {
    Database? db = await database;
    return await db!.insert('smart_locks', row);
  }

  Future<List<Map<String, dynamic>>> getSmartLocks() async {
    Database? db = await database;
    return await db!.query('smart_locks');
  }

  Future<void> clearSmartLocks() async {
    Database? db = await database;
    await db!.delete('smart_locks');
  }
}
