import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/plant_provider.dart';
import '../add_plant/add_plant_screen.dart';
import '../plant_details/plant_details_modal.dart';
import 'widgets/empty_plants_view.dart';
import 'widgets/plant_card.dart';

class PlantsListScreen extends ConsumerWidget {
  const PlantsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantsAsync = ref.watch(plantsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Plants'),
      ),
      body: plantsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (plants) {
          if (plants.isEmpty) return const EmptyPlantsView();
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index];
              return PlantCard(
                plant: plant,
                onTap: () => showPlantDetailsModal(context, ref, plant.id),
                onWater: () => ref.read(plantsProvider.notifier).waterPlant(plant.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddPlantScreen()),
        ),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.primaryText,
        child: const Icon(Icons.add),
      ),
    );
  }
}
