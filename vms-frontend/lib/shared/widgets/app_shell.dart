import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final String title;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback? onLogout;

  const AppShell({
    super.key,
    required this.child,
    required this.title,
    required this.selectedIndex,
    required this.onTabSelected,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navigation Sidebar Rail
          NavigationRail(
            backgroundColor: AppColors.primaryNavy,
            selectedIndex: selectedIndex,
            onDestinationSelected: onTabSelected,
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.corporateBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.local_shipping, color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'SH-VMS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white70),
                    tooltip: 'Sign Out',
                    onPressed: onLogout,
                  ),
                ),
              ),
            ),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white70, fontSize: 11),
            selectedLabelTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            unselectedIconTheme: const IconThemeData(color: Colors.white70, size: 22),
            selectedIconTheme: const IconThemeData(color: Colors.white, size: 24),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.directions_car_outlined),
                selectedIcon: Icon(Icons.directions_car),
                label: Text('Vehicles'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.build_outlined),
                selectedIcon: Icon(Icons.build),
                label: Text('Maintenance'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.badge_outlined),
                selectedIcon: Icon(Icons.badge),
                label: Text('Drivers'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: AppColors.borderSubtle),

          // Main View Area
          Expanded(
            child: Column(
              children: [
                // Top App Bar
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.corporateBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Enterprise Web v1.0 (Step 3 Prototype)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.corporateBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primaryNavy,
                            child: Text(
                              'FA',
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Fleet Administrator',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                              Text(
                                'Square Health Logistics HQ',
                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.logout, size: 20, color: AppColors.textSecondary),
                            tooltip: 'Sign Out',
                            onPressed: onLogout,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Screen Body
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
