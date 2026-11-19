import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/dio_client.dart';
import '../models/auth_models.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

class AuthState {
  const AuthState({this.user, this.isLoading = false, this.error});

  final AuthResponse? user;
  final bool isLoading;
  final String? error;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    AuthResponse? user,
    bool clearUser = false,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._client) : super(const AuthState());

  final DioClient _client;

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final resp = await _client.dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'username': username.trim(), 'password': password},
      );
      final auth = AuthResponse.fromJson(resp.data!);
      _client.setToken(auth.token);
      state = AuthState(user: auth, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: DioClient.parseError(e).message,
      );
      return false;
    }
  }

  void logout() {
    _client.setToken(null);
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(dioClientProvider));
});
