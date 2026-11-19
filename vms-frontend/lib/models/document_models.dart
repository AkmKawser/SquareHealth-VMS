import 'vehicle_models.dart';

enum DocumentType {
  registration('REGISTRATION', 'Registration'),
  taxToken('TAX_TOKEN', 'Tax Token'),
  insurance('INSURANCE', 'Insurance'),
  fitness('FITNESS', 'Fitness'),
  routePermit('ROUTE_PERMIT', 'Route Permit'),
  vehiclePhoto('VEHICLE_PHOTO', 'Vehicle Photo');

  const DocumentType(this.apiValue, this.label);
  final String apiValue;
  final String label;

  static DocumentType fromApi(String? value) {
    return DocumentType.values.firstWhere(
      (e) => e.apiValue == value?.toUpperCase(),
      orElse: () => DocumentType.registration,
    );
  }
}

class VehicleDocument {
  const VehicleDocument({
    required this.id,
    required this.vehicleId,
    required this.documentType,
    required this.fileName,
    this.contentType,
    this.fileSize,
    required this.downloadUrl,
    this.expiryDate,
    required this.expiryStatus,
    this.uploadedAt,
  });

  final int id;
  final int vehicleId;
  final DocumentType documentType;
  final String fileName;
  final String? contentType;
  final int? fileSize;
  final String downloadUrl;
  final String? expiryDate;
  final ExpiryStatus expiryStatus;
  final String? uploadedAt;

  factory VehicleDocument.fromJson(Map<String, dynamic> json) {
    return VehicleDocument(
      id: (json['id'] as num).toInt(),
      vehicleId: (json['vehicleId'] as num).toInt(),
      documentType: DocumentType.fromApi(json['documentType'] as String?),
      fileName: json['fileName'] as String? ?? '',
      contentType: json['contentType'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      downloadUrl: json['downloadUrl'] as String? ?? '',
      expiryDate: json['expiryDate'] as String?,
      expiryStatus: ExpiryStatus.fromApi(json['expiryStatus'] as String?),
      uploadedAt: json['uploadedAt'] as String?,
    );
  }
}
