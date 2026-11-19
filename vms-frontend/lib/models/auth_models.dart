class AuthResponse {
  const AuthResponse({
    required this.token,
    required this.tokenType,
    required this.username,
    required this.fullName,
    required this.company,
    required this.role,
  });

  final String token;
  final String tokenType;
  final String username;
  final String fullName;
  final String company;
  final String role;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      tokenType: (json['tokenType'] as String?) ?? 'Bearer',
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      company: (json['company'] as String?) ?? 'Stark Group',
      role: json['role'] as String,
    );
  }
}
