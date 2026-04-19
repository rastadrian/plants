import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class EmptyPlantsView extends StatelessWidget {
  final VoidCallback? onTap;

  const EmptyPlantsView({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
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
      ),
    );
  }
}
