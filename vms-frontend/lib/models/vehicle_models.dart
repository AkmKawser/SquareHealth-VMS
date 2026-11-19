enum VehicleType {
  car('CAR', 'Car'),
  suv('SUV', 'SUV'),
  van('VAN', 'Van'),
  microbus('MICROBUS', 'Microbus'),
  bus('BUS', 'Bus'),
  truck('TRUCK', 'Truck'),
  pickup('PICKUP', 'Pickup'),
  motorcycle('MOTORCYCLE', 'Motorcycle'),
  ambulance('AMBULANCE', 'Ambulance');

  const VehicleType(this.apiValue, this.label);
  final String apiValue;
  final String label;

  static VehicleType fromApi(String? value) {
    return VehicleType.values.firstWhere(
      (e) => e.apiValue == value?.toUpperCase(),
      orElse: () => VehicleType.car,
    );
  }
}

enum FuelType {
  petrol('PETROL', 'Petrol'),
  diesel('DIESEL', 'Diesel'),
  octane('OCTANE', 'Octane'),
  cng('CNG', 'CNG'),
  lpg('LPG', 'LPG'),
  hybrid('HYBRID', 'Hybrid'),
  electric('ELECTRIC', 'Electric');

  const FuelType(this.apiValue, this.label);
  final String apiValue;
  final String label;

  static FuelType fromApi(String? value) {
    return FuelType.values.firstWhere(
      (e) => e.apiValue == value?.toUpperCase(),
      orElse: () => FuelType.petrol,
    );
  }
}

enum VehicleStatus {
  available('AVAILABLE', 'Available'),
  active('ACTIVE', 'Active'),
  inUse('IN_USE', 'In Use'),
  maintenance('MAINTENANCE', 'Maintenance'),
  inactive('INACTIVE', 'Inactive'),
  retired('RETIRED', 'Retired');

  const VehicleStatus(this.apiValue, this.label);
  final String apiValue;
  final String label;

  static VehicleStatus fromApi(String? value) {
    return VehicleStatus.values.firstWhere(
      (e) => e.apiValue == value?.toUpperCase(),
      orElse: () => VehicleStatus.available,
    );
  }
}

enum ExpiryStatus {
  valid('VALID', 'Valid'),
  expiringSoon('EXPIRING_SOON', 'Expiring Soon'),
  expired('EXPIRED', 'Expired');

  const ExpiryStatus(this.apiValue, this.label);
  final String apiValue;
  final String label;

  static ExpiryStatus fromApi(String? value) {
    return ExpiryStatus.values.firstWhere(
      (e) => e.apiValue == value?.toUpperCase(),
      orElse: () => ExpiryStatus.valid,
    );
  }
}

class Vehicle {
  const Vehicle({
    this.id,
    required this.vehicleNumber,
    required this.company,
    required this.vehicleType,
    required this.brand,
    required this.model,
    this.manufacturingYear,
    this.color,
    this.seatingCapacity,
    required this.fuelType,
    this.status = VehicleStatus.available,
    this.dailyRate,
    this.fuelLevel = 100,
    this.odometerKm = 0,
    this.department,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.complianceStatus = ExpiryStatus.valid,
    this.createdAt,
  });

  final int? id;
  final String vehicleNumber;
  final String company;
  final VehicleType vehicleType;
  final String brand;
  final String model;
  final int? manufacturingYear;
  final String? color;
  final int? seatingCapacity;
  final FuelType fuelType;
  final VehicleStatus status;
  final double? dailyRate;
  final int fuelLevel;
  final int odometerKm;
  final String? department;
  final int? driverId;
  final String? driverName;
  final String? driverPhone;
  final ExpiryStatus complianceStatus;
  final String? createdAt;

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: (json['id'] as num?)?.toInt(),
      vehicleNumber: json['vehicleNumber'] as String? ?? '',
      company: json['company'] as String? ?? 'Stark Group',
      vehicleType: VehicleType.fromApi(json['vehicleType'] as String?),
      brand: json['brand'] as String? ?? '',
      model: json['model'] as String? ?? '',
      manufacturingYear: (json['manufacturingYear'] as num?)?.toInt(),
      color: json['color'] as String?,
      seatingCapacity: (json['seatingCapacity'] as num?)?.toInt(),
      fuelType: FuelType.fromApi(json['fuelType'] as String?),
      status: VehicleStatus.fromApi(json['status'] as String?),
      dailyRate: (json['dailyRate'] as num?)?.toDouble(),
      fuelLevel: (json['fuelLevel'] as num?)?.toInt() ?? 100,
      odometerKm: (json['odometerKm'] as num?)?.toInt() ?? 0,
      department: json['department'] as String?,
      driverId: (json['driverId'] as num?)?.toInt(),
      driverName: json['driverName'] as String?,
      driverPhone: json['driverPhone'] as String?,
      complianceStatus: ExpiryStatus.fromApi(json['complianceStatus'] as String?),
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleNumber': vehicleNumber,
      'company': company,
      'vehicleType': vehicleType.apiValue,
      'brand': brand,
      'model': model,
      if (manufacturingYear != null) 'manufacturingYear': manufacturingYear,
      if (color != null && color!.isNotEmpty) 'color': color,
      if (seatingCapacity != null) 'seatingCapacity': seatingCapacity,
      'fuelType': fuelType.apiValue,
      'status': status.apiValue,
      if (dailyRate != null) 'dailyRate': dailyRate,
      'fuelLevel': fuelLevel,
      'odometerKm': odometerKm,
      if (department != null && department!.isNotEmpty) 'department': department,
      if (driverId != null) 'driverId': driverId,
      if (driverName != null && driverName!.isNotEmpty) 'driverName': driverName,
      if (driverPhone != null && driverPhone!.isNotEmpty) 'driverPhone': driverPhone,
    };
  }
}

class PagedResponse<T> {
  const PagedResponse({
    required this.content,
    required this.page,
    required this.size,
    required this.hasNext,
    required this.totalElements,
    required this.totalPages,
  });

  final List<T> content;
  final int page;
  final int size;
  final bool hasNext;
  final int totalElements;
  final int totalPages;

  factory PagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromItemJson,
  ) {
    final rawList = (json['content'] as List<dynamic>? ?? []);
    return PagedResponse<T>(
      content: rawList.map((e) => fromItemJson(e as Map<String, dynamic>)).toList(),
      page: (json['page'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt() ?? 10,
      hasNext: json['hasNext'] as bool? ?? false,
      totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }
}
