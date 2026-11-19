import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_theme.dart';
import '../providers/fleet_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(dashboardStatsProvider),
      child: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error loading dashboard: $err'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(dashboardStatsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (stats) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Executive Fleet Overview',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  tooltip: 'Refresh Stats',
                  icon: const Icon(Icons.refresh),
                  onPressed: () => ref.invalidate(dashboardStatsProvider),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _KpiCard('Total Vehicles', '${stats.totalVehicles}', Icons.directions_car, AppTheme.electricBlue),
                _KpiCard('Available', '${stats.availableVehicles}', Icons.check_circle_outline, AppTheme.emerald),
                _KpiCard('Active / In Use', '${stats.activeVehicles}', Icons.local_shipping_outlined, Colors.indigo),
                _KpiCard('Maintenance', '${stats.maintenanceVehicles}', Icons.build_outlined, AppTheme.amber),
                _KpiCard('Inactive', '${stats.inactiveVehicles}', Icons.pause_circle_outline, Colors.blueGrey),
                _KpiCard('Drivers', '${stats.totalDrivers}', Icons.badge_outlined, Colors.teal),
                _KpiCard('Expiring / Expired Docs', '${stats.expiringSoonDocuments + stats.expiredDocuments}', Icons.warning_amber_rounded, AppTheme.crimson),
                _KpiCard('Maintenance Cost', '৳${stats.totalMaintenanceCost.toStringAsFixed(0)}', Icons.payments_outlined, Colors.deepPurple),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Fleet Readiness Ratio',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${stats.readinessPercentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.emerald,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (stats.readinessPercentage / 100).clamp(0.0, 1.0),
                        minHeight: 12,
                        backgroundColor: const Color(0xFFE2E8F0),
                        color: AppTheme.emerald,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final cards = [
                  _BreakdownCard(
                    title: 'Fleet by Operating Company',
                    data: stats.vehiclesByCompany,
                    total: stats.totalVehicles,
                    barColor: AppTheme.electricBlue,
                  ),
                  _BreakdownCard(
                    title: 'Fleet by Status',
                    data: stats.vehiclesByStatus,
                    total: stats.totalVehicles,
                    barColor: AppTheme.emerald,
                  ),
                ];
                if (constraints.maxWidth >= 760) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: cards[0]),
                      const SizedBox(width: 16),
                      Expanded(child: cards[1]),
                    ],
                  );
                }
                return Column(
                  children: [cards[0], const SizedBox(height: 16), cards[1]],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard(this.label, this.value, this.icon, this.color);

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.12),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      label,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({
    required this.title,
    required this.data,
    required this.total,
    required this.barColor,
  });

  final String title;
  final Map<String, int> data;
  final int total;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            if (data.isEmpty)
              const Text('No data available', style: TextStyle(color: Colors.black54)),
            ...data.entries.map((e) {
              final ratio = total == 0 ? 0.0 : e.value / total;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key, style: const TextStyle(fontSize: 13)),
                        Text('${e.value}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio.clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: const Color(0xFFE2E8F0),
                        color: barColor,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
