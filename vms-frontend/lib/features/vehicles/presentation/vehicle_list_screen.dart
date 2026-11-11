import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../data/vehicle_model.dart';
import '../../../shared/widgets/status_badge.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final List<VehicleModel> _vehicles = [
    VehicleModel(
      id: 1,
      vehicleNumber: 'DHAKA-METRO-GA-11-2233',
      company: 'Square Health',
      type: 'Ambulance',
      brand: 'Toyota',
      model: 'HiAce',
      status: 'ACTIVE',
    ),
    VehicleModel(
      id: 2,
      vehicleNumber: 'DHAKA-METRO-CHA-44-5566',
      company: 'Stark Logistics',
      type: 'Delivery Van',
      brand: 'Hyundai',
      model: 'Mighty',
      status: 'ACTIVE',
    ),
    VehicleModel(
      id: 3,
      vehicleNumber: 'DHAKA-METRO-BA-77-8899',
      company: 'Square Pharma',
      type: 'Microbus',
      brand: 'Toyota',
      model: 'Noah',
      status: 'MAINTENANCE',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        title: const Text('Square Health VMS - Fleet Management', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Vehicles',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Register Vehicle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.corporateBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: ListView.separated(
                  itemCount: _vehicles.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderSubtle),
                  itemBuilder: (context, index) {
                    final vehicle = _vehicles[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.backgroundLight,
                        child: Icon(Icons.directions_car, color: AppColors.corporateBlue),
                      ),
                      title: Text(
                        vehicle.vehicleNumber,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      subtitle: Text('${vehicle.company} • ${vehicle.brand} ${vehicle.model} (${vehicle.type})'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StatusBadge(status: vehicle.status),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.dangerRed),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

