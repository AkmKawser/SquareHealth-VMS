import 'package:flutter_test/flutter_test.dart';
import 'package:vms_frontend/features/vehicles/data/vehicle_model.dart';
import 'package:vms_frontend/features/vehicles/services/vehicle_service.dart';
import 'package:vms_frontend/core/network/api_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VehicleService Unit Tests (Mock Mode)', () {
    late VehicleService service;

    setUp(() {
      service = VehicleService(useMock: true);
    });

    test('Should return initial vehicles list', () async {
      final vehicles = await service.getVehicles();

      expect(vehicles, isNotEmpty);
      expect(vehicles.first.company, isNotEmpty);
    });

    test('Should filter vehicles by status', () async {
      final available = await service.getVehicles(status: 'AVAILABLE');

      expect(available, isNotEmpty);
      expect(available.every((v) => v.status == 'AVAILABLE'), isTrue);
    });

    test('Should create a new vehicle successfully', () async {
      final newVehicle = VehicleModel(
        vehicleNumber: 'CTG-METRO-KA-99-0011',
        company: 'Square Health',
        type: 'Ambulance',
        brand: 'Nissan',
        model: 'Urvan',
        status: 'AVAILABLE',
      );

      final created = await service.createVehicle(newVehicle);

      expect(created.id, isNotNull);
      expect(created.vehicleNumber, 'CTG-METRO-KA-99-0011');
    });

    test('Should throw ApiException on duplicate vehicle creation', () async {
      final duplicateVehicle = VehicleModel(
        vehicleNumber: 'DHA-GA-11-2045',
        company: 'Square Health',
        type: 'Ambulance',
        brand: 'Toyota',
        model: 'HiAce',
        status: 'AVAILABLE',
      );

      expect(
        () => service.createVehicle(duplicateVehicle),
        throwsA(isA<ApiException>()),
      );
    });

    test('Should calculate dashboard stats correctly', () async {
      final stats = await service.getDashboardStats();

      expect(stats.totalVehicles, greaterThan(0));
      expect(stats.availableVehicles, greaterThanOrEqualTo(0));
    });
  });
}
