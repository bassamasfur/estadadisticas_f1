import 'package:flutter/material.dart';
import '../services/victorias_service.dart';

/// Vista que muestra más victorias en un solo año
class VictoriasEnUnAnioView extends StatefulWidget {
  const VictoriasEnUnAnioView({super.key});

  @override
  State<VictoriasEnUnAnioView> createState() => _VictoriasEnUnAnioViewState();
}

class _VictoriasEnUnAnioViewState extends State<VictoriasEnUnAnioView> {
  final VictoriasService _victoriasService = VictoriasService();
  List<Map<String, dynamic>> _records = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarRecords();
  }

  Future<void> _cargarRecords() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final records = await _victoriasService.obtenerVictoriasEnUnAnio();

      // Ordenar por victorias (descendente), luego por temporada
      records.sort((a, b) {
        final victoriasCmp = (b['victorias'] as int).compareTo(
          a['victorias'] as int,
        );
        if (victoriasCmp != 0) return victoriasCmp;
        return (b['temporada'] as int).compareTo(a['temporada'] as int);
      });

      setState(() {
        _records = records;
        _cargando = false;
      });
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
          'Victorias - En un año',
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
                    onPressed: _cargarRecords,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                return _RecordTemporadaCard(
                  posicion: index + 1,
                  record: record,
                );
              },
            ),
    );
  }
}

class _RecordTemporadaCard extends StatelessWidget {
  final int posicion;
  final Map<String, dynamic> record;

  const _RecordTemporadaCard({required this.posicion, required this.record});

  Color _getColorPorPosicion() {
    if (posicion <= 3) return const Color(0xFFE10600);
    if (posicion <= 10) return Colors.orange;
    return Colors.grey;
  }

  Color _getColorPorVictorias(int victorias) {
    if (victorias >= 19) return const Color(0xFF4CAF50);
    if (victorias >= 13) return const Color(0xFF2196F3);
    if (victorias >= 11) return const Color(0xFFFF9800);
    if (victorias >= 9) return const Color(0xFFE91E63);
    return Colors.grey;
  }

  String _getCodigoPais(String pais) {
    final Map<String, String> codigos = {
      'Germany': '🇩🇪',
      'Netherlands': '🇳🇱',
      'United Kingdom': '🇬🇧',
      'Brazil': '🇧🇷',
      'Finland': '🇫🇮',
    };
    return codigos[pais] ?? '🏁';
  }

  @override
  Widget build(BuildContext context) {
    final nombre = record['piloto'] as String;
    final pais = record['pais'] as String;
    final victorias = record['victorias'] as int;
    final temporada = record['temporada'] as int;
    final carrerasTotales = record['carreras_totales'] as int;
    final porcentaje = (victorias / carrerasTotales * 100).toStringAsFixed(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: posicion <= 3
            ? Border.all(color: const Color(0xFFE10600), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Posición
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _getColorPorPosicion().withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: posicion <= 3
                    ? Border.all(color: const Color(0xFFE10600), width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  '$posicion',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getColorPorPosicion(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Información del piloto y temporada
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getCodigoPais(pais),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Temporada $temporada',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$victorias de $carrerasTotales carreras ($porcentaje%)',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Badge de victorias
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getColorPorVictorias(victorias),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    '$victorias',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'victorias',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
