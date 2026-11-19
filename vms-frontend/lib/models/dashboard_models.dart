class DashboardStats {
  const DashboardStats({
    required this.totalVehicles,
    required this.availableVehicles,
    required this.activeVehicles,
    required this.maintenanceVehicles,
    required this.inactiveVehicles,
    required this.totalDrivers,
    required this.expiringSoonDocuments,
    required this.expiredDocuments,
    required this.lowFuelAlerts,
    required this.totalMaintenanceCost,
    required this.readinessPercentage,
    required this.vehiclesByCompany,
    required this.vehiclesByStatus,
  });

  final int totalVehicles;
  final int availableVehicles;
  final int activeVehicles;
  final int maintenanceVehicles;
  final int inactiveVehicles;
  final int totalDrivers;
  final int expiringSoonDocuments;
  final int expiredDocuments;
  final int lowFuelAlerts;
  final double totalMaintenanceCost;
  final double readinessPercentage;
  final Map<String, int> vehiclesByCompany;
  final Map<String, int> vehiclesByStatus;

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    Map<String, int> parseMap(dynamic raw) {
      if (raw is! Map) return {};
      return raw.map((k, v) => MapEntry(k.toString(), (v as num).toInt()));
    }

    return DashboardStats(
      totalVehicles: (json['totalVehicles'] as num?)?.toInt() ?? 0,
      availableVehicles: (json['availableVehicles'] as num?)?.toInt() ?? 0,
      activeVehicles: (json['activeVehicles'] as num?)?.toInt() ?? 0,
      maintenanceVehicles: (json['maintenanceVehicles'] as num?)?.toInt() ?? 0,
      inactiveVehicles: (json['inactiveVehicles'] as num?)?.toInt() ?? 0,
      totalDrivers: (json['totalDrivers'] as num?)?.toInt() ?? 0,
      expiringSoonDocuments: (json['expiringSoonDocuments'] as num?)?.toInt() ?? 0,
      expiredDocuments: (json['expiredDocuments'] as num?)?.toInt() ?? 0,
      lowFuelAlerts: (json['lowFuelAlerts'] as num?)?.toInt() ?? 0,
      totalMaintenanceCost: (json['totalMaintenanceCost'] as num?)?.toDouble() ?? 0.0,
      readinessPercentage: (json['readinessPercentage'] as num?)?.toDouble() ?? 0.0,
      vehiclesByCompany: parseMap(json['vehiclesByCompany']),
      vehiclesByStatus: parseMap(json['vehiclesByStatus']),
    );
  }
}
