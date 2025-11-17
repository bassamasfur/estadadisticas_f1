import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/carrera.dart';

/// Repositorio abstracto para operaciones de datos de carreras
abstract class CarreraRepository {
  Future<List<Carrera>> obtenerTodas();
  Future<Carrera?> obtenerPorId(String id);
  Future<List<Carrera>> obtenerPorAnio(int anio);
  Future<void> agregar(Carrera carrera);
  Future<void> actualizar(Carrera carrera);
  Future<void> eliminar(String id);
}

/// Implementación del repositorio de carreras con datos dinámicos desde la API
class CarreraRepositoryImpl implements CarreraRepository {
  static const String ergastBaseUrl = 'https://api.jolpi.ca/ergast/f1';
  static const String openF1BaseUrl = 'https://api.openf1.org/v1';
  final http.Client _client = http.Client();

  List<Carrera> _carrerasCache = [];
  DateTime? _ultimaActualizacion;

  @override
  Future<List<Carrera>> obtenerTodas() async {
    // Si tenemos cache y es de hace menos de 5 minutos, usarlo
    if (_carrerasCache.isNotEmpty &&
        _ultimaActualizacion != null &&
        DateTime.now().difference(_ultimaActualizacion!) <
            const Duration(minutes: 5)) {
      debugPrint('📦 Usando cache de carreras');
      return List.from(_carrerasCache);
    }

    debugPrint('🏁 Cargando carreras actuales desde API...');

    try {
      final currentYear = DateTime.now().year;

      // Primero obtener el calendario completo de la temporada
      final scheduleResponse = await _client
          .get(Uri.parse('$ergastBaseUrl/$currentYear.json'))
          .timeout(const Duration(seconds: 15));

      if (scheduleResponse.statusCode != 200) {
        debugPrint('⚠️ No se pudieron cargar carreras desde API');
        return _carrerasCache.isNotEmpty ? List.from(_carrerasCache) : [];
      }

      final scheduleData = json.decode(scheduleResponse.body);
      final races = scheduleData['MRData']['RaceTable']['Races'] as List?;

      if (races == null || races.isEmpty) {
        debugPrint('⚠️ No hay carreras disponibles');
        return [];
      }

      // Luego obtener resultados para las carreras completadas
      Map<String, Map<String, String>> winners = {};
      try {
        // Intentar obtener todos los resultados del año
        final resultsResponse = await _client
            .get(
              Uri.parse('$ergastBaseUrl/$currentYear/results/1.json?limit=30'),
            )
            .timeout(const Duration(seconds: 10));

        if (resultsResponse.statusCode == 200) {
          final resultsData = json.decode(resultsResponse.body);
          final raceResults =
              resultsData['MRData']['RaceTable']['Races'] as List?;

          if (raceResults != null) {
            debugPrint(
              '📊 Procesando ${raceResults.length} carreras con resultados',
            );
            for (var race in raceResults) {
              final round = race['round'] as String;
              final raceName = race['raceName'] as String;
              final results = race['Results'] as List?;
              if (results != null && results.isNotEmpty) {
                final winner = results[0];
                final driverName = winner['Driver']['givenName'] as String;
                final driverSurname = winner['Driver']['familyName'] as String;
                final constructorName = winner['Constructor']['name'] as String;
                final winnerFullName = '$driverName $driverSurname';
                winners[round] = {
                  'ganador': winnerFullName,
                  'equipo': constructorName,
                };
                debugPrint(
                  '🏆 Carrera $round ($raceName): $winnerFullName - $constructorName',
                );
              }
            }
            debugPrint('✅ Total ganadores registrados: ${winners.length}');
          }
        }
      } catch (e) {
        debugPrint('⚠️ No se pudieron cargar resultados: $e');
      }

      // Crear lista de carreras con información completa
      _carrerasCache = races.map((race) {
        final round = race['round'] as String;
        final raceDate = DateTime.parse(
          '${race['date']} ${race['time'] ?? '00:00:00Z'}',
        );

        // Obtener ganador si existe
        final winnerInfo = winners[round];

        // Obtener información del circuito
        final circuit = race['Circuit'];
        final circuitId = circuit['circuitId'] as String;

        // Mapa de información de circuitos (vueltas y longitud)
        final circuitInfo = _getCircuitInfo(circuitId);

        return Carrera(
          id: round,
          nombre: race['raceName'] as String,
          circuito: circuit['circuitName'] as String,
          pais: circuit['Location']['country'] as String,
          fecha: raceDate,
          numeroVueltas: circuitInfo['laps'] ?? 0,
          longitudCircuito: circuitInfo['length'] ?? 0.0,
          ganador: winnerInfo?['ganador'],
          equipoGanador: winnerInfo?['equipo'],
        );
      }).toList();

      // Ordenar por fecha
      _carrerasCache.sort((a, b) => a.fecha.compareTo(b.fecha));

      _ultimaActualizacion = DateTime.now();
      debugPrint('✅ ${_carrerasCache.length} carreras cargadas con resultados');
      return List.from(_carrerasCache);
    } catch (e) {
      debugPrint('❌ Error al cargar carreras: $e');
      return _carrerasCache.isNotEmpty ? List.from(_carrerasCache) : [];
    }
  }

  /// Obtiene información específica de cada circuito (vueltas y longitud en km)
  Map<String, dynamic> _getCircuitInfo(String circuitId) {
    final circuits = {
      'albert_park': {'laps': 58, 'length': 5.278},
      'bahrain': {'laps': 57, 'length': 5.412},
      'jeddah': {'laps': 50, 'length': 6.174},
      'shanghai': {'laps': 56, 'length': 5.451},
      'miami': {'laps': 57, 'length': 5.412},
      'imola': {'laps': 63, 'length': 4.909},
      'monaco': {'laps': 78, 'length': 3.337},
      'catalunya': {'laps': 66, 'length': 4.675},
      'villeneuve': {'laps': 70, 'length': 4.361},
      'red_bull_ring': {'laps': 71, 'length': 4.318},
      'silverstone': {'laps': 52, 'length': 5.891},
      'hungaroring': {'laps': 70, 'length': 4.381},
      'spa': {'laps': 44, 'length': 7.004},
      'zandvoort': {'laps': 72, 'length': 4.259},
      'monza': {'laps': 53, 'length': 5.793},
      'baku': {'laps': 51, 'length': 6.003},
      'marina_bay': {'laps': 62, 'length': 4.940},
      'americas': {'laps': 56, 'length': 5.513},
      'rodriguez': {'laps': 71, 'length': 4.304},
      'interlagos': {'laps': 71, 'length': 4.309},
      'vegas': {'laps': 50, 'length': 6.120},
      'losail': {'laps': 57, 'length': 5.380},
      'yas_marina': {'laps': 58, 'length': 5.281},
    };

    return circuits[circuitId] ?? {'laps': 0, 'length': 0.0};
  }

  @override
  Future<Carrera?> obtenerPorId(String id) async {
    // Asegurar que tenemos datos
    if (_carrerasCache.isEmpty) {
      await obtenerTodas();
    }

    try {
      return _carrerasCache.firstWhere((carrera) => carrera.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Carrera>> obtenerPorAnio(int anio) async {
    // Asegurar que tenemos datos
    if (_carrerasCache.isEmpty) {
      await obtenerTodas();
    }

    return _carrerasCache
        .where((carrera) => carrera.fecha.year == anio)
        .toList();
  }

  @override
  Future<void> agregar(Carrera carrera) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _carrerasCache.add(carrera);
  }

  @override
  Future<void> actualizar(Carrera carrera) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _carrerasCache.indexWhere((c) => c.id == carrera.id);
    if (index != -1) {
      _carrerasCache[index] = carrera;
    }
  }

  @override
  Future<void> eliminar(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _carrerasCache.removeWhere((carrera) => carrera.id == id);
  }
}
