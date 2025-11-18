import 'package:http/http.dart' as http;
import 'dart:convert';

class VictoriasService {
  Future<List<Map<String, dynamic>>> obtenerVictoriasPorPiloto() async {
    // Importar http y dart:convert si no están
    // import 'package:http/http.dart' as http;
    // import 'dart:convert';
    final uri = Uri.parse('https://f1-api-one.vercel.app/api/victorias');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Asegurarse que cada elemento sea Map<String, dynamic>
      return data
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();
    } else {
      throw Exception('Error al obtener victorias: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerVictoriasEnUnAnio() async {
    final uri = Uri.parse(
      'https://f1-api-one.vercel.app/api/victorias/en-un-anio',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final List<dynamic> data = jsonMap['data'] ?? [];
      // Ordenar de mayor a menor por victorias
      data.sort(
        (a, b) => (b['victorias'] as int).compareTo(a['victorias'] as int),
      );
      return data.map<Map<String, dynamic>>((e) {
        return {
          'piloto': (e['piloto'] ?? '').toString(),
          'pais': (e['pais'] ?? ''),
          'temporada': e['temporada'] is int
              ? e['temporada']
              : int.tryParse(e['temporada']?.toString() ?? '') ?? 0,
          'victorias': e['victorias'] is int
              ? e['victorias']
              : int.tryParse(e['victorias']?.toString() ?? '') ?? 0,
          'carreras_totales': e['carreras_totales'] is int
              ? e['carreras_totales']
              : int.tryParse(e['carreras_totales']?.toString() ?? '') ?? 0,
          'porcentaje': e['porcentaje'] is num
              ? e['porcentaje']
              : double.tryParse(e['porcentaje']?.toString() ?? '') ?? 0.0,
        };
      }).toList();
    } else {
      throw Exception(
        'Error al obtener victorias en un año: ${response.statusCode}',
      );
    }
  }

  Future<List<Map<String, dynamic>>>
  obtenerPilotosPorAniosConVictorias() async {
    final uri = Uri.parse(
      'https://f1-api-one.vercel.app/api/victorias/numeros-anios',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final List<dynamic> data = jsonMap['data'] ?? [];
      // Ordenar de mayor a menor por años
      data.sort((a, b) => (b['anios'] as int).compareTo(a['anios'] as int));
      return data.map<Map<String, dynamic>>((e) {
        return {
          'nombre': (e['nombre'] ?? '').toString(),
          'anios': e['anios'] is int
              ? e['anios']
              : int.tryParse(e['anios']?.toString() ?? '') ?? 0,
        };
      }).toList();
    } else {
      throw Exception(
        'Error al obtener años con victorias: [response.statusCode]',
      );
    }
  }

  Future<List<Map<String, dynamic>>> obtenerCarrerasAntesDeVictoria() async {
    final uri = Uri.parse(
      'https://f1-api-one.vercel.app/api/victorias/gp-antes-victoria',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final List<dynamic> data = jsonMap['data'] ?? [];
      return data.map<Map<String, dynamic>>((e) {
        return {
          'nombre': (e['nombre'] ?? '').toString(),
          'carreras': e['carreras'] is int
              ? e['carreras']
              : int.tryParse(e['carreras']?.toString() ?? '') ?? 0,
          'gp': (e['gp'] ?? '').toString(),
          'anio': e['anio'] is int
              ? e['anio']
              : int.tryParse(e['anio']?.toString() ?? '') ?? 0,
        };
      }).toList();
    } else {
      throw Exception(
        'Error al obtener carreras antes de victoria: ${response.statusCode}',
      );
    }
  }

  Future<List<Map<String, dynamic>>> obtenerVictoriasSinPole() async {
    final uri = Uri.parse(
      'https://f1-api-one.vercel.app/api/victorias/victoria-sin-pole',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final List<dynamic> data = jsonMap['data'] ?? [];
      // Ordenar por el número de victorias (de mayor a menor) usando el campo 'victoria' de la API
      data.sort((a, b) {
        final intA = a['victoria'] is int
            ? a['victoria']
            : int.tryParse(a['victoria']?.toString() ?? '') ?? 0;
        final intB = b['victoria'] is int
            ? b['victoria']
            : int.tryParse(b['victoria']?.toString() ?? '') ?? 0;
        return intB.compareTo(intA);
      });
      return data.map<Map<String, dynamic>>((e) {
        return {
          'nombre': (e['nombre'] ?? '').toString(),
          'victoria': (e['victoria'] ?? '').toString(),
          'porcentaje': e['porcentaje'] is num
              ? e['porcentaje'].toDouble()
              : double.tryParse(e['porcentaje']?.toString() ?? '') ?? 0.0,
        };
      }).toList();
    } else {
      throw Exception(
        'Error al obtener victorias sin pole: ${response.statusCode}',
      );
    }
  }

  Future<List<Map<String, dynamic>>> obtenerVictoriasConVueltaRapida() async {
    final uri = Uri.parse(
      'https://f1-api-one.vercel.app/api/victorias/victoria-vuelta-fast',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final List<dynamic> data = jsonMap['data'] ?? [];
      return data.map<Map<String, dynamic>>((e) {
        return {
          'nombre': (e['nombre'] ?? '').toString(),
          'victoria': (e['victoria'] ?? '').toString(),
          'vuelta_rapida': e['vuelta_rapida'] == true,
        };
      }).toList();
    } else {
      throw Exception(
        'Error al obtener victorias con vuelta rápida: ${response.statusCode}',
      );
    }
  }

  Future<List<Map<String, dynamic>>> obtenerVictoriasConsecutivas() async {
    final uri = Uri.parse(
      'https://f1-api-one.vercel.app/api/victorias-consecutivas',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final List<dynamic> data = jsonMap['data'] ?? [];
      return data.map<Map<String, dynamic>>((e) {
        final map = Map<String, dynamic>.from(e);
        map['piloto'] = map['Piloto'] ?? '';
        return map;
      }).toList();
    } else {
      throw Exception(
        'Error al obtener victorias consecutivas: ${response.statusCode}',
      );
    }
  }

  Future<List<Map<String, dynamic>>>
  obtenerAniosConsecutivosConVictorias() async {
    final uri = Uri.parse(
      'https://f1-api-one.vercel.app/api/victorias/annee-consecutive',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final List<dynamic> data = jsonMap['data'] ?? [];
      return data.map<Map<String, dynamic>>((e) {
        return {
          'nombre': (e['nombre'] ?? '').toString(),
          'anios': e['anios_consecutivos'] is int
              ? e['anios_consecutivos']
              : int.tryParse(e['anios_consecutivos']?.toString() ?? '') ?? 0,
          'inicio': e['inicio'] is int
              ? e['inicio'].toString()
              : (e['inicio'] ?? '').toString(),
          'fin': e['fin'] is int
              ? e['fin'].toString()
              : (e['fin'] ?? '').toString(),
        };
      }).toList();
    } else {
      throw Exception(
        'Error al obtener años consecutivos con victorias: ${response.statusCode}',
      );
    }
  }

  Future<List<Map<String, dynamic>>> obtenerVictoriasPorEquipo() async {
    return [];
  }

  Future<List<Map<String, dynamic>>> obtenerVictoriasPorPais() async {
    return [];
  }
}
