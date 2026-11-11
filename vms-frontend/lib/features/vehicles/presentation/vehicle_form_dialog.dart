import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/validators.dart';
import '../data/vehicle_model.dart';
import '../services/vehicle_service.dart';

class VehicleFormDialog extends StatefulWidget {
  final VehicleModel? vehicle;
  final VehicleService vehicleService;

  const VehicleFormDialog({
    super.key,
    this.vehicle,
    required this.vehicleService,
  });

  @override
  State<VehicleFormDialog> createState() => _VehicleFormDialogState();
}

class _VehicleFormDialogState extends State<VehicleFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _numberController;
  late TextEditingController _brandController;
  late TextEditingController _modelController;

  String _selectedCompany = 'Square Health';
  String _selectedType = 'Ambulance';
  String _selectedStatus = 'AVAILABLE';

  bool _isSubmitting = false;
  String? _errorMessage;

  final List<String> _companies = [
    'Square Health',
    'Square Pharmaceuticals',
    'Square Hospitals',
    'Square Textiles',
    'Square Toiletries',
  ];

  final List<String> _types = [
    'Ambulance',
    'Delivery Van',
    'Microbus',
    'Executive Sedan',
    'Cargo Truck',
  ];

  final List<String> _statuses = [
    'AVAILABLE',
    'IN_TRIP',
    'MAINTENANCE',
  ];

  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    _numberController = TextEditingController(text: v?.vehicleNumber ?? '');
    _brandController = TextEditingController(text: v?.brand ?? '');
    _modelController = TextEditingController(text: v?.model ?? '');

    if (v != null) {
      if (_companies.contains(v.company)) {
        _selectedCompany = v.company;
      } else {
        _companies.add(v.company);
        _selectedCompany = v.company;
      }

      if (_types.contains(v.type)) {
        _selectedType = v.type;
      }

      final st = v.status.toUpperCase() == 'ACTIVE' ? 'AVAILABLE' : v.status.toUpperCase();
      if (_statuses.contains(st)) {
        _selectedStatus = st;
      }
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final vehicleData = VehicleModel(
      id: widget.vehicle?.id,
      vehicleNumber: _numberController.text.trim().toUpperCase(),
      company: _selectedCompany,
      type: _selectedType,
      brand: _brandController.text.trim(),
      model: _modelController.text.trim(),
      status: _selectedStatus,
    );

    try {
      if (widget.vehicle == null) {
        await widget.vehicleService.createVehicle(vehicleData);
      } else {
        await widget.vehicleService.updateVehicle(widget.vehicle!.id!, vehicleData);
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        if (e is ApiException) {
          _errorMessage = e.message;
        } else {
          _errorMessage = e.toString();
        }
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.vehicle != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isEditing ? Icons.edit_note : Icons.add_circle_outline,
                            color: AppColors.corporateBlue,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isEditing ? 'Edit Vehicle Registry' : 'Register New Vehicle',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isEditing
                        ? 'Update fleet metadata and operational assignment.'
                        : 'Enter official registration and manufacturer details for the fleet vehicle.',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const Divider(height: 32, color: AppColors.borderSubtle),

                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.dangerRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.dangerRed.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.dangerRed, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: AppColors.dangerRed, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Vehicle Number
                  const Text('Vehicle License Plate Number *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _numberController,
                    decoration: InputDecoration(
                      hintText: 'e.g. DHAKA-METRO-GA-11-2233',
                      prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    validator: Validators.vehicleNumber,
                    textCapitalization: TextCapitalization.characters,
                  ),
                  const SizedBox(height: 16),

                  // Company & Type in a row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Operating Company *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: _selectedCompany,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                              items: _companies.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedCompany = val);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Vehicle Type *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: _selectedType,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                              items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13)))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedType = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Brand & Model in a row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Manufacturer / Brand *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _brandController,
                              decoration: InputDecoration(
                                hintText: 'e.g. Toyota',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                              validator: (v) => Validators.requiredField(v, 'Brand'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Model Name *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _modelController,
                              decoration: InputDecoration(
                                hintText: 'e.g. HiAce',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                              validator: (v) => Validators.requiredField(v, 'Model'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Operational Status
                  const Text('Operational Fleet Status *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: _statuses.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.replaceAll('_', ' '), style: const TextStyle(fontSize: 13)),
                    )).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedStatus = val);
                    },
                  ),
                  const SizedBox(height: 28),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.corporateBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(isEditing ? 'Save Changes' : 'Register Vehicle'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

