import '../core/database/database_constants.dart';

class Plant {
  const Plant({
    required this.id,
    required this.name,
    this.photoPath,
    required this.wateringIntervalDays,
    required this.createdAt,
    this.lastWateredAt,
  });

  final String id;
  final String name;
  final String? photoPath;
  final int wateringIntervalDays;
  final DateTime createdAt;

  /// Populated via JOIN with watering_history; null if never watered.
  final DateTime? lastWateredAt;

  int get daysUntilNextWatering {
    if (lastWateredAt == null) return 0;
    final nextWatering = lastWateredAt!.add(Duration(days: wateringIntervalDays));
    final now = DateTime.now();
    return nextWatering.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  bool get needsWatering => daysUntilNextWatering <= 0;

  Plant copyWith({
    String? name,
    String? photoPath,
    bool clearPhoto = false,
    int? wateringIntervalDays,
    DateTime? lastWateredAt,
  }) {
    return Plant(
      id: id,
      name: name ?? this.name,
      photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
      wateringIntervalDays: wateringIntervalDays ?? this.wateringIntervalDays,
      createdAt: createdAt,
      lastWateredAt: lastWateredAt ?? this.lastWateredAt,
    );
  }

  Map<String, dynamic> toMap() => {
        DbConstants.colId: id,
        DbConstants.colName: name,
        DbConstants.colPhotoPath: photoPath,
        DbConstants.colWateringIntervalDays: wateringIntervalDays,
        DbConstants.colCreatedAt: createdAt.millisecondsSinceEpoch,
      };

  factory Plant.fromMap(Map<String, dynamic> map) => Plant(
        id: map[DbConstants.colId] as String,
        name: map[DbConstants.colName] as String,
        photoPath: map[DbConstants.colPhotoPath] as String?,
        wateringIntervalDays: map[DbConstants.colWateringIntervalDays] as int,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map[DbConstants.colCreatedAt] as int),
        lastWateredAt: map['last_watered_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['last_watered_at'] as int)
            : null,
      );
}
