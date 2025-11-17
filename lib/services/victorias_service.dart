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
    return [
      {
        'piloto': 'Max Verstappen',
        'pais': 'Netherlands',
        'victorias': 19,
        'temporada': 2023,
        'carreras_totales': 22,
      },
    ];
  }

  Future<List<Map<String, dynamic>>>
  obtenerPilotosPorAniosConVictorias() async {
    return [
      {
        'nombre': 'Lewis',
        'apellido': 'Hamilton',
        'pais': 'United Kingdom',
        'anios': 16,
      },
    ];
  }

  Future<List<Map<String, dynamic>>> obtenerCarrerasAntesDeVictoria() async {
    return [
      {
        'nombre': 'Sergio',
        'apellido': 'Pérez',
        'pais': 'Mexico',
        'carreras': 190,
      },
    ];
  }

  Future<List<Map<String, dynamic>>> obtenerVictoriasSinPole() async {
    return [
      {
        'nombre': 'Fernando',
        'apellido': 'Alonso',
        'pais': 'Spain',
        'victoria': 'Hungría 2003',
        'pole': false,
      },
      {
        'nombre': 'Jenson',
        'apellido': 'Button',
        'pais': 'United Kingdom',
        'victoria': 'Hungría 2006',
        'pole': false,
      },
    ];
  }

  Future<List<Map<String, dynamic>>> obtenerVictoriasConVueltaRapida() async {
    return [
      {
        'nombre': 'Lewis',
        'apellido': 'Hamilton',
        'pais': 'United Kingdom',
        'victoria': 'Gran Bretaña 2020',
        'vuelta_rapida': true,
      },
      {
        'nombre': 'Max',
        'apellido': 'Verstappen',
        'pais': 'Netherlands',
        'victoria': 'Austria 2021',
        'vuelta_rapida': true,
      },
    ];
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
    return [
      {
        'nombre': 'Lewis',
        'apellido': 'Hamilton',
        'pais': 'United Kingdom',
        'anios_consecutivos': 15,
        'periodo': '2007-2021',
      },
      {
        'nombre': 'Michael',
        'apellido': 'Schumacher',
        'pais': 'Germany',
        'anios_consecutivos': 15,
        'periodo': '1992-2006',
      },
    ];
  }

  Future<List<Map<String, dynamic>>> obtenerVictoriasPorEquipo() async {
    return [];
  }

  Future<List<Map<String, dynamic>>> obtenerVictoriasPorPais() async {
    return [];
  }
}
