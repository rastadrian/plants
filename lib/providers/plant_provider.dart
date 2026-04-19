import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/storage/photo_storage.dart';
import '../models/plant.dart';
import '../models/watering_entry.dart';
import '../repositories/plant_repository.dart';
import '../repositories/watering_repository.dart';
import 'database_provider.dart';

const _uuid = Uuid();

class PlantsNotifier extends AsyncNotifier<List<Plant>> {
  PlantRepository get _plants => ref.read(plantRepositoryProvider);
  WateringRepository get _waterings => ref.read(wateringRepositoryProvider);

  @override
  Future<List<Plant>> build() async {
    final plants = await _plants.getAll();
    plants.sort(_byUrgencyThenName);
    return plants;
  }

  Future<void> addPlant({
    required String name,
    required int wateringIntervalDays,
    File? photo,
  }) async {
    final id = _uuid.v4();
    String? photoPath;
    if (photo != null) {
      photoPath = await PhotoStorage.instance.save(photo, id);
    }
    final plant = Plant(
      id: id,
      name: name,
      photoPath: photoPath,
      wateringIntervalDays: wateringIntervalDays,
      createdAt: DateTime.now(),
    );
    await _plants.insert(plant);
    ref.invalidateSelf();
  }

  Future<void> updatePlant({
    required String id,
    required String name,
    int? wateringIntervalDays,
    File? newPhoto,
    bool removePhoto = false,
  }) async {
    final existing = await _plants.getById(id);
    if (existing == null) return;

    String? photoPath = existing.photoPath;
    if (removePhoto) {
      await PhotoStorage.instance.delete(photoPath);
      photoPath = null;
    } else if (newPhoto != null) {
      await PhotoStorage.instance.delete(photoPath);
      photoPath = await PhotoStorage.instance.save(newPhoto, id);
    }

    await _plants.update(existing.copyWith(
      name: name,
      photoPath: photoPath,
      clearPhoto: removePhoto,
      wateringIntervalDays: wateringIntervalDays,
    ));
    ref.invalidateSelf();
  }

  Future<void> waterPlant(String plantId) async {
    final entry = WateringEntry(
      id: _uuid.v4(),
      plantId: plantId,
      wateredAt: DateTime.now(),
    );
    await _waterings.insert(entry);
    ref.invalidateSelf();
  }

  Future<void> deletePlant(String plantId) async {
    final plant = await _plants.getById(plantId);
    if (plant != null) {
      await PhotoStorage.instance.delete(plant.photoPath);
    }
    await _plants.delete(plantId);
    ref.invalidateSelf();
  }
}

int _byUrgencyThenName(Plant a, Plant b) {
  final cmp = a.daysUntilNextWatering.compareTo(b.daysUntilNextWatering);
  if (cmp != 0) return cmp;
  return a.name.compareTo(b.name);
}

final plantsProvider = AsyncNotifierProvider<PlantsNotifier, List<Plant>>(PlantsNotifier.new);
