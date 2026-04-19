import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/watering_entry.dart';
import 'database_provider.dart';

final wateringHistoryProvider =
    FutureProvider.family<List<WateringEntry>, String>((ref, plantId) async {
  final repo = ref.watch(wateringRepositoryProvider);
  return repo.getForPlant(plantId);
});
