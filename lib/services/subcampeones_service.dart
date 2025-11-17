import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Servicio para obtener datos de subcampeones (segundo lugar) en F1
/// Obtiene datos dinámicamente desde la API de F1
class SubcampeonesService {
  static const String _apiUrl = 'https://f1-api-one.vercel.app/api/champions/podio-historico';
  final http.Client _client = http.Client();

  /// Obtiene los datos históricos de subcampeones por temporada desde la API
  Future<Map<String, Map<String, dynamic>>>
  obtenerSubcampeonesPorTemporada() async {
    debugPrint(' Cargando subcampeones desde API...');

    try {
      final response = await _client.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final podios = data['data'] as List;

        // Convertir a formato Map<año, datos_subcampeon>
        final Map<String, Map<String, dynamic>> subcampeones = {};

        for (var podio in podios) {
          final anio = podio['año'].toString();
          final subcampeonNombre = podio['subcampeon'] as String;
          
          // Separar nombre y apellido
          final partes = subcampeonNombre.split(' ');
          final apellido = partes.isNotEmpty ? partes.last : '';
          final nombre = partes.length > 1 
              ? partes.sublist(0, partes.length - 1).join(' ') 
              : subcampeonNombre;

          subcampeones[anio] = {
            'nombre': nombre,
            'apellido': apellido,
            'pais': _obtenerPaisDelPiloto(subcampeonNombre),
          };
        }

        debugPrint(' 10{subcampeones.length} subcampeones cargados desde API');
        return subcampeones;
      } else {
        throw Exception('Error al cargar subcampeones: 10{response.statusCode}');
      }
    } catch (e) {
      debugPrint(' Error al obtener subcampeones: 10e');
      rethrow;
    }
  }

  /// Obtiene el país del piloto basándose en su nombre
  /// En el futuro se puede mejorar consultando otra API
  String _obtenerPaisDelPiloto(String nombreCompleto) {
    // Por ahora retornamos un valor genérico
    // La API no proporciona el país del subcampeón
    return 'Unknown';
  }
}
