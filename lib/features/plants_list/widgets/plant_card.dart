import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../models/plant.dart';

class PlantCard extends StatelessWidget {
  const PlantCard({
    super.key,
    required this.plant,
    required this.onTap,
    required this.onWater,
  });

  final Plant plant;
  final VoidCallback onTap;
  final VoidCallback onWater;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _PlantAvatar(photoPath: plant.photoPath, name: plant.name),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatLastWatered(plant.lastWateredAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 2),
                    _NextWateringBadge(days: plant.daysUntilNextWatering),
                  ],
                ),
              ),
              if (plant.needsWatering)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FilledButton.icon(
                    onPressed: onWater,
                    icon: const Icon(Icons.water_drop, size: 16),
                    label: const Text('Water'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.primaryText,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlantAvatar extends StatelessWidget {
  const _PlantAvatar({required this.photoPath, required this.name});

  final String? photoPath;
  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: 30,
      backgroundColor: AppColors.lightPrimary,
      backgroundImage: photoPath != null ? FileImage(File(photoPath!)) : null,
      child: photoPath == null
          ? Text(
              initials,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPrimary,
              ),
            )
          : null,
    );
  }
}

class _NextWateringBadge extends StatelessWidget {
  const _NextWateringBadge({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final label = days <= 0 ? 'Water now' : formatDaysUntil(days);
    final color = days <= 0 ? AppColors.accent : AppColors.secondaryText;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.schedule, size: 12, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: days <= 0 ? FontWeight.w600 : FontWeight.normal,
              ),
        ),
      ],
    );
  }
}
