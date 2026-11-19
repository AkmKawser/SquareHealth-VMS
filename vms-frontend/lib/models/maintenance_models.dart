class MaintenanceLog {
  const MaintenanceLog({
    this.id,
    required this.vehicleId,
    required this.serviceDate,
    required this.maintenanceType,
    required this.serviceCost,
    required this.workshopVendor,
    this.notes,
    this.serviceOdometer,
    this.invoiceNumber,
  });

  final int? id;
  final int vehicleId;
  final String serviceDate;
  final String maintenanceType;
  final double serviceCost;
  final String workshopVendor;
  final String? notes;
  final int? serviceOdometer;
  final String? invoiceNumber;

  factory MaintenanceLog.fromJson(Map<String, dynamic> json) {
    return MaintenanceLog(
      id: (json['id'] as num?)?.toInt(),
      vehicleId: (json['vehicleId'] as num?)?.toInt() ?? 0,
      serviceDate: json['serviceDate'] as String? ?? '',
      maintenanceType: json['maintenanceType'] as String? ?? '',
      serviceCost: (json['serviceCost'] as num?)?.toDouble() ?? 0.0,
      workshopVendor: json['workshopVendor'] as String? ?? '',
      notes: json['notes'] as String?,
      serviceOdometer: (json['serviceOdometer'] as num?)?.toInt(),
      invoiceNumber: json['invoiceNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceDate': serviceDate,
      'maintenanceType': maintenanceType,
      'serviceCost': serviceCost,
      'workshopVendor': workshopVendor,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      if (serviceOdometer != null) 'serviceOdometer': serviceOdometer,
      if (invoiceNumber != null && invoiceNumber!.isNotEmpty) 'invoiceNumber': invoiceNumber,
    };
  }
}
