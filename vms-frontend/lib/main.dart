import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/vehicles/presentation/vehicle_list_screen.dart';
import 'features/vehicles/services/vehicle_service.dart';
import 'shared/widgets/app_shell.dart';

void main() {
  runApp(const VmsApp());
}

class VmsApp extends StatefulWidget {
  const VmsApp({super.key});

  @override
  State<VmsApp> createState() => _VmsAppState();
}

class _VmsAppState extends State<VmsApp> {
  final VehicleService _vehicleService = VehicleService(useMock: false);
  bool _isAuthenticated = true; // Default true for direct prototype inspection, toggleable
  int _currentTabIndex = 0;

  final List<String> _tabTitles = [
    'Executive Dashboard',
    'Fleet Vehicle Registry',
    'Maintenance Schedules',
    'Certified Drivers Registry',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Square Health VMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _isAuthenticated
          ? AppShell(
              title: _tabTitles[_currentTabIndex],
              selectedIndex: _currentTabIndex,
              onTabSelected: (index) {
                setState(() => _currentTabIndex = index);
              },
              onLogout: () {
                setState(() => _isAuthenticated = false);
              },
              child: _buildCurrentTab(),
            )
          : LoginScreen(
              onLoginSuccess: () {
                setState(() {
                  _isAuthenticated = true;
                  _currentTabIndex = 0;
                });
              },
            ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentTabIndex) {
      case 0:
        return DashboardScreen(
          vehicleService: _vehicleService,
          onNavigateToVehicles: () {
            setState(() => _currentTabIndex = 1);
          },
        );
      case 1:
        return VehicleListScreen(
          vehicleService: _vehicleService,
        );
      case 2:
        return _buildPlaceholderScreen(
          icon: Icons.build_outlined,
          title: 'Scheduled Maintenance & Servicing',
          subtitle: 'Scheduled oil changes, brake inspections, and workshop logs (Step 4+).',
        );
      case 3:
        return _buildPlaceholderScreen(
          icon: Icons.badge_outlined,
          title: 'Fleet Driver Registry',
          subtitle: 'License validation, shift logs, and driver allocation (Step 4+).',
        );
      default:
        return VehicleListScreen(vehicleService: _vehicleService);
    }
  }

  Widget _buildPlaceholderScreen({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      color: AppColors.backgroundLight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, size: 48, color: AppColors.corporateBlue),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
