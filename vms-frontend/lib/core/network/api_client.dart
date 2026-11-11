import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException: [$statusCode] $message';
}

class ApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({String? baseUrl, http.Client? client})
      : baseUrl = baseUrl ?? ApiConstants.defaultBaseUrl,
        _client = client ?? http.Client();

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await _client.get(uri, headers: _buildHeaders(headers));
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await _client.post(
      uri,
      headers: _buildHeaders(headers),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await _client.put(
      uri,
      headers: _buildHeaders(headers),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await _client.delete(uri, headers: _buildHeaders(headers));
    return _handleResponse(response);
  }

  Map<String, String> _buildHeaders(Map<String, String>? customHeaders) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      String errorMessage = 'Request failed with status: ${response.statusCode}';
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body.containsKey('message')) {
          errorMessage = body['message'];
        }
      } catch (_) {}
      throw ApiException(response.statusCode, errorMessage);
    }
  }
}

