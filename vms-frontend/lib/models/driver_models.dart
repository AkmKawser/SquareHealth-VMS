class Driver {
  const Driver({
    this.id,
    this.nationalId,
    required this.fullName,
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.phone,
    this.emergencyContact,
    this.medicalCleared = true,
    this.active = true,
    this.eligible = true,
  });

  final int? id;
  final String? nationalId;
  final String fullName;
  final String licenseNumber;
  final String licenseExpiryDate;
  final String phone;
  final String? emergencyContact;
  final bool medicalCleared;
  final bool active;
  final bool eligible;

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: (json['id'] as num?)?.toInt(),
      nationalId: json['nationalId'] as String?,
      fullName: json['fullName'] as String? ?? '',
      licenseNumber: json['licenseNumber'] as String? ?? '',
      licenseExpiryDate: json['licenseExpiryDate'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      emergencyContact: json['emergencyContact'] as String?,
      medicalCleared: json['medicalCleared'] as bool? ?? true,
      active: json['active'] as bool? ?? true,
      eligible: json['eligible'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (nationalId != null && nationalId!.isNotEmpty) 'nationalId': nationalId,
      'fullName': fullName,
      'licenseNumber': licenseNumber,
      'licenseExpiryDate': licenseExpiryDate,
      'phone': phone,
      if (emergencyContact != null && emergencyContact!.isNotEmpty)
        'emergencyContact': emergencyContact,
      'medicalCleared': medicalCleared,
      'active': active,
    };
  }
}
