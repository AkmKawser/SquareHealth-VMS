import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/vehicles/presentation/vehicle_list_screen.dart';

void main() {
  runApp(const VmsApp());
}

class VmsApp extends StatelessWidget {
  const VmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Square Health VMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const VehicleListScreen(),
    );
  }
}

