import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/plant_provider.dart';
import 'widgets/edit_plant_form.dart';
import 'widgets/watering_history_list.dart';

Future<void> showPlantDetailsModal(
    BuildContext context, WidgetRef ref, String plantId) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PlantDetailsSheet(plantId: plantId),
  );
}

class _PlantDetailsSheet extends ConsumerStatefulWidget {
  const _PlantDetailsSheet({required this.plantId});
  final String plantId;

  @override
  ConsumerState<_PlantDetailsSheet> createState() => _PlantDetailsSheetState();
}

class _PlantDetailsSheetState extends ConsumerState<_PlantDetailsSheet> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    final plantsAsync = ref.watch(plantsProvider);
    final plant = plantsAsync.valueOrNull
        ?.where((p) => p.id == widget.plantId)
        .firstOrNull;

    if (plant == null) {
      return const SizedBox.shrink();
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header row
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        plant.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _editing ? Icons.close : Icons.edit,
                        color: AppColors.primary,
                      ),
                      onPressed: () => setState(() => _editing = !_editing),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _confirmDelete(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    if (_editing) ...[
                      EditPlantForm(
                        plant: plant,
                        onDone: () => setState(() => _editing = false),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      'Watering history',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    WateringHistoryList(plantId: plant.id),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final navigator = Navigator.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete plant?'),
        content: const Text(
            'This will permanently remove the plant and all its watering history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(plantsProvider.notifier).deletePlant(widget.plantId);
      navigator.pop();
    }
  }
}
