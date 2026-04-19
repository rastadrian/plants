import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class IntervalPicker extends StatelessWidget {
  const IntervalPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value; // weeks
  final ValueChanged<int> onChanged;

  static const int _minWeeks = 1;
  static const int _maxWeeks = 12;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Watering interval',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.secondaryText,
                fontSize: 12,
              ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            IconButton(
              onPressed: value > _minWeeks ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.primary,
            ),
            Expanded(
              child: Center(
                child: Text(
                  '$value ${value == 1 ? 'week' : 'weeks'}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            IconButton(
              onPressed: value < _maxWeeks ? () => onChanged(value + 1) : null,
              icon: const Icon(Icons.add_circle_outline),
              color: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }
}
