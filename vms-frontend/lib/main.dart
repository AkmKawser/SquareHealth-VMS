import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/app_shell.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const ProviderScope(child: VmsApp()));
}

class VmsApp extends ConsumerWidget {
  const VmsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuth = ref.watch(authProvider.select((s) => s.isAuthenticated));

    return MaterialApp(
      title: 'SquareHealth-VMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: isAuth ? const AppShell() : const LoginScreen(),
    );
  }
}
