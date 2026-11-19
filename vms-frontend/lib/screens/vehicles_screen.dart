import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_theme.dart';
import '../models/vehicle_models.dart';
import '../providers/fleet_providers.dart';
import 'vehicle_detail_dialog.dart';

class VehiclesScreen extends ConsumerStatefulWidget {
  const VehiclesScreen({super.key});

  @override
  ConsumerState<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends ConsumerState<VehiclesScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _openFormDialog({Vehicle? existing}) async {
    final formKey = GlobalKey<FormState>();
    final plateCtrl = TextEditingController(text: existing?.vehicleNumber ?? '');
    final companyCtrl = TextEditingController(text: existing?.company ?? 'Stark Group');
    final brandCtrl = TextEditingController(text: existing?.brand ?? '');
    final modelCtrl = TextEditingController(text: existing?.model ?? '');
    final yearCtrl = TextEditingController(text: existing?.manufacturingYear?.toString() ?? '2024');
    final colorCtrl = TextEditingController(text: existing?.color ?? '');
    final seatsCtrl = TextEditingController(text: existing?.seatingCapacity?.toString() ?? '5');
    VehicleType type = existing?.vehicleType ?? VehicleType.car;
    FuelType fuel = existing?.fuelType ?? FuelType.hybrid;
    VehicleStatus status = existing?.status ?? VehicleStatus.available;
    String? apiError;
    bool saving = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(existing == null ? 'Register Vehicle' : 'Edit Vehicle'),
          content: SizedBox(
            width: 480,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (apiError != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.crimson.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.crimson),
                        ),
                        child: Text(apiError!, style: const TextStyle(color: AppTheme.crimson)),
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextFormField(
                      controller: plateCtrl,
                      decoration: const InputDecoration(labelText: 'Vehicle Number*'),
                      validator: (v) => (v == null || v.trim().length < 3) ? 'Valid plate required' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: companyCtrl,
                      decoration: const InputDecoration(labelText: 'Operating Company*'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Company is required' : null,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: brandCtrl,
                            decoration: const InputDecoration(labelText: 'Brand*'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: modelCtrl,
                            decoration: const InputDecoration(labelText: 'Model*'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<VehicleType>(
                            value: type,
                            decoration: const InputDecoration(labelText: 'Type'),
                            items: VehicleType.values
                                .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setLocal(() => type = v);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<FuelType>(
                            value: fuel,
                            decoration: const InputDecoration(labelText: 'Fuel'),
                            items: FuelType.values
                                .map((f) => DropdownMenuItem(value: f, child: Text(f.label)))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setLocal(() => fuel = v);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: yearCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Year'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: seatsCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Seats'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: colorCtrl,
                            decoration: const InputDecoration(labelText: 'Color'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<VehicleStatus>(
                            value: status,
                            decoration: const InputDecoration(labelText: 'Status'),
                            items: VehicleStatus.values
                                .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setLocal(() => status = v);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: saving
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      setLocal(() {
                        saving = true;
                        apiError = null;
                      });
                      final payload = Vehicle(
                        vehicleNumber: plateCtrl.text.trim(),
                        company: companyCtrl.text.trim(),
                        vehicleType: type,
                        brand: brandCtrl.text.trim(),
                        model: modelCtrl.text.trim(),
                        manufacturingYear: int.tryParse(yearCtrl.text.trim()),
                        color: colorCtrl.text.trim(),
                        seatingCapacity: int.tryParse(seatsCtrl.text.trim()),
                        fuelType: fuel,
                        status: status,
                      );
                      try {
                        if (existing == null) {
                          await ref.read(fleetActionsProvider).createVehicle(payload);
                        } else {
                          await ref.read(fleetActionsProvider).updateVehicle(existing.id!, payload);
                        }
                        if (ctx.mounted) Navigator.pop(ctx);
                      } catch (e) {
                        setLocal(() {
                          saving = false;
                          apiError = e.toString();
                        });
                      }
                    },
              child: Text(saving ? 'Saving...' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(Vehicle v) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: Text('Delete ${v.vehicleNumber} (${v.brand} ${v.model})? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.crimson),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(fleetActionsProvider).deleteVehicle(v.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(vehicleQueryProvider);
    final vehiclesAsync = ref.watch(vehiclesPageProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Wrap(
            spacing: 12,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 280,
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search plate, brand, model, driver...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchCtrl.clear();
                              ref.read(vehicleQueryProvider.notifier).state =
                                  query.copyWith(page: 0, search: '');
                            },
                          )
                        : null,
                  ),
                  onSubmitted: (val) {
                    ref.read(vehicleQueryProvider.notifier).state =
                        query.copyWith(page: 0, search: val);
                  },
                ),
              ),
              DropdownButton<VehicleStatus?>(
                value: query.status,
                hint: const Text('All Statuses'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Statuses')),
                  ...VehicleStatus.values.map(
                    (s) => DropdownMenuItem(value: s, child: Text(s.label)),
                  ),
                ],
                onChanged: (val) {
                  ref.read(vehicleQueryProvider.notifier).state = val == null
                      ? query.copyWith(page: 0, clearStatus: true)
                      : query.copyWith(page: 0, status: val);
                },
              ),
              DropdownButton<String>(
                value: '${query.sortBy}:${query.sortDir}',
                items: const [
                  DropdownMenuItem(value: 'createdAt:desc', child: Text('Newest First')),
                  DropdownMenuItem(value: 'vehicleNumber:asc', child: Text('Plate (A-Z)')),
                  DropdownMenuItem(value: 'brand:asc', child: Text('Brand (A-Z)')),
                  DropdownMenuItem(value: 'manufacturingYear:desc', child: Text('Year (Newest)')),
                ],
                onChanged: (val) {
                  if (val == null) return;
                  final parts = val.split(':');
                  ref.read(vehicleQueryProvider.notifier).state =
                      query.copyWith(page: 0, sortBy: parts[0], sortDir: parts[1]);
                },
              ),
              ElevatedButton.icon(
                onPressed: () => _openFormDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Vehicle'),
              ),
            ],
          ),
        ),
        Expanded(
          child: vehiclesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (page) {
              if (page.content.isEmpty) {
                return const Center(child: Text('No vehicles match the current filter.'));
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: page.content.length,
                      itemBuilder: (_, i) {
                        final v = page.content[i];
                        final statusColor = switch (v.status) {
                          VehicleStatus.available => AppTheme.emerald,
                          VehicleStatus.active || VehicleStatus.inUse => AppTheme.electricBlue,
                          VehicleStatus.maintenance => AppTheme.amber,
                          VehicleStatus.inactive || VehicleStatus.retired => Colors.blueGrey,
                        };
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            onTap: () => showDialog(
                              context: context,
                              builder: (_) => VehicleDetailDialog(vehicle: v),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: statusColor.withValues(alpha: 0.12),
                              child: Icon(Icons.directions_car, color: statusColor),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  v.vehicleNumber,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Chip(
                                  label: Text(
                                    v.status.label,
                                    style: TextStyle(color: statusColor, fontSize: 11),
                                  ),
                                  backgroundColor: statusColor.withValues(alpha: 0.12),
                                  side: BorderSide.none,
                                  visualDensity: VisualDensity.compact,
                                ),
                                if (v.complianceStatus != ExpiryStatus.valid) ...[
                                  const SizedBox(width: 6),
                                  Chip(
                                    label: Text(
                                      v.complianceStatus.label,
                                      style: const TextStyle(color: AppTheme.crimson, fontSize: 11),
                                    ),
                                    backgroundColor: AppTheme.crimson.withValues(alpha: 0.12),
                                    side: BorderSide.none,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ],
                              ],
                            ),
                            subtitle: Text(
                              '${v.brand} ${v.model} (${v.vehicleType.label}) • ${v.company}'
                              '${v.driverName != null ? " • Driver: ${v.driverName}" : ""}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Edit',
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () => _openFormDialog(existing: v),
                                ),
                                IconButton(
                                  tooltip: 'Delete',
                                  icon: const Icon(Icons.delete_outline, color: AppTheme.crimson),
                                  onPressed: () => _confirmDelete(v),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total: ${page.totalElements} vehicles • Page ${page.page + 1} of ${page.totalPages == 0 ? 1 : page.totalPages}'),
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: page.page > 0
                                  ? () => ref.read(vehicleQueryProvider.notifier).state =
                                      query.copyWith(page: page.page - 1)
                                  : null,
                              child: const Text('Previous'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: page.hasNext
                                  ? () => ref.read(vehicleQueryProvider.notifier).state =
                                      query.copyWith(page: page.page + 1)
                                  : null,
                              child: const Text('Next'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
