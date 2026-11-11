import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../data/vehicle_model.dart';
import '../services/vehicle_service.dart';
import '../../../shared/widgets/status_badge.dart';
import 'vehicle_form_dialog.dart';

class VehicleListScreen extends StatefulWidget {
  final VehicleService? vehicleService;

  const VehicleListScreen({super.key, this.vehicleService});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  late final VehicleService _vehicleService;
  List<VehicleModel> _vehicles = [];
  bool _isLoading = true;
  String _selectedFilter = 'ALL';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filterTabs = ['ALL', 'AVAILABLE', 'IN_TRIP', 'MAINTENANCE'];

  @override
  void initState() {
    super.initState();
    _vehicleService = widget.vehicleService ?? VehicleService();
    _loadVehicles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadVehicles() async {
    setState(() => _isLoading = true);
    try {
      final list = await _vehicleService.getVehicles(
        status: _selectedFilter == 'ALL' ? null : _selectedFilter,
        search: _searchQuery.isEmpty ? null : _searchQuery,
      );
      if (mounted) {
        setState(() {
          _vehicles = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackbar('Failed to load fleet vehicles: $e', isError: true);
      }
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.dangerRed : AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _openVehicleForm([VehicleModel? vehicle]) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => VehicleFormDialog(
        vehicle: vehicle,
        vehicleService: _vehicleService,
      ),
    );

    if (result == true) {
      _loadVehicles();
      _showSnackbar(
        vehicle == null
            ? 'Vehicle registered successfully.'
            : 'Vehicle updated successfully.',
      );
    }
  }

  Future<void> _confirmDelete(VehicleModel vehicle) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: AppColors.dangerRed),
            SizedBox(width: 8),
            Text('Confirm De-registration'),
          ],
        ),
        content: Text(
          'Are you sure you want to remove vehicle "${vehicle.vehicleNumber}" (${vehicle.company}) from the active fleet registry?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.dangerRed),
            child: const Text('Delete Vehicle', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true && vehicle.id != null) {
      try {
        await _vehicleService.deleteVehicle(vehicle.id!);
        _loadVehicles();
        _showSnackbar('Vehicle removed from fleet registry.');
      } catch (e) {
        _showSnackbar('Failed to delete vehicle: $e', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundLight,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Fleet Vehicle Registry',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage corporate transport, ambulances, logistics vans and executive sedans.',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _loadVehicles,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Refresh'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => _openVehicleForm(),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Register Vehicle'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.corporateBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Filter & Search Controls
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.borderSubtle),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Search Bar
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          _searchQuery = val;
                          _loadVehicles();
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by license plate, company, brand, or model...',
                          prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    _searchQuery = '';
                                    _loadVehicles();
                                  },
                                )
                              : null,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.borderSubtle),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.borderSubtle),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Filter Tabs
                    Wrap(
                      spacing: 8,
                      children: _filterTabs.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return ChoiceChip(
                          label: Text(
                            filter == 'ALL' ? 'All Statuses' : filter.replaceAll('_', ' '),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColors.corporateBlue : AppColors.textSecondary,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.corporateBlue.withOpacity(0.12),
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: isSelected ? AppColors.corporateBlue : AppColors.borderSubtle,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedFilter = filter);
                              _loadVehicles();
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Vehicles Table / Card View
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _vehicles.isEmpty
                      ? _buildEmptyState()
                      : _buildVehicleTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car_outlined, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'No fleet vehicles match your criteria.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try clearing your search query or selecting a different status filter.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
              _searchQuery = '';
              _selectedFilter = 'ALL';
              _loadVehicles();
            },
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Reset Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.corporateBlue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleTable() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ListView.separated(
          itemCount: _vehicles.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderSubtle),
          itemBuilder: (context, index) {
            final vehicle = _vehicles[index];
            IconData icon = Icons.directions_car;
            if (vehicle.type.toLowerCase().contains('ambulance')) {
              icon = Icons.medical_services_outlined;
            } else if (vehicle.type.toLowerCase().contains('van') || vehicle.type.toLowerCase().contains('truck')) {
              icon = Icons.local_shipping_outlined;
            } else if (vehicle.type.toLowerCase().contains('bus')) {
              icon = Icons.airport_shuttle_outlined;
            }

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.corporateBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.corporateBlue, size: 24),
              ),
              title: Row(
                children: [
                  Text(
                    vehicle.vehicleNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  StatusBadge(status: vehicle.status),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Text(
                      vehicle.company,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Text(' • ', style: TextStyle(color: AppColors.textSecondary)),
                    Text(
                      '${vehicle.brand} ${vehicle.model}',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const Text(' • ', style: TextStyle(color: AppColors.textSecondary)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.borderSubtle.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        vehicle.type,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Edit Vehicle',
                    icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textSecondary),
                    onPressed: () => _openVehicleForm(vehicle),
                  ),
                  IconButton(
                    tooltip: 'Remove from Fleet',
                    icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.dangerRed),
                    onPressed: () => _confirmDelete(vehicle),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
