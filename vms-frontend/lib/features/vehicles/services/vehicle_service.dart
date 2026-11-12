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
      inTripVehicles: (json['activeVehicles'] as int?) ?? (json['inTripVehicles'] as int? ?? 0),
      maintenanceVehicles: json['maintenanceVehicles'] as int? ?? 0,
      totalDrivers: 18,
      activeTrips: (json['activeVehicles'] as int?) ?? 5,
    );
  }
}

class VehicleService {
  final ApiClient? apiClient;
  final bool useMock;

  // In-memory mock cache for fallback or offline development
  static final List<VehicleModel> _mockVehicles = [];
  static bool _initialized = false;

  VehicleService({ApiClient? apiClient, this.useMock = false})
      : apiClient = apiClient ?? ApiClient(baseUrl: ApiConstants.defaultBaseUrl);

  Future<void> initMockData() async {
    if (_initialized && _mockVehicles.isNotEmpty) return;
    try {
      final jsonString = await rootBundle.loadString('assets/mock_data/vehicles_mock.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _mockVehicles.clear();
      _mockVehicles.addAll(jsonList.map((j) => VehicleModel.fromJson(j)));
      _initialized = true;
    } catch (_) {
      if (_mockVehicles.isEmpty) {
        _mockVehicles.addAll([
          VehicleModel(
            id: 1,
            vehicleNumber: 'DHA-GA-11-2045',
            company: 'Square Health',
            type: 'Ambulance',
            brand: 'Toyota',
            model: 'HiAce Emergency ICU',
            status: 'AVAILABLE',
          ),
          VehicleModel(
            id: 2,
            vehicleNumber: 'DHA-MET-54-8890',
            company: 'Stark Group Logistics',
            type: 'Logistics Van',
            brand: 'Isuzu',
            model: 'Cold Chain Reefer',
            status: 'IN_TRIP',
          ),
          VehicleModel(
            id: 3,
            vehicleNumber: 'DHA-GA-12-9901',
            company: 'Square Health',
            type: 'Executive Sedan',
            brand: 'Toyota',
            model: 'Corolla Altis Hybrid',
            status: 'AVAILABLE',
          ),
          VehicleModel(
            id: 4,
            vehicleNumber: 'CTG-SHA-33-4120',
            company: 'Stark Group Logistics',
            type: 'Logistics Van',
            brand: 'Hyundai',
            model: 'H-1 Refrigerated Cargo',
            status: 'MAINTENANCE',
          ),
        ]);
        _initialized = true;
      }
    }
  }

  Future<List<VehicleModel>> getVehicles({String? status, String? search}) async {
    if (!useMock) {
      try {
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
      } catch (e) {
        // Fallback to mock on connection exception if desired
      }
    }

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
  }

  Future<VehicleModel> getVehicleById(int id) async {
    if (!useMock) {
      try {
        final response = await apiClient!.get('${ApiConstants.vehiclesEndpoint}/$id');
        return VehicleModel.fromJson(response);
      } catch (_) {}
    }

    await initMockData();
    return _mockVehicles.firstWhere(
      (v) => v.id == id,
      orElse: () => throw ApiException(404, "Vehicle not found with ID: $id"),
    );
  }

  Future<VehicleModel> createVehicle(VehicleModel vehicle) async {
    if (!useMock) {
      final response = await apiClient!.post(ApiConstants.vehiclesEndpoint, body: vehicle.toJson());
      return VehicleModel.fromJson(response);
    }

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
  }

  Future<VehicleModel> updateVehicle(int id, VehicleModel vehicle) async {
    if (!useMock) {
      final response = await apiClient!.put('${ApiConstants.vehiclesEndpoint}/$id', body: vehicle.toJson());
      return VehicleModel.fromJson(response);
    }

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
  }

  Future<void> deleteVehicle(int id) async {
    if (!useMock) {
      await apiClient!.delete('${ApiConstants.vehiclesEndpoint}/$id');
      return;
    }

    await initMockData();
    final index = _mockVehicles.indexWhere((v) => v.id == id);
    if (index == -1) {
      throw ApiException(404, "Vehicle not found with ID: $id");
    }
    _mockVehicles.removeAt(index);
  }

  Future<DashboardStats> getDashboardStats() async {
    if (!useMock) {
      try {
        final response = await apiClient!.get('/dashboard/stats');
        return DashboardStats.fromJson(response);
      } catch (_) {}
    }

    await initMockData();
    final total = _mockVehicles.length;
    final available = _mockVehicles.where((v) => v.status.toUpperCase() == 'AVAILABLE' || v.status.toUpperCase() == 'ACTIVE').length;
    final inTrip = _mockVehicles.where((v) => v.status.toUpperCase() == 'IN_TRIP' || v.status.toUpperCase() == 'ON_TRIP').length;
    final maintenance = _mockVehicles.where((v) => v.status.toUpperCase() == 'MAINTENANCE').length;

    return DashboardStats(
      totalVehicles: total,
      availableVehicles: available,
      inTripVehicles: inTrip,
      maintenanceVehicles: maintenance,
      totalDrivers: 18,
      activeTrips: inTrip,
    );
  }
}
