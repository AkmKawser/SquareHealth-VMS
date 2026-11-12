import 'package:flutter_test/flutter_test.dart';
import 'package:vms_frontend/features/vehicles/data/vehicle_model.dart';

void main() {
  group('VehicleModel Unit Tests', () {
    final sampleJson = {
      'id': 1,
      'vehicleNumber': 'DHA-GA-11-2045',
      'company': 'Square Health',
      'type': 'Ambulance',
      'brand': 'Toyota',
      'model': 'HiAce Emergency ICU',
      'status': 'AVAILABLE',
    };

    test('Should deserialize from JSON correctly', () {
      final vehicle = VehicleModel.fromJson(sampleJson);

      expect(vehicle.id, 1);
      expect(vehicle.vehicleNumber, 'DHA-GA-11-2045');
      expect(vehicle.company, 'Square Health');
      expect(vehicle.type, 'Ambulance');
      expect(vehicle.brand, 'Toyota');
      expect(vehicle.model, 'HiAce Emergency ICU');
      expect(vehicle.status, 'AVAILABLE');
    });

    test('Should serialize to JSON correctly', () {
      final vehicle = VehicleModel(
        id: 2,
        vehicleNumber: 'DHA-MET-54-8890',
        company: 'Stark Group Logistics',
        type: 'Logistics Van',
        brand: 'Isuzu',
        model: 'Cold Chain Reefer',
        status: 'IN_TRIP',
      );

      final json = vehicle.toJson();

      expect(json['id'], 2);
      expect(json['vehicleNumber'], 'DHA-MET-54-8890');
      expect(json['company'], 'Stark Group Logistics');
      expect(json['status'], 'IN_TRIP');
    });

    test('copyWith creates modified clone correctly', () {
      final vehicle = VehicleModel.fromJson(sampleJson);
      final updated = vehicle.copyWith(status: 'MAINTENANCE');

      expect(updated.id, 1);
      expect(updated.vehicleNumber, 'DHA-GA-11-2045');
      expect(updated.status, 'MAINTENANCE');
    });
  });
}

