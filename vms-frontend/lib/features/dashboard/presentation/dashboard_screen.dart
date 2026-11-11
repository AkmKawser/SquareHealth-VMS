import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../vehicles/services/vehicle_service.dart';

class DashboardScreen extends StatefulWidget {
  final VehicleService vehicleService;
  final VoidCallback? onNavigateToVehicles;

  const DashboardScreen({
    super.key,
    required this.vehicleService,
    this.onNavigateToVehicles,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardStats? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      final stats = await widget.vehicleService.getDashboardStats();
      if (mounted) {
        setState(() {
          _stats = stats;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundLight,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Operational Fleet Dashboard',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Real-time overview of fleet readiness, active logistics, and maintenance cycles.',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      OutlinedButton.icon(
                        onPressed: _loadStats,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Refresh Metrics'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // KPI Cards Grid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth > 900 ? 4 : 2;
                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: crossAxisCount == 4 ? 1.6 : 1.8,
                        children: [
                          _buildKpiCard(
                            title: 'Total Fleet',
                            count: _stats?.totalVehicles ?? 0,
                            subtitle: 'Registered vehicles',
                            icon: Icons.directions_car,
                            color: AppColors.primaryNavy,
                            bgColor: AppColors.primaryNavy.withOpacity(0.08),
                          ),
                          _buildKpiCard(
                            title: 'Available',
                            count: _stats?.availableVehicles ?? 0,
                            subtitle: 'Ready for dispatch',
                            icon: Icons.check_circle_outline,
                            color: AppColors.successGreen,
                            bgColor: AppColors.successGreen.withOpacity(0.08),
                          ),
                          _buildKpiCard(
                            title: 'In Trip',
                            count: _stats?.inTripVehicles ?? 0,
                            subtitle: 'Active logistics',
                            icon: Icons.near_me_outlined,
                            color: AppColors.corporateBlue,
                            bgColor: AppColors.corporateBlue.withOpacity(0.08),
                          ),
                          _buildKpiCard(
                            title: 'Maintenance',
                            count: _stats?.maintenanceVehicles ?? 0,
                            subtitle: 'Under workshop repair',
                            icon: Icons.build_circle_outlined,
                            color: AppColors.warningAmber,
                            bgColor: AppColors.warningAmber.withOpacity(0.1),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Secondary Metrics & Fleet Quick Actions
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fleet Utilization Panel
                      Expanded(
                        flex: 3,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: AppColors.borderSubtle),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Fleet Capacity & Utilization',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: widget.onNavigateToVehicles,
                                      icon: const Icon(Icons.arrow_forward, size: 16),
                                      label: const Text('Manage Fleet'),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24, color: AppColors.borderSubtle),
                                const SizedBox(height: 8),
                                _buildProgressBar(
                                  label: 'Readiness Rate',
                                  value: _stats != null && _stats!.totalVehicles > 0
                                      ? (_stats!.availableVehicles / _stats!.totalVehicles)
                                      : 0.0,
                                  color: AppColors.successGreen,
                                ),
                                const SizedBox(height: 16),
                                _buildProgressBar(
                                  label: 'In-Transit Utilization',
                                  value: _stats != null && _stats!.totalVehicles > 0
                                      ? (_stats!.inTripVehicles / _stats!.totalVehicles)
                                      : 0.0,
                                  color: AppColors.corporateBlue,
                                ),
                                const SizedBox(height: 16),
                                _buildProgressBar(
                                  label: 'Maintenance Ratio',
                                  value: _stats != null && _stats!.totalVehicles > 0
                                      ? (_stats!.maintenanceVehicles / _stats!.totalVehicles)
                                      : 0.0,
                                  color: AppColors.warningAmber,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Quick Operations Card
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: AppColors.borderSubtle),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fleet Operations',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const Divider(height: 24, color: AppColors.borderSubtle),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const CircleAvatar(
                                    backgroundColor: AppColors.backgroundLight,
                                    child: Icon(Icons.badge_outlined, color: AppColors.corporateBlue),
                                  ),
                                  title: const Text('Assigned Drivers', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  subtitle: Text('${_stats?.totalDrivers ?? 18} active certified operators'),
                                ),
                                const Divider(height: 16, color: AppColors.borderSubtle),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const CircleAvatar(
                                    backgroundColor: AppColors.backgroundLight,
                                    child: Icon(Icons.route_outlined, color: AppColors.successGreen),
                                  ),
                                  title: const Text('Active Dispatch Trips', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  subtitle: Text('${_stats?.activeTrips ?? 5} deliveries currently en route'),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: widget.onNavigateToVehicles,
                                    icon: const Icon(Icons.directions_car),
                                    label: const Text('View All Vehicles'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.corporateBlue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required int count,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            Text(
              '$count',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar({
    required String label,
    required double value,
    required Color color,
  }) {
    final pct = (value * 100).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            Text('$pct%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: AppColors.borderSubtle.withOpacity(0.4),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

