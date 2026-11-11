import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/vehicle_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

class VehicleService {
  final ApiClient? apiClient;
  final bool useMock;

  // In-memory mock cache for standalone frontend development
  static final List<VehicleModel> _mockVehicles = [];
  static bool _initialized = false;

  VehicleService({this.apiClient, this.useMock = true});

  Future<void> initMockData() async {
    if (_initialized && _mockVehicles.isNotEmpty) return;
    try {
      final jsonString = await rootBundle.loadString('assets/mock_data/vehicles_mock.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _mockVehicles.clear();
      _mockVehicles.addAll(jsonList.map((j) => VehicleModel.fromJson(j)));
      _initialized = true;
    } catch (_) {
      // Fallback default vehicles if mock asset is not loaded
      if (_mockVehicles.isEmpty) {
        _mockVehicles.addAll([
          VehicleModel(
            id: 1,
            vehicleNumber: 'DHAKA-METRO-GA-11-2233',
            company: 'Square Health',
            type: 'Ambulance',
            brand: 'Toyota',
            model: 'HiAce',
            status: 'ACTIVE',
          ),
          VehicleModel(
            id: 2,
            vehicleNumber: 'DHAKA-METRO-CHA-44-5566',
            company: 'Stark Logistics',
            type: 'Delivery Van',
            brand: 'Hyundai',
            model: 'Mighty',
            status: 'ACTIVE',
          ),
          VehicleModel(
            id: 3,
            vehicleNumber: 'DHAKA-METRO-BA-77-8899',
            company: 'Square Pharma',
            type: 'Microbus',
            brand: 'Toyota',
            model: 'Noah',
            status: 'MAINTENANCE',
          ),
        ]);
        _initialized = true;
      }
    }
  }

  Future<List<VehicleModel>> getVehicles() async {
    if (useMock) {
      await initMockData();
      return List.unmodifiable(_mockVehicles);
    } else {
      final data = await apiClient!.get(ApiConstants.vehiclesEndpoint);
      if (data is List) {
        return data.map((json) => VehicleModel.fromJson(json)).toList();
      }
      return [];
    }
  }

  Future<VehicleModel> createVehicle(VehicleModel vehicle) async {
    if (useMock) {
      await initMockData();
      final duplicate = _mockVehicles.any(
        (v) => v.vehicleNumber.trim().toUpperCase() == vehicle.vehicleNumber.trim().toUpperCase(),
      );
      if (duplicate) {
        throw ApiException(409, "Vehicle with number '${vehicle.vehicleNumber}' already exists.");
      }

      final newId = (_mockVehicles.isNotEmpty ? _mockVehicles.map((v) => v.id ?? 0).reduce((a, b) => a > b ? a : b) : 0) + 1;
      final newVehicle = vehicle.copyWith(id: newId);
      _mockVehicles.add(newVehicle);
      return newVehicle;
    } else {
      final response = await apiClient!.post(ApiConstants.vehiclesEndpoint, body: vehicle.toJson());
      return VehicleModel.fromJson(response);
    }
  }

  Future<VehicleModel> updateVehicle(int id, VehicleModel vehicle) async {
    if (useMock) {
      await initMockData();
      final index = _mockVehicles.indexWhere((v) => v.id == id);
      if (index == -1) {
        throw ApiException(404, "Vehicle not found with id: $id");
      }

      // Check if another vehicle has the same vehicle number
      final duplicate = _mockVehicles.any(
        (v) => v.id != id && v.vehicleNumber.trim().toUpperCase() == vehicle.vehicleNumber.trim().toUpperCase(),
      );
      if (duplicate) {
        throw ApiException(409, "Vehicle with number '${vehicle.vehicleNumber}' already exists.");
      }

      final updated = vehicle.copyWith(id: id);
      _mockVehicles[index] = updated;
      return updated;
    } else {
      final response = await apiClient!.put('${ApiConstants.vehiclesEndpoint}/$id', body: vehicle.toJson());
      return VehicleModel.fromJson(response);
    }
  }

  Future<void> deleteVehicle(int id) async {
    if (useMock) {
      await initMockData();
      final index = _mockVehicles.indexWhere((v) => v.id == id);
      if (index == -1) {
        throw ApiException(404, "Vehicle not found with id: $id");
      }
      _mockVehicles.removeAt(index);
    } else {
      await apiClient!.delete('${ApiConstants.vehiclesEndpoint}/$id');
    }
  }
}

