import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/campeon_mundial.dart';

/// Servicio para obtener datos de F1 desde internet
/// Utiliza Jolpi.ca API - Mirror estable y confiable de Ergast
/// Documentación: https://api.jolpi.ca/ergast/
class F1ApiService {
  static const String baseUrl = 'https://api.jolpi.ca/ergast/f1';
  final http.Client _client;

  F1ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Obtiene todos los campeones mundiales de F1
  /// Desde 1950 hasta la actualidad
  Future<List<CampeonMundial>> obtenerTodosCampeones() async {
    try {
      debugPrint('📡 Obteniendo campeones desde Jolpi.ca API...');
      final campeones = <CampeonMundial>[];

      // Obtener campeones en lotes paralelos para mayor velocidad
      const batchSize = 10;
      for (int startYear = 1950; startYear <= 2024; startYear += batchSize) {
        final endYear = (startYear + batchSize - 1).clamp(1950, 2024);
        final futures = <Future<CampeonMundial?>>[];

        for (int year = startYear; year <= endYear; year++) {
          futures.add(_obtenerCampeonPorAnio(year));
        }

        final results = await Future.wait(futures);
        for (final campeon in results) {
          if (campeon != null) {
            campeones.add(campeon);
          }
        }

        debugPrint(
          '✓ Procesados años $startYear-$endYear (${campeones.length} campeones)',
        );
      }

      debugPrint('🏆 Total campeones cargados: ${campeones.length}');
      return campeones;
    } catch (e) {
      debugPrint('❌ Error al obtener campeones: $e');
      throw Exception('Error al cargar datos de campeones: $e');
    }
  }

  /// Método interno para obtener campeón de un año
  Future<CampeonMundial?> _obtenerCampeonPorAnio(int year) async {
    int intentos = 0;
    const maxIntentos = 3;

    while (intentos < maxIntentos) {
      try {
        final url = Uri.parse('$baseUrl/$year/driverStandings/1');
        final response = await _client
            .get(url)
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final mrData = data['MRData'] as Map<String, dynamic>;
          final standingsTable =
              mrData['StandingsTable'] as Map<String, dynamic>;
          final standingsLists =
              standingsTable['StandingsLists'] as List<dynamic>;

          if (standingsLists.isNotEmpty) {
            final standings = standingsLists[0] as Map<String, dynamic>;
            final season = standings['season'] as String;
            final driverStandings =
                standings['DriverStandings'] as List<dynamic>;

            if (driverStandings.isNotEmpty) {
              final campeon = CampeonMundial.fromErgastJson(
                driverStandings[0] as Map<String, dynamic>,
                season,
              );
              debugPrint('  ✓ $year: ${campeon.nombreCompleto}');
              return campeon;
            }
          }
        }
        return null;
      } catch (e) {
        intentos++;
        if (intentos >= maxIntentos) {
          debugPrint(
            '  ❌ Error en año $year después de $maxIntentos intentos: $e',
          );
          return null;
        }
        debugPrint('  ⚠️  Reintentando año $year (intento $intentos)...');
        await Future.delayed(Duration(milliseconds: 100 * intentos));
      }
    }
    return null;
  }

  /// Obtiene el campeón de un año específico
  Future<CampeonMundial?> obtenerCampeonPorAnio(int year) async {
    return await _obtenerCampeonPorAnio(year);
  }

  void dispose() {
    _client.close();
  }
}
