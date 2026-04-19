import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class EmptyPlantsView extends StatelessWidget {
  const EmptyPlantsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_florist_outlined,
            size: 80,
            color: AppColors.lightPrimary,
          ),
          const SizedBox(height: 16),
          Text(
            'No plants yet',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first plant',
            style: Theme.of(context)
                .textTheme
                .bodySmall,
          ),
        ],
      ),
    );
  }
}
