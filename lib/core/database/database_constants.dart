class DbConstants {
  DbConstants._();

  static const String dbName = 'plants.db';
  static const int dbVersion = 1;

  // plants table
  static const String plantsTable = 'plants';
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colPhotoPath = 'photo_path';
  static const String colWateringIntervalDays = 'watering_interval_days';
  static const String colCreatedAt = 'created_at';

  // watering_history table
  static const String wateringTable = 'watering_history';
  static const String colPlantId = 'plant_id';
  static const String colWateredAt = 'watered_at';
}
