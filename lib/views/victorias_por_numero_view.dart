import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Vista que muestra pilotos ordenados por número total de victorias
class VictoriasPorNumeroView extends StatefulWidget {
  const VictoriasPorNumeroView({super.key});

  @override
  State<VictoriasPorNumeroView> createState() => _VictoriasPorNumeroViewState();
}

class _VictoriasPorNumeroViewState extends State<VictoriasPorNumeroView> {
  List<Map<String, dynamic>> _pilotos = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarPilotos();
  }

  Future<void> _cargarPilotos() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final uri = Uri.parse('https://f1-api-one.vercel.app/api/victorias');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> lista = data['data'] ?? [];
        final pilotos = lista
            .map<Map<String, dynamic>>(
              (item) => {
                'nombre': item['nombre'],
                'victorias': int.tryParse(item['victorias'].toString()) ?? 0,
                'porcentaje': item['porcentaje'] is num
                    ? item['porcentaje']
                    : (item['porcentaje'] != null
                          ? double.tryParse(item['porcentaje'].toString()) ?? 0
                          : 0),
              },
            )
            .toList();
        pilotos.sort(
          (a, b) => (b['victorias'] as int).compareTo(a['victorias'] as int),
        );
        setState(() {
          _pilotos = pilotos;
          _cargando = false;
        });
      } else {
        setState(() {
          _error = 'Error HTTP: ${response.statusCode}';
          _cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error al cargar datos: $e';
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Victorias - Por número',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF0F172A),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _cargarPilotos,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _pilotos.length,
              itemBuilder: (context, index) {
                final piloto = _pilotos[index];
                return _PilotoVictoriasCard(
                  posicion: index + 1,
                  piloto: piloto,
                );
              },
            ),
    );
  }
}

class _PilotoVictoriasCard extends StatelessWidget {
  final int posicion;
  final Map<String, dynamic> piloto;

  const _PilotoVictoriasCard({required this.posicion, required this.piloto});

  Color _getColorPorVictorias(int victorias) {
    if (victorias >= 50) return const Color(0xFF4CAF50); // Verde - Leyendas
    if (victorias >= 30) return const Color(0xFF2196F3); // Azul - Élite
    if (victorias >= 20) return const Color(0xFFFF9800); // Naranja - Grandes
    if (victorias >= 10) return const Color(0xFFE91E63); // Rosa - Buenos
    return Colors.grey; // Gris - Otros
  }

  String _getCodigoPais(String pais) {
    final Map<String, String> codigos = {
      'Argentina': '🇦🇷',
      'Australia': '🇦🇺',
      'Austria': '🇦🇹',
      'Belgium': '🇧🇪',
      'Brazil': '🇧🇷',
      'Canada': '🇨🇦',
      'Colombia': '🇨🇴',
      'Finland': '🇫🇮',
      'France': '🇫🇷',
      'Germany': '🇩🇪',
      'Italy': '🇮🇹',
      'Monaco': '🇲🇨',
      'Mexico': '🇲🇽',
      'Netherlands': '🇳🇱',
      'New Zealand': '🇳🇿',
      'South Africa': '🇿🇦',
      'Spain': '🇪🇸',
      'Sweden': '🇸🇪',
      'Switzerland': '🇨🇭',
      'United Kingdom': '🇬🇧',
      'United States': '🇺🇸',
    };
    return codigos[pais] ?? '🏁';
  }

  @override
  Widget build(BuildContext context) {
    final victorias = piloto['victorias'] as int;
    final color = _getColorPorVictorias(victorias);
    final esTop3 = posicion <= 3;
    final esPodio = posicion <= 10;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: esTop3 ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: esTop3
            ? BorderSide(color: const Color(0xFFE10600), width: 2)
            : BorderSide.none,
      ),
      color: const Color(0xFF1E293B),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Posición
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: esTop3
                    ? const Color(0xFFE10600)
                    : (esPodio ? Colors.orange[300] : Colors.grey[300]),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$posicion',
                  style: TextStyle(
                    color: (esTop3 || esPodio) ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Badge de victorias
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    '$victorias',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const Text(
                    'victorias',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Información del piloto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    piloto['nombre'] ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: esTop3 ? FontWeight.bold : FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Porcentaje: ${((piloto['porcentaje'] ?? 0) as num).toStringAsFixed(2)}%',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  if (esTop3)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        posicion == 1
                            ? 'MÁXIMO GANADOR'
                            : posicion == 2
                            ? 'LEYENDA'
                            : 'TOP 3',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[900],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Bandera
            Text(
              _getCodigoPais((piloto['pais'] ?? '').toString()),
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
