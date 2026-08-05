import 'dart:convert';
import 'package:http/http.dart' as http;
import '../errors/exceptions.dart';

class ApiClient {
  final String baseUrl;
  final http.Client client;
  String? _token;

  ApiClient({
    this.baseUrl = 'http://localhost:8000/api',
    http.Client? httpClient,
  }) : client = httpClient ?? http.Client();

  void setToken(String? token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(),
      );
      return _processResponse(response);
    } on http.ClientException {
      throw const NetworkException('Network connection failed');
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(),
        body: body != null ? json.encode(body) : null,
      );
      return _processResponse(response);
    } on http.ClientException {
      throw const NetworkException('Network connection failed');
    }
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(),
        body: body != null ? json.encode(body) : null,
      );
      return _processResponse(response);
    } on http.ClientException {
      throw const NetworkException('Network connection failed');
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(),
      );
      return _processResponse(response);
    } on http.ClientException {
      throw const NetworkException('Network connection failed');
    }
  }

  dynamic _processResponse(http.Response response) {
    final int statusCode = response.statusCode;
    
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else if (statusCode == 401 || statusCode == 403) {
      throw const AuthException('Unauthorized action or expired token');
    } else if (statusCode == 422) {
      final decoded = json.decode(response.body);
      final message = decoded['message'] ?? 'Validation failed';
      final errors = decoded['errors'] as Map<String, dynamic>? ?? {};
      
      final Map<String, List<dynamic>> mappedErrors = {};
      errors.forEach((key, value) {
        if (value is List) {
          mappedErrors[key] = value;
        } else {
          mappedErrors[key] = [value];
        }
      });
      throw ValidationException(message: message, errors: mappedErrors);
    } else {
      throw ServerException('Request failed with code $statusCode: ${response.reasonPhrase}');
    }
  }
}
