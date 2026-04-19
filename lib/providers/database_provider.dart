import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/database/database_helper.dart';
import '../repositories/plant_repository.dart';
import '../repositories/watering_repository.dart';

final databaseHelperProvider = Provider<DatabaseHelper>((_) => DatabaseHelper.instance);

final plantRepositoryProvider = Provider<PlantRepository>((ref) {
  return PlantRepository(dbHelper: ref.watch(databaseHelperProvider));
});

final wateringRepositoryProvider = Provider<WateringRepository>((ref) {
  return WateringRepository(dbHelper: ref.watch(databaseHelperProvider));
});
