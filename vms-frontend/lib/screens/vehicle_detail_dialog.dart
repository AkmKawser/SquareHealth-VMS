import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_theme.dart';
import '../models/document_models.dart';
import '../models/maintenance_models.dart';
import '../models/vehicle_models.dart';
import '../providers/fleet_providers.dart';

class VehicleDetailDialog extends ConsumerStatefulWidget {
  const VehicleDetailDialog({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  ConsumerState<VehicleDetailDialog> createState() => _VehicleDetailDialogState();
}

class _VehicleDetailDialogState extends ConsumerState<VehicleDetailDialog> {
  late Vehicle _vehicle;

  @override
  void initState() {
    super.initState();
    _vehicle = widget.vehicle;
  }

  Future<void> _assignDriver(int? driverId) async {
    try {
      final updated = await ref.read(fleetActionsProvider).assignDriver(_vehicle.id!, driverId);
      setState(() => _vehicle = updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Driver assignment updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppTheme.crimson),
        );
      }
    }
  }

  Future<void> _uploadDocument() async {
    DocumentType selectedType = DocumentType.registration;
    final expiryCtrl = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Upload Vehicle Document'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<DocumentType>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Document Type'),
                items: DocumentType.values
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setLocal(() => selectedType = v);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: expiryCtrl,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date (YYYY-MM-DD, optional)',
                  hintText: '2027-06-30',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Pick File')),
          ],
        ),
      ),
    );

    if (confirmed != true) return;
    final picked = await FilePicker.platform.pickFiles(withData: true);
    if (picked == null || picked.files.single.bytes == null) return;

    try {
      await ref.read(fleetActionsProvider).uploadDocument(
            vehicleId: _vehicle.id!,
            bytes: picked.files.single.bytes!,
            fileName: picked.files.single.name,
            documentType: selectedType,
            expiryDate: expiryCtrl.text.trim(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document uploaded')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppTheme.crimson),
        );
      }
    }
  }

  Future<void> _logMaintenance() async {
    final formKey = GlobalKey<FormState>();
    final dateCtrl = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));
    final typeCtrl = TextEditingController(text: 'Periodic Inspection');
    final costCtrl = TextEditingController(text: '2500');
    final vendorCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Maintenance'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: dateCtrl,
                  decoration: const InputDecoration(labelText: 'Service Date (YYYY-MM-DD)*'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: typeCtrl,
                  decoration: const InputDecoration(labelText: 'Maintenance Type*'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: costCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Cost*'),
                  validator: (v) => double.tryParse(v ?? '') == null ? 'Valid number required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: vendorCtrl,
                  decoration: const InputDecoration(labelText: 'Workshop Vendor*'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: notesCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) Navigator.pop(ctx, true);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (saved != true) return;
    try {
      await ref.read(fleetActionsProvider).logMaintenance(
            _vehicle.id!,
            MaintenanceLog(
              vehicleId: _vehicle.id!,
              serviceDate: dateCtrl.text.trim(),
              maintenanceType: typeCtrl.text.trim(),
              serviceCost: double.parse(costCtrl.text.trim()),
              workshopVendor: vendorCtrl.text.trim(),
              notes: notesCtrl.text.trim(),
            ),
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppTheme.crimson),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final docsAsync = ref.watch(vehicleDocumentsProvider(_vehicle.id!));
    final maintAsync = ref.watch(vehicleMaintenanceProvider(_vehicle.id!));
    final driversAsync = ref.watch(driversProvider);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 620),
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                color: AppTheme.deepNavy,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _vehicle.vehicleNumber,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_vehicle.brand} ${_vehicle.model} • ${_vehicle.company}',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Overview & Driver'),
                  Tab(text: 'Documents & Expiry'),
                  Tab(text: 'Maintenance History'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab 1: Overview & Driver Assignment
                    ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Wrap(
                          spacing: 24,
                          runSpacing: 10,
                          children: [
                            _InfoItem('Type', _vehicle.vehicleType.label),
                            _InfoItem('Fuel', _vehicle.fuelType.label),
                            _InfoItem('Status', _vehicle.status.label),
                            _InfoItem('Year', '${_vehicle.manufacturingYear ?? "-"}'),
                            _InfoItem('Color', _vehicle.color ?? '-'),
                            _InfoItem('Seats', '${_vehicle.seatingCapacity ?? "-"}'),
                            _InfoItem('Odometer', '${_vehicle.odometerKm} km'),
                            _InfoItem('Fuel Level', '${_vehicle.fuelLevel}%'),
                          ],
                        ),
                        const Divider(height: 28),
                        const Text(
                          'Assigned Driver',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        const SizedBox(height: 8),
                        driversAsync.when(
                          loading: () => const LinearProgressIndicator(),
                          error: (e, _) => Text('Error loading drivers: $e'),
                          data: (page) {
                            final currentId = page.content.any((d) => d.id == _vehicle.driverId)
                                ? _vehicle.driverId
                                : null;
                            return Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<int?>(
                                    value: currentId,
                                    decoration: const InputDecoration(labelText: 'Select Driver'),
                                    items: [
                                      const DropdownMenuItem<int?>(
                                        value: null,
                                        child: Text('Unassigned'),
                                      ),
                                      ...page.content.map(
                                        (d) => DropdownMenuItem<int?>(
                                          value: d.id,
                                          child: Text('${d.fullName} (${d.licenseNumber})'),
                                        ),
                                      ),
                                    ],
                                    onChanged: _assignDriver,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    // Tab 2: Documents & Expiry
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Compliance Documents & Photos',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              ElevatedButton.icon(
                                onPressed: _uploadDocument,
                                icon: const Icon(Icons.upload_file, size: 18),
                                label: const Text('Upload'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: docsAsync.when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, _) => Center(child: Text('Error: $e')),
                            data: (docs) => docs.isEmpty
                                ? const Center(child: Text('No documents uploaded yet.'))
                                : ListView.separated(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    itemCount: docs.length,
                                    separatorBuilder: (_, __) => const Divider(height: 1),
                                    itemBuilder: (_, i) {
                                      final d = docs[i];
                                      final badgeColor = switch (d.expiryStatus) {
                                        ExpiryStatus.valid => AppTheme.emerald,
                                        ExpiryStatus.expiringSoon => AppTheme.amber,
                                        ExpiryStatus.expired => AppTheme.crimson,
                                      };
                                      return ListTile(
                                        leading: const Icon(Icons.description_outlined),
                                        title: Text('${d.documentType.label} — ${d.fileName}'),
                                        subtitle: Text('Expiry: ${d.expiryDate ?? "N/A"}'),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Chip(
                                              label: Text(
                                                d.expiryStatus.label,
                                                style: TextStyle(color: badgeColor, fontSize: 12),
                                              ),
                                              backgroundColor: badgeColor.withValues(alpha: 0.12),
                                              side: BorderSide.none,
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline, color: AppTheme.crimson),
                                              onPressed: () => ref
                                                  .read(fleetActionsProvider)
                                                  .deleteDocument(_vehicle.id!, d.id),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                    // Tab 3: Maintenance History
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Per-Vehicle Service Timeline',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              ElevatedButton.icon(
                                onPressed: _logMaintenance,
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Log Service'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: maintAsync.when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, _) => Center(child: Text('Error: $e')),
                            data: (logs) => logs.isEmpty
                                ? const Center(child: Text('No maintenance history recorded.'))
                                : ListView.separated(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    itemCount: logs.length,
                                    separatorBuilder: (_, __) => const Divider(height: 1),
                                    itemBuilder: (_, i) {
                                      final m = logs[i];
                                      return ListTile(
                                        leading: const Icon(Icons.build_circle_outlined, color: AppTheme.amber),
                                        title: Text('${m.maintenanceType} • ৳${m.serviceCost.toStringAsFixed(0)}'),
                                        subtitle: Text(
                                          '${m.serviceDate} • ${m.workshopVendor}'
                                          '${m.notes != null && m.notes!.isNotEmpty ? "\n${m.notes}" : ""}',
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
