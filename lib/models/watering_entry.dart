import '../core/database/database_constants.dart';

class WateringEntry {
  const WateringEntry({
    required this.id,
    required this.plantId,
    required this.wateredAt,
  });

  final String id;
  final String plantId;
  final DateTime wateredAt;

  Map<String, dynamic> toMap() => {
        DbConstants.colId: id,
        DbConstants.colPlantId: plantId,
        DbConstants.colWateredAt: wateredAt.millisecondsSinceEpoch,
      };

  factory WateringEntry.fromMap(Map<String, dynamic> map) => WateringEntry(
        id: map[DbConstants.colId] as String,
        plantId: map[DbConstants.colPlantId] as String,
        wateredAt: DateTime.fromMillisecondsSinceEpoch(map[DbConstants.colWateredAt] as int),
      );
}
