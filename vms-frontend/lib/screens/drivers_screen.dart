import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_theme.dart';
import '../models/driver_models.dart';
import '../providers/fleet_providers.dart';

class DriversScreen extends ConsumerStatefulWidget {
  const DriversScreen({super.key});

  @override
  ConsumerState<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends ConsumerState<DriversScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _openDriverDialog({Driver? existing}) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: existing?.fullName ?? '');
    final licenseCtrl = TextEditingController(text: existing?.licenseNumber ?? '');
    final expiryCtrl = TextEditingController(
      text: existing?.licenseExpiryDate ??
          DateTime.now().add(const Duration(days: 365)).toIso8601String().substring(0, 10),
    );
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final nidCtrl = TextEditingController(text: existing?.nationalId ?? '');
    bool active = existing?.active ?? true;
    String? apiError;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(existing == null ? 'Add Driver' : 'Edit Driver'),
          content: SizedBox(
            width: 420,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (apiError != null) ...[
                      Text(apiError!, style: const TextStyle(color: AppTheme.crimson)),
                      const SizedBox(height: 10),
                    ],
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Full Name*'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: licenseCtrl,
                      decoration: const InputDecoration(labelText: 'License Number*'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: expiryCtrl,
                      decoration: const InputDecoration(labelText: 'License Expiry (YYYY-MM-DD)*'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phoneCtrl,
                      decoration: const InputDecoration(labelText: 'Phone*'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nidCtrl,
                      decoration: const InputDecoration(labelText: 'National ID'),
                    ),
                    SwitchListTile(
                      title: const Text('Active'),
                      value: active,
                      onChanged: (v) => setLocal(() => active = v),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final driver = Driver(
                  nationalId: nidCtrl.text.trim(),
                  fullName: nameCtrl.text.trim(),
                  licenseNumber: licenseCtrl.text.trim(),
                  licenseExpiryDate: expiryCtrl.text.trim(),
                  phone: phoneCtrl.text.trim(),
                  active: active,
                );
                try {
                  if (existing == null) {
                    await ref.read(fleetActionsProvider).createDriver(driver);
                  } else {
                    await ref.read(fleetActionsProvider).updateDriver(existing.id!, driver);
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                } catch (e) {
                  setLocal(() => apiError = e.toString());
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final driversAsync = ref.watch(driversProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Search drivers by name, license, or phone...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (v) => ref.read(driverSearchProvider.notifier).state = v,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _openDriverDialog(),
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Add Driver'),
              ),
            ],
          ),
        ),
        Expanded(
          child: driversAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (page) => page.content.isEmpty
                ? const Center(child: Text('No drivers found.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: page.content.length,
                    itemBuilder: (_, i) {
                      final d = page.content[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: (d.eligible ? AppTheme.emerald : AppTheme.amber)
                                .withValues(alpha: 0.14),
                            child: Icon(
                              Icons.badge_outlined,
                              color: d.eligible ? AppTheme.emerald : AppTheme.amber,
                            ),
                          ),
                          title: Text(d.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'License: ${d.licenseNumber} • Expires: ${d.licenseExpiryDate} • ${d.phone}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Chip(
                                label: Text(d.eligible ? 'Eligible' : 'Ineligible'),
                                side: BorderSide.none,
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => _openDriverDialog(existing: d),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppTheme.crimson),
                                onPressed: () => ref.read(fleetActionsProvider).deleteDriver(d.id!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
