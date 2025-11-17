import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/equipo.dart';

/// Repositorio abstracto para operaciones de datos de equipos
abstract class EquipoRepository {
  Future<List<Equipo>> obtenerTodos();
  Future<Equipo?> obtenerPorId(String id);
  Future<void> agregar(Equipo equipo);
  Future<void> actualizar(Equipo equipo);
  Future<void> eliminar(String id);
}

/// Implementación del repositorio de equipos con datos dinámicos desde la API
class EquipoRepositoryImpl implements EquipoRepository {
  static const String ergastBaseUrl = 'https://api.jolpi.ca/ergast/f1';
  static const String openF1BaseUrl = 'https://api.openf1.org/v1';
  final http.Client _client = http.Client();

  List<Equipo> _equiposCache = [];
  DateTime? _ultimaActualizacion;

  @override
  Future<List<Equipo>> obtenerTodos() async {
    // Si tenemos cache y es de hace menos de 5 minutos, usarlo
    if (_equiposCache.isNotEmpty &&
        _ultimaActualizacion != null &&
        DateTime.now().difference(_ultimaActualizacion!) <
            const Duration(minutes: 5)) {
      debugPrint('📦 Usando cache de equipos');
      return List.unmodifiable(_equiposCache);
    }

    debugPrint('🏁 Cargando equipos actuales desde API...');

    try {
      final currentYear = DateTime.now().year;

      // Primero obtener la lista de constructores
      final constructorsResponse = await _client
          .get(
            Uri.parse('$ergastBaseUrl/$currentYear/constructors.json?limit=50'),
          )
          .timeout(const Duration(seconds: 10));

      if (constructorsResponse.statusCode != 200) {
        debugPrint('⚠️ No se pudieron cargar equipos desde API');
        return _equiposCache.isNotEmpty ? List.unmodifiable(_equiposCache) : [];
      }

      final constructorsData = json.decode(constructorsResponse.body);
      final constructors =
          constructorsData['MRData']['ConstructorTable']['Constructors']
              as List?;

      if (constructors == null || constructors.isEmpty) {
        debugPrint('⚠️ No hay equipos disponibles');
        return [];
      }

      // Ahora obtener los puntos del campeonato de constructores actual
      final standingsResponse = await _client
          .get(
            Uri.parse(
              '$ergastBaseUrl/$currentYear/constructorStandings.json?limit=50',
            ),
          )
          .timeout(const Duration(seconds: 10));

      Map<String, int> puntosMap = {};

      if (standingsResponse.statusCode == 200) {
        final standingsData = json.decode(standingsResponse.body);
        final standings =
            standingsData['MRData']['StandingsTable']['StandingsLists']
                as List?;

        if (standings != null && standings.isNotEmpty) {
          final constructorStandings =
              standings[0]['ConstructorStandings'] as List?;
          if (constructorStandings != null) {
            for (var standing in constructorStandings) {
              final constructorId =
                  standing['Constructor']['constructorId'] as String;
              final points = int.tryParse(standing['points'] as String) ?? 0;
              puntosMap[constructorId] = points;
            }
          }
        }
      }

      // Campeonatos de constructores históricos (datos verificados)
      final campeonatosHistoricos = {
        'ferrari': 16,
        'williams': 9,
        'mclaren': 8,
        'mercedes': 8,
        'lotus': 7,
        'red_bull': 6,
        'brabham': 2,
        'renault': 2,
        'cooper': 2,
        'vanwall': 1,
        'brm': 1,
        'matra': 1,
        'tyrrell': 1,
        'benetton': 1,
        'brawn': 1,
        'alpha_tauri': 0,
        'alphatauri': 0,
        'aston_martin': 0,
        'haas': 0,
        'sauber': 0,
        'kick_sauber': 0,
        'alpine': 0,
        'alfa': 0,
      };

      // Mapeo de nacionalidades
      final paisesMap = {
        'Italian': 'Italia',
        'British': 'Reino Unido',
        'German': 'Alemania',
        'Austrian': 'Austria',
        'French': 'Francia',
        'Swiss': 'Suiza',
        'American': 'Estados Unidos',
        'Japanese': 'Japón',
        'Indian': 'India',
      };

      // Crear lista de equipos con puntos
      _equiposCache = constructors.map((constructor) {
        final constructorId = constructor['constructorId'] as String;
        final nationality = constructor['nationality'] as String;

        return Equipo(
          id: constructorId,
          nombre: constructor['name'] as String,
          pais: paisesMap[nationality] ?? nationality,
          colorPrincipal: '#${_getColorForTeam(constructorId)}',
          anioFundacion: 1950, // API no provee este dato
          campeonatosGanados: campeonatosHistoricos[constructorId] ?? 0,
          puntos: puntosMap[constructorId] ?? 0,
        );
      }).toList();

      // Ordenar por puntos (de mayor a menor)
      _equiposCache.sort((a, b) => b.puntos.compareTo(a.puntos));

      _ultimaActualizacion = DateTime.now();
      debugPrint('✅ ${_equiposCache.length} equipos cargados con puntuación');
      return List.unmodifiable(_equiposCache);
    } catch (e) {
      debugPrint('❌ Error al cargar equipos: $e');
      return _equiposCache.isNotEmpty ? List.unmodifiable(_equiposCache) : [];
    }
  }

  /// Obtiene un color representativo para cada equipo
  String _getColorForTeam(String constructorId) {
    final colores = {
      'red_bull': '0600EF',
      'mercedes': '00D2BE',
      'ferrari': 'DC0000',
      'mclaren': 'FF8700',
      'aston_martin': '006F62',
      'alpine': '0090FF',
      'williams': '005AFF',
      'alphatauri': '2B4562',
      'alfa': '900000',
      'haas': 'FFFFFF',
      'sauber': '52E252',
      'kick_sauber': '52E252',
    };
    return colores[constructorId] ?? '808080';
  }

  @override
  Future<Equipo?> obtenerPorId(String id) async {
    // Asegurar que tenemos datos
    if (_equiposCache.isEmpty) {
      await obtenerTodos();
    }

    try {
      return _equiposCache.firstWhere((equipo) => equipo.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> agregar(Equipo equipo) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _equiposCache.add(equipo);
  }

  @override
  Future<void> actualizar(Equipo equipo) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _equiposCache.indexWhere((e) => e.id == equipo.id);
    if (index != -1) {
      _equiposCache[index] = equipo;
    }
  }

  @override
  Future<void> eliminar(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _equiposCache.removeWhere((equipo) => equipo.id == id);
  }
}
