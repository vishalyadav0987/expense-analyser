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

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
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

    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        category_id TEXT NOT NULL,
        amount REAL NOT NULL,
        description TEXT,
        payment_mode TEXT NOT NULL,
        date TEXT NOT NULL,
        created_at TEXT
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Agar user version 1 se aa raha hai, toh sirf nayi table bana do
      await db.execute('''
        CREATE TABLE transactions (
          id TEXT PRIMARY KEY,
          category_id TEXT NOT NULL,
          amount REAL NOT NULL,
          description TEXT,
          payment_mode TEXT NOT NULL,
          date TEXT NOT NULL,
          created_at TEXT
        )
      ''');
    }
  } // 🚨 YAHAN EK BRACKET MISSING THA! (Closes _upgradeDB)

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
