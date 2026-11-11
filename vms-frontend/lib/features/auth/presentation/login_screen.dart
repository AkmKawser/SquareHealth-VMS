import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: 'Password123!');
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username == 'admin' && password == 'Password123!') {
      setState(() => _isLoading = false);
      widget.onLoginSuccess();
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid username or password. Use demo credentials.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.borderSubtle),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo & Brand
                      Center(
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primaryNavy,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.directions_car, color: Colors.white, size: 30),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'Square Health VMS',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Center(
                        child: Text(
                          'Enterprise Vehicle Management Portal',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 28),

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
                              const Icon(Icons.error_outline, color: AppColors.dangerRed, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: AppColors.dangerRed, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Username field
                      const Text('Username / Email', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Enter username',
                          prefixIcon: const Icon(Icons.person_outline, size: 20),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        validator: Validators.emailOrUsername,
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      const Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          prefixIcon: const Icon(Icons.lock_outline, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        validator: Validators.password,
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.corporateBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Sign In to Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                      const SizedBox(height: 16),

                      // Quick Demo credentials info
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Demo Credentials:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.textPrimary)),
                            const SizedBox(height: 2),
                            const Text('Username: admin   |   Password: Password123!', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
