import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper._internal();

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'customer_database.db');

    // Create the database
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE Customer (
        id INTEGER PRIMARY KEY,
        dealer TEXT,
        clientName TEXT,
        clientAddress TEXT,
        clientContact TEXT
      )
    ''');
  }

  Future<int> insertCustomer(Map<String, dynamic> row) async {
    Database? dbClient = await db;
    return await dbClient!.insert('Customer', row);
  }

  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    Database? dbClient = await db;
    return await dbClient!.query('Customer');
  }

  Future<void> clearAllCustomers() async {
    Database? dbClient = await db;
    await dbClient!.delete('Customer');
  }
}
