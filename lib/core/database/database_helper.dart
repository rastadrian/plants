import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'database_constants.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, DbConstants.dbName);
    return openDatabase(
      path,
      version: DbConstants.dbVersion,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DbConstants.plantsTable} (
        ${DbConstants.colId} TEXT PRIMARY KEY,
        ${DbConstants.colName} TEXT NOT NULL,
        ${DbConstants.colPhotoPath} TEXT,
        ${DbConstants.colWateringIntervalDays} INTEGER NOT NULL,
        ${DbConstants.colCreatedAt} INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.wateringTable} (
        ${DbConstants.colId} TEXT PRIMARY KEY,
        ${DbConstants.colPlantId} TEXT NOT NULL,
        ${DbConstants.colWateredAt} INTEGER NOT NULL,
        FOREIGN KEY (${DbConstants.colPlantId})
          REFERENCES ${DbConstants.plantsTable}(${DbConstants.colId})
          ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_watering_plant_date
        ON ${DbConstants.wateringTable}(${DbConstants.colPlantId}, ${DbConstants.colWateredAt} DESC)
    ''');
  }

  /// Exposed so tests can inject an in-process database.
  void setDatabaseForTesting(Database db) => _db = db;
}
