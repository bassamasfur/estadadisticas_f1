import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_constants.dart';

/// Servicio HTTP para realizar peticiones a la API
class HttpService {
  final http.Client _client;
  final String _baseUrl;

  HttpService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? AppConstants.baseUrl;

  /// Realiza una petición GET
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('$_baseUrl/$endpoint');
      final response = await _client
          .get(url, headers: headers)
          .timeout(AppConstants.connectionTimeout);

      return _procesarRespuesta(response);
    } catch (e) {
      throw _manejarError(e);
    }
  }

  /// Realiza una petición POST
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/$endpoint');
      final response = await _client
          .post(
            url,
            headers: {'Content-Type': 'application/json', ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(AppConstants.connectionTimeout);

      return _procesarRespuesta(response);
    } catch (e) {
      throw _manejarError(e);
    }
  }

  /// Realiza una petición PUT
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/$endpoint');
      final response = await _client
          .put(
            url,
            headers: {'Content-Type': 'application/json', ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(AppConstants.connectionTimeout);

      return _procesarRespuesta(response);
    } catch (e) {
      throw _manejarError(e);
    }
  }

  /// Realiza una petición DELETE
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/$endpoint');
      final response = await _client
          .delete(url, headers: headers)
          .timeout(AppConstants.connectionTimeout);

      return _procesarRespuesta(response);
    } catch (e) {
      throw _manejarError(e);
    }
  }

  /// Procesa la respuesta HTTP
  dynamic _procesarRespuesta(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) return null;
        return jsonDecode(response.body);
      case 204:
        return null;
      case 400:
        throw Exception('Solicitud inválida');
      case 401:
        throw Exception('No autorizado');
      case 403:
        throw Exception('Acceso prohibido');
      case 404:
        throw Exception('Recurso no encontrado');
      case 500:
        throw Exception('Error del servidor');
      default:
        throw Exception('Error HTTP ${response.statusCode}');
    }
  }

  /// Maneja los errores de las peticiones
  Exception _manejarError(dynamic error) {
    if (error is Exception) {
      return error;
    }
    return Exception('Error de conexión: $error');
  }

  /// Cierra el cliente HTTP
  void dispose() {
    _client.close();
  }
}
