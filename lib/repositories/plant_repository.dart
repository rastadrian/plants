import 'package:sqflite/sqflite.dart';
import '../core/database/database_constants.dart';
import '../core/database/database_helper.dart';
import '../models/plant.dart';

class PlantRepository {
  PlantRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  Future<Database> get _db => _dbHelper.database;

  /// Returns all plants with their last watered date, sorted by name.
  /// Sorting by urgency is done in Dart after mapping.
  Future<List<Plant>> getAll() async {
    final db = await _db;
    final rows = await db.rawQuery('''
      SELECT p.*, MAX(w.${DbConstants.colWateredAt}) AS last_watered_at
      FROM ${DbConstants.plantsTable} p
      LEFT JOIN ${DbConstants.wateringTable} w ON w.${DbConstants.colPlantId} = p.${DbConstants.colId}
      GROUP BY p.${DbConstants.colId}
      ORDER BY p.${DbConstants.colName} ASC
    ''');
    return rows.map(Plant.fromMap).toList();
  }

  Future<Plant?> getById(String id) async {
    final db = await _db;
    final rows = await db.rawQuery('''
      SELECT p.*, MAX(w.${DbConstants.colWateredAt}) AS last_watered_at
      FROM ${DbConstants.plantsTable} p
      LEFT JOIN ${DbConstants.wateringTable} w ON w.${DbConstants.colPlantId} = p.${DbConstants.colId}
      WHERE p.${DbConstants.colId} = ?
      GROUP BY p.${DbConstants.colId}
    ''', [id]);
    if (rows.isEmpty) return null;
    return Plant.fromMap(rows.first);
  }

  Future<void> insert(Plant plant) async {
    final db = await _db;
    await db.insert(DbConstants.plantsTable, plant.toMap());
  }

  Future<void> update(Plant plant) async {
    final db = await _db;
    await db.update(
      DbConstants.plantsTable,
      plant.toMap(),
      where: '${DbConstants.colId} = ?',
      whereArgs: [plant.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete(
      DbConstants.plantsTable,
      where: '${DbConstants.colId} = ?',
      whereArgs: [id],
    );
  }
}
