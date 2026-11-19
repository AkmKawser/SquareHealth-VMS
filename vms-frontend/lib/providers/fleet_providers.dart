import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/dio_client.dart';
import '../models/dashboard_models.dart';
import '../models/document_models.dart';
import '../models/driver_models.dart';
import '../models/maintenance_models.dart';
import '../models/vehicle_models.dart';
import 'auth_provider.dart';

class VehicleQuery {
  const VehicleQuery({
    this.page = 0,
    this.size = 10,
    this.sortBy = 'createdAt',
    this.sortDir = 'desc',
    this.search = '',
    this.status,
    this.vehicleType,
  });

  final int page;
  final int size;
  final String sortBy;
  final String sortDir;
  final String search;
  final VehicleStatus? status;
  final VehicleType? vehicleType;

  VehicleQuery copyWith({
    int? page,
    int? size,
    String? sortBy,
    String? sortDir,
    String? search,
    VehicleStatus? status,
    bool clearStatus = false,
    VehicleType? vehicleType,
    bool clearType = false,
  }) {
    return VehicleQuery(
      page: page ?? this.page,
      size: size ?? this.size,
      sortBy: sortBy ?? this.sortBy,
      sortDir: sortDir ?? this.sortDir,
      search: search ?? this.search,
      status: clearStatus ? null : (status ?? this.status),
      vehicleType: clearType ? null : (vehicleType ?? this.vehicleType),
    );
  }
}

final vehicleQueryProvider = StateProvider<VehicleQuery>((ref) => const VehicleQuery());

final vehiclesPageProvider = FutureProvider<PagedResponse<Vehicle>>((ref) async {
  final client = ref.watch(dioClientProvider);
  final query = ref.watch(vehicleQueryProvider);

  final resp = await client.dio.get<Map<String, dynamic>>(
    '/vehicles',
    queryParameters: {
      'page': query.page,
      'size': query.size,
      'sortBy': query.sortBy,
      'sortDir': query.sortDir,
      if (query.search.trim().isNotEmpty) 'search': query.search.trim(),
      if (query.status != null) 'status': query.status!.apiValue,
      if (query.vehicleType != null) 'vehicleType': query.vehicleType!.apiValue,
    },
  );
  return PagedResponse.fromJson(resp.data!, Vehicle.fromJson);
});

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final client = ref.watch(dioClientProvider);
  final resp = await client.dio.get<Map<String, dynamic>>('/dashboard/stats');
  return DashboardStats.fromJson(resp.data!);
});

final driverSearchProvider = StateProvider<String>((ref) => '');

final driversProvider = FutureProvider<PagedResponse<Driver>>((ref) async {
  final client = ref.watch(dioClientProvider);
  final search = ref.watch(driverSearchProvider);
  final resp = await client.dio.get<Map<String, dynamic>>(
    '/drivers',
    queryParameters: {
      'page': 0,
      'size': 50,
      if (search.trim().isNotEmpty) 'search': search.trim(),
    },
  );
  return PagedResponse.fromJson(resp.data!, Driver.fromJson);
});

final vehicleDocumentsProvider =
    FutureProvider.family<List<VehicleDocument>, int>((ref, vehicleId) async {
  final client = ref.watch(dioClientProvider);
  final resp = await client.dio.get<List<dynamic>>('/vehicles/$vehicleId/documents');
  return (resp.data ?? [])
      .map((e) => VehicleDocument.fromJson(e as Map<String, dynamic>))
      .toList();
});

final vehicleMaintenanceProvider =
    FutureProvider.family<List<MaintenanceLog>, int>((ref, vehicleId) async {
  final client = ref.watch(dioClientProvider);
  final resp = await client.dio.get<List<dynamic>>('/vehicles/$vehicleId/maintenance');
  return (resp.data ?? [])
      .map((e) => MaintenanceLog.fromJson(e as Map<String, dynamic>))
      .toList();
});

class FleetActions {
  FleetActions(this._ref);
  final Ref _ref;

  DioClient get _client => _ref.read(dioClientProvider);

  void _refreshVehiclesAndDashboard() {
    _ref.invalidate(vehiclesPageProvider);
    _ref.invalidate(dashboardStatsProvider);
  }

  Future<Vehicle> createVehicle(Vehicle vehicle) async {
    try {
      final resp = await _client.dio.post<Map<String, dynamic>>(
        '/vehicles',
        data: vehicle.toJson(),
      );
      _refreshVehiclesAndDashboard();
      return Vehicle.fromJson(resp.data!);
    } catch (e) {
      throw DioClient.parseError(e);
    }
  }

  Future<Vehicle> updateVehicle(int id, Vehicle vehicle) async {
    try {
      final resp = await _client.dio.put<Map<String, dynamic>>(
        '/vehicles/$id',
        data: vehicle.toJson(),
      );
      _refreshVehiclesAndDashboard();
      return Vehicle.fromJson(resp.data!);
    } catch (e) {
      throw DioClient.parseError(e);
    }
  }

  Future<void> deleteVehicle(int id) async {
    try {
      await _client.dio.delete('/vehicles/$id');
      _refreshVehiclesAndDashboard();
    } catch (e) {
      throw DioClient.parseError(e);
    }
  }

  Future<Vehicle> assignDriver(int vehicleId, int? driverId) async {
    try {
      final resp = await _client.dio.put<Map<String, dynamic>>(
        '/vehicles/$vehicleId/driver',
        data: {'driverId': driverId},
      );
      _refreshVehiclesAndDashboard();
      return Vehicle.fromJson(resp.data!);
    } catch (e) {
      throw DioClient.parseError(e);
    }
  }

  Future<void> uploadDocument({
    required int vehicleId,
    required Uint8List bytes,
    required String fileName,
    required DocumentType documentType,
    String? expiryDate,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: fileName),
        'documentType': documentType.apiValue,
        if (expiryDate != null && expiryDate.isNotEmpty) 'expiryDate': expiryDate,
      });
      await _client.dio.post('/vehicles/$vehicleId/documents', data: formData);
      _ref.invalidate(vehicleDocumentsProvider(vehicleId));
      _refreshVehiclesAndDashboard();
    } catch (e) {
      throw DioClient.parseError(e);
    }
  }

  Future<void> deleteDocument(int vehicleId, int docId) async {
    try {
      await _client.dio.delete('/documents/$docId');
      _ref.invalidate(vehicleDocumentsProvider(vehicleId));
      _refreshVehiclesAndDashboard();
    } catch (e) {
      throw DioClient.parseError(e);
    }
  }

  Future<void> logMaintenance(int vehicleId, MaintenanceLog log) async {
    try {
      await _client.dio.post('/vehicles/$vehicleId/maintenance', data: log.toJson());
      _ref.invalidate(vehicleMaintenanceProvider(vehicleId));
      _refreshVehiclesAndDashboard();
    } catch (e) {
      throw DioClient.parseError(e);
    }
  }

  Future<void> createDriver(Driver driver) async {
    try {
      await _client.dio.post('/drivers', data: driver.toJson());
      _ref.invalidate(driversProvider);
      _ref.invalidate(dashboardStatsProvider);
    } catch (e) {
      throw DioClient.parseError(e);
    }
  }

  Future<void> updateDriver(int id, Driver driver) async {
    try {
      await _client.dio.put('/drivers/$id', data: driver.toJson());
      _ref.invalidate(driversProvider);
    } catch (e) {
      throw DioClient.parseError(e);
    }
  }

  Future<void> deleteDriver(int id) async {
    try {
      await _client.dio.delete('/drivers/$id');
      _ref.invalidate(driversProvider);
      _ref.invalidate(dashboardStatsProvider);
    } catch (e) {
      throw DioClient.parseError(e);
    }
  }
}

final fleetActionsProvider = Provider<FleetActions>((ref) => FleetActions(ref));
