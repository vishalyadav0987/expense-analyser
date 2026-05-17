import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense_analyser.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. User Profile Table (Using user_id as Primary Key)
    await db.execute('''
      CREATE TABLE user_profile (
        user_id TEXT PRIMARY KEY,
        monthly_salary REAL NOT NULL,
        yearly_hike REAL NOT NULL,
        xx_weekly_limit REAL NOT NULL,
        needs_pct INTEGER NOT NULL,
        wants_pct INTEGER NOT NULL,
        savings_pct INTEGER NOT NULL
      )
    ''');

    // 2. Categories Table (Using Backend ID as Primary Key)
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        name TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');

    // 3. Payment Methods Table (Using Backend ID as Primary Key)
    await db.execute('''
      CREATE TABLE payment_methods (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        method_name TEXT NOT NULL,
        weekly_limit REAL NOT NULL,
        is_active INTEGER NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
