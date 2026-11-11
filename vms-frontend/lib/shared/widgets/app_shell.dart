import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final String title;

  const AppShell({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: AppColors.primaryNavy,
            selectedIndex: 0,
            onDestinationSelected: (int index) {},
            labelType: NavigationRailLabelType.all,
            unselectedLabelTextStyle: const TextStyle(color: Colors.white70),
            selectedLabelTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            unselectedIconTheme: const IconThemeData(color: Colors.white70),
            selectedIconTheme: const IconThemeData(color: AppColors.corporateBlue),
            destinations: const [
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
                icon: Icon(Icons.description_outlined),
                selectedIcon: Icon(Icons.description),
                label: Text('Documents'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text('Drivers'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: AppColors.borderSubtle),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.corporateBlue,
                        child: Text('AD', style: TextStyle(color: Colors.white, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

