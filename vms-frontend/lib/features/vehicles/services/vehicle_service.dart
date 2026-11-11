import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/vehicle_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

class DashboardStats {
  final int totalVehicles;
  final int availableVehicles;
  final int inTripVehicles;
  final int maintenanceVehicles;
  final int totalDrivers;
  final int activeTrips;

  DashboardStats({
    required this.totalVehicles,
    required this.availableVehicles,
    required this.inTripVehicles,
    required this.maintenanceVehicles,
    this.totalDrivers = 18,
    this.activeTrips = 5,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalVehicles: json['totalVehicles'] as int? ?? 0,
      availableVehicles: json['availableVehicles'] as int? ?? 0,
      inTripVehicles: json['inTripVehicles'] as int? ?? 0,
      maintenanceVehicles: json['maintenanceVehicles'] as int? ?? 0,
      totalDrivers: json['totalDrivers'] as int? ?? 18,
      activeTrips: json['activeTrips'] as int? ?? 5,
    );
  }
}

class VehicleService {
  final ApiClient? apiClient;
  final bool useMock;

  // In-memory mock cache for standalone frontend development and prototyping
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
      // Fallback default vehicles if mock asset is not loaded in web environment
      if (_mockVehicles.isEmpty) {
        _mockVehicles.addAll([
          VehicleModel(
            id: 1,
            vehicleNumber: 'DHAKA-METRO-GA-11-2233',
            company: 'Square Health',
            type: 'Ambulance',
            brand: 'Toyota',
            model: 'HiAce',
            status: 'AVAILABLE',
          ),
          VehicleModel(
            id: 2,
            vehicleNumber: 'DHAKA-METRO-CHA-44-5566',
            company: 'Square Pharmaceuticals',
            type: 'Delivery Van',
            brand: 'Hyundai',
            model: 'Mighty',
            status: 'IN_TRIP',
          ),
          VehicleModel(
            id: 3,
            vehicleNumber: 'DHAKA-METRO-BA-77-8899',
            company: 'Square Hospitals',
            type: 'Microbus',
            brand: 'Toyota',
            model: 'Noah',
            status: 'MAINTENANCE',
          ),
          VehicleModel(
            id: 4,
            vehicleNumber: 'DHAKA-METRO-GHA-12-3456',
            company: 'Square Health',
            type: 'Ambulance',
            brand: 'Nissan',
            model: 'Caravan',
            status: 'AVAILABLE',
          ),
          VehicleModel(
            id: 5,
            vehicleNumber: 'DHAKA-METRO-DHA-98-7654',
            company: 'Square Textiles',
            type: 'Executive Sedan',
            brand: 'Honda',
            model: 'Civic',
            status: 'AVAILABLE',
          ),
          VehicleModel(
            id: 6,
            vehicleNumber: 'DHAKA-METRO-JA-55-6677',
            company: 'Square Pharmaceuticals',
            type: 'Delivery Van',
            brand: 'Isuzu',
            model: 'N-Series',
            status: 'IN_TRIP',
          ),
        ]);
        _initialized = true;
      }
    }
  }

  Future<List<VehicleModel>> getVehicles({String? status, String? search}) async {
    if (useMock) {
      await initMockData();
      var list = List<VehicleModel>.from(_mockVehicles);

      if (status != null && status.isNotEmpty && status.toUpperCase() != 'ALL') {
        list = list.where((v) => v.status.toUpperCase() == status.toUpperCase()).toList();
      }

      if (search != null && search.trim().isNotEmpty) {
        final query = search.trim().toLowerCase();
        list = list.where((v) =>
          v.vehicleNumber.toLowerCase().contains(query) ||
          v.company.toLowerCase().contains(query) ||
          v.brand.toLowerCase().contains(query) ||
          v.model.toLowerCase().contains(query) ||
          v.type.toLowerCase().contains(query)
        ).toList();
      }

      return List.unmodifiable(list);
    } else {
      String url = ApiConstants.vehiclesEndpoint;
      final params = <String>[];
      if (status != null && status.isNotEmpty && status.toUpperCase() != 'ALL') {
        params.add('status=${Uri.encodeComponent(status)}');
      }
      if (search != null && search.trim().isNotEmpty) {
        params.add('search=${Uri.encodeComponent(search.trim())}');
      }
      if (params.isNotEmpty) {
        url += '?${params.join('&')}';
      }

      final data = await apiClient!.get(url);
      if (data is List) {
        return data.map((json) => VehicleModel.fromJson(json)).toList();
      }
      return [];
    }
  }

  Future<VehicleModel> getVehicleById(int id) async {
    if (useMock) {
      await initMockData();
      final vehicle = _mockVehicles.firstWhere(
        (v) => v.id == id,
        orElse: () => throw ApiException(404, "Vehicle not found with ID: $id"),
      );
      return vehicle;
    } else {
      final response = await apiClient!.get('${ApiConstants.vehiclesEndpoint}/$id');
      return VehicleModel.fromJson(response);
    }
  }

  Future<VehicleModel> createVehicle(VehicleModel vehicle) async {
    if (useMock) {
      await initMockData();
      final cleanNumber = vehicle.vehicleNumber.trim().toUpperCase();

      final duplicate = _mockVehicles.any(
        (v) => v.vehicleNumber.trim().toUpperCase() == cleanNumber,
      );
      if (duplicate) {
        throw ApiException(409, "Vehicle with number '$cleanNumber' already exists in the fleet.");
      }

      final newId = (_mockVehicles.isNotEmpty
          ? _mockVehicles.map((v) => v.id ?? 0).reduce((a, b) => a > b ? a : b)
          : 0) + 1;
      final newVehicle = vehicle.copyWith(
        id: newId,
        vehicleNumber: cleanNumber,
      );
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
        throw ApiException(404, "Vehicle not found with ID: $id");
      }

      final cleanNumber = vehicle.vehicleNumber.trim().toUpperCase();
      final duplicate = _mockVehicles.any(
        (v) => v.id != id && v.vehicleNumber.trim().toUpperCase() == cleanNumber,
      );
      if (duplicate) {
        throw ApiException(409, "Vehicle with number '$cleanNumber' already exists in the fleet.");
      }

      final updated = vehicle.copyWith(
        id: id,
        vehicleNumber: cleanNumber,
      );
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
        throw ApiException(404, "Vehicle not found with ID: $id");
      }
      _mockVehicles.removeAt(index);
    } else {
      await apiClient!.delete('${ApiConstants.vehiclesEndpoint}/$id');
    }
  }

  Future<DashboardStats> getDashboardStats() async {
    if (useMock) {
      await initMockData();
      final total = _mockVehicles.length;
      final available = _mockVehicles.where((v) => v.status.toUpperCase() == 'AVAILABLE' || v.status.toUpperCase() == 'ACTIVE').length;
      final inTrip = _mockVehicles.where((v) => v.status.toUpperCase() == 'IN_TRIP').length;
      final maintenance = _mockVehicles.where((v) => v.status.toUpperCase() == 'MAINTENANCE').length;

      return DashboardStats(
        totalVehicles: total,
        availableVehicles: available,
        inTripVehicles: inTrip,
        maintenanceVehicles: maintenance,
        totalDrivers: 18,
        activeTrips: inTrip,
      );
    } else {
      final response = await apiClient!.get('/dashboard/stats');
      return DashboardStats.fromJson(response);
    }
  }
}
