import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/piloto.dart';

/// Repositorio abstracto para operaciones de datos de pilotos
abstract class PilotoRepository {
  Future<List<Piloto>> obtenerTodos();
  Future<Piloto?> obtenerPorId(String id);
  Future<List<Piloto>> obtenerPorEquipo(String equipoId);
  Future<void> agregar(Piloto piloto);
  Future<void> actualizar(Piloto piloto);
  Future<void> eliminar(String id);
}

/// Implementación del repositorio de pilotos con datos dinámicos desde la API
class PilotoRepositoryImpl implements PilotoRepository {
  static const String ergastBaseUrl = 'https://api.jolpi.ca/ergast/f1';
  static const String openF1BaseUrl = 'https://api.openf1.org/v1';
  final http.Client _client = http.Client();

  List<Piloto> _pilotosCache = [];
  DateTime? _ultimaActualizacion;

  @override
  Future<List<Piloto>> obtenerTodos() async {
    // Si tenemos cache y es de hace menos de 5 minutos, usarlo
    if (_pilotosCache.isNotEmpty &&
        _ultimaActualizacion != null &&
        DateTime.now().difference(_ultimaActualizacion!) <
            const Duration(minutes: 5)) {
      debugPrint('📦 Usando cache de pilotos');
      return List.unmodifiable(_pilotosCache);
    }

    debugPrint('🏎️ Cargando pilotos actuales desde API...');

    try {
      final currentYear = DateTime.now().year;

      // Primero obtener la lista de pilotos
      final driversResponse = await _client
          .get(Uri.parse('$ergastBaseUrl/$currentYear/drivers.json?limit=50'))
          .timeout(const Duration(seconds: 10));

      if (driversResponse.statusCode != 200) {
        debugPrint('⚠️ No se pudieron cargar pilotos desde API');
        return _pilotosCache.isNotEmpty ? List.unmodifiable(_pilotosCache) : [];
      }

      final driversData = json.decode(driversResponse.body);
      final drivers = driversData['MRData']['DriverTable']['Drivers'] as List?;

      if (drivers == null || drivers.isEmpty) {
        debugPrint('⚠️ No hay pilotos disponibles');
        return [];
      }

      // Ahora obtener los puntos del campeonato actual
      final standingsResponse = await _client
          .get(
            Uri.parse(
              '$ergastBaseUrl/$currentYear/driverStandings.json?limit=50',
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
          final driverStandings = standings[0]['DriverStandings'] as List?;
          if (driverStandings != null) {
            for (var standing in driverStandings) {
              final driverId = standing['Driver']['driverId'] as String;
              final points = int.tryParse(standing['points'] as String) ?? 0;
              puntosMap[driverId] = points;
            }
          }
        }
      }

      // Crear lista de pilotos con puntos
      _pilotosCache = drivers.map((driver) {
        final driverId = driver['driverId'] as String;
        return Piloto(
          id: driverId,
          nombre: driver['givenName'] as String,
          apellido: driver['familyName'] as String,
          numero: driver['permanentNumber']?.toString() ?? 'N/A',
          nacionalidad: driver['nationality'] as String,
          fechaNacimiento: driver['dateOfBirth'] as String? ?? 'N/A',
          equipoId: driver['code'] as String? ?? '',
          puntos: puntosMap[driverId] ?? 0,
        );
      }).toList();

      // Ordenar por puntos (de mayor a menor)
      _pilotosCache.sort((a, b) => b.puntos.compareTo(a.puntos));

      _ultimaActualizacion = DateTime.now();
      debugPrint('✅ ${_pilotosCache.length} pilotos cargados con puntuación');
      return List.unmodifiable(_pilotosCache);
    } catch (e) {
      debugPrint('❌ Error al cargar pilotos: $e');
      return _pilotosCache.isNotEmpty ? List.unmodifiable(_pilotosCache) : [];
    }
  }

  @override
  Future<Piloto?> obtenerPorId(String id) async {
    // Asegurar que tenemos datos
    if (_pilotosCache.isEmpty) {
      await obtenerTodos();
    }

    try {
      return _pilotosCache.firstWhere((piloto) => piloto.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Piloto>> obtenerPorEquipo(String equipoId) async {
    // Asegurar que tenemos datos
    if (_pilotosCache.isEmpty) {
      await obtenerTodos();
    }

    return _pilotosCache
        .where((piloto) => piloto.equipoId == equipoId)
        .toList();
  }

  @override
  Future<void> agregar(Piloto piloto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _pilotosCache.add(piloto);
  }

  @override
  Future<void> actualizar(Piloto piloto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _pilotosCache.indexWhere((p) => p.id == piloto.id);
    if (index != -1) {
      _pilotosCache[index] = piloto;
    }
  }

  @override
  Future<void> eliminar(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _pilotosCache.removeWhere((piloto) => piloto.id == id);
  }
}
