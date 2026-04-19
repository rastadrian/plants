import 'package:sqflite/sqflite.dart';
import '../core/database/database_constants.dart';
import '../core/database/database_helper.dart';
import '../models/watering_entry.dart';

class WateringRepository {
  WateringRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  Future<Database> get _db => _dbHelper.database;

  Future<List<WateringEntry>> getForPlant(String plantId) async {
    final db = await _db;
    final rows = await db.query(
      DbConstants.wateringTable,
      where: '${DbConstants.colPlantId} = ?',
      whereArgs: [plantId],
      orderBy: '${DbConstants.colWateredAt} DESC',
    );
    return rows.map(WateringEntry.fromMap).toList();
  }

  Future<void> insert(WateringEntry entry) async {
    final db = await _db;
    await db.insert(DbConstants.wateringTable, entry.toMap());
  }

  Future<void> deleteForPlant(String plantId) async {
    final db = await _db;
    await db.delete(
      DbConstants.wateringTable,
      where: '${DbConstants.colPlantId} = ?',
      whereArgs: [plantId],
    );
  }
}
