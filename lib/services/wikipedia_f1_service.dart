import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/campeon_mundial.dart';

/// Servicio para obtener datos históricos completos de F1
/// Datos obtenidos dinámicamente desde F1 API
class WikipediaF1Service {
  static const String championsApiUrl =
      'https://f1-api-one.vercel.app/api/champions';
  final http.Client _client;

  List<CampeonMundial> _campeonesCache = [];
  DateTime? _ultimaActualizacion;

  WikipediaF1Service({http.Client? client}) : _client = client ?? http.Client();

  /// Obtiene todos los campeones mundiales dinámicamente desde la API
  Future<List<CampeonMundial>> obtenerTodosCampeones() async {
    // Si tenemos cache y es de hace menos de 5 minutos, usarlo
    if (_campeonesCache.isNotEmpty &&
        _ultimaActualizacion != null &&
        DateTime.now().difference(_ultimaActualizacion!) <
            const Duration(minutes: 5)) {
      debugPrint('📦 Usando cache de campeones');
      return List.from(_campeonesCache);
    }

    debugPrint('🏆 Cargando campeones desde API dinámica...');

    try {
      final response = await _client
          .get(Uri.parse(championsApiUrl))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        debugPrint('⚠️ No se pudieron cargar campeones desde API');
        return _campeonesCache.isNotEmpty ? List.from(_campeonesCache) : [];
      }

      final data = json.decode(response.body);
      final championsData = data['data'] as List?;

      if (championsData == null || championsData.isEmpty) {
        debugPrint('⚠️ No hay campeones disponibles');
        return [];
      }

      // Crear lista de campeones
      _campeonesCache = championsData.map((champion) {
        final nombre = champion['nombre'] as String? ?? '';
        final apellido = champion['apellido'] as String? ?? '';
        final equipo = champion['equipo'] as String? ?? 'Unknown';

        return CampeonMundial(
          temporada: champion['year'].toString(),
          nombre: nombre,
          apellido: apellido,
          nacionalidad: champion['pais'] as String? ?? 'Unknown',
          puntos: champion['puntos'] as int? ?? 0,
          victorias: champion['victorias'] as int? ?? 0,
          equipoId: equipo.toLowerCase().replaceAll(' ', '_'),
          equipoNombre: equipo,
        );
      }).toList();

      // Ordenar por temporada (descendente)
      _campeonesCache.sort((a, b) => b.temporada.compareTo(a.temporada));

      _ultimaActualizacion = DateTime.now();
      debugPrint(
        '✅ ${_campeonesCache.length} campeones cargados desde API dinámica',
      );

      return List.from(_campeonesCache);
    } catch (e) {
      debugPrint('❌ Error al cargar campeones: $e');
      return _campeonesCache.isNotEmpty ? List.from(_campeonesCache) : [];
    }
  }

  /// Obtiene campeones ordenados por edad al ganar su primer título
  Future<List<Map<String, dynamic>>> obtenerCampeonesPorEdad() async {
    debugPrint('🏆 Cargando campeones por edad desde API...');

    try {
      final response = await _client
          .get(Uri.parse('$championsApiUrl/por-edad'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        debugPrint('⚠️ No se pudieron cargar campeones por edad');
        return [];
      }

      final data = json.decode(response.body);
      final championsData = data['data'] as List?;

      if (championsData == null || championsData.isEmpty) {
        debugPrint('⚠️ No hay campeones por edad disponibles');
        return [];
      }

      final resultado = championsData.map((champion) {
        final edadCompleta = champion['edad'] as String? ?? '';
        // Extraer solo el número de años (ej: "23 años, 134 días" -> 23)
        final edadMatch = RegExp(r'(\d+)\s*años').firstMatch(edadCompleta);
        final edad = edadMatch != null ? int.parse(edadMatch.group(1)!) : 30;

        return {
          'nombre': champion['nombre'] as String? ?? '',
          'edad': edad,
          'año': champion['año'] ?? 0,
          'edadCompleta': edadCompleta,
        };
      }).toList();

      // Ordenar de más joven a más viejo
      resultado.sort((a, b) => (a['edad'] as int).compareTo(b['edad'] as int));

      debugPrint(
        '✅ ${resultado.length} campeones por edad cargados (ordenados de más joven a mayor)',
      );
      return resultado;
    } catch (e) {
      debugPrint('❌ Error al cargar campeones por edad: $e');
      return [];
    }
  }

  /// Obtiene las temporadas que cada campeón compitió antes de su primer título
  Future<Map<String, int>> obtenerTemporadasAntes() async {
    debugPrint('🏆 Cargando temporadas antes del primer título desde API...');

    try {
      final response = await _client
          .get(Uri.parse('$championsApiUrl/temporadas-antes'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        debugPrint('⚠️ No se pudieron cargar temporadas antes');
        return {};
      }

      final data = json.decode(response.body);
      final temporadasData = data['data'] as List?;

      if (temporadasData == null || temporadasData.isEmpty) {
        debugPrint('⚠️ No hay temporadas antes disponibles');
        return {};
      }

      final Map<String, int> resultado = {};

      for (var item in temporadasData) {
        final piloto = item['piloto'] as String? ?? '';
        final temporadas = item['temporadas_antes_campeón'] as int? ?? 0;

        if (piloto.isNotEmpty) {
          resultado[piloto] = temporadas;
        }
      }

      debugPrint(
        '✅ ${resultado.length} pilotos con temporadas antes cargados desde API',
      );
      return resultado;
    } catch (e) {
      debugPrint('❌ Error al cargar temporadas antes: $e');
      return {};
    }
  }

  void dispose() {
    _client.close();
  }
}
