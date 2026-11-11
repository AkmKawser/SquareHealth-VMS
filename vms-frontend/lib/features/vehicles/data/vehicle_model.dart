class VehicleModel {
  final int? id;
  final String vehicleNumber;
  final String company;
  final String type;
  final String brand;
  final String model;
  final String status;

  VehicleModel({
    this.id,
    required this.vehicleNumber,
    required this.company,
    required this.type,
    required this.brand,
    required this.model,
    required this.status,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as int?,
      vehicleNumber: json['vehicleNumber'] as String? ?? '',
      company: json['company'] as String? ?? '',
      type: json['type'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      model: json['model'] as String? ?? '',
      status: json['status'] as String? ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'vehicleNumber': vehicleNumber,
      'company': company,
      'type': type,
      'brand': brand,
      'model': model,
      'status': status,
    };
  }

  VehicleModel copyWith({
    int? id,
    String? vehicleNumber,
    String? company,
    String? type,
    String? brand,
    String? model,
    String? status,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      company: company ?? this.company,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      status: status ?? this.status,
    );
  }
}

