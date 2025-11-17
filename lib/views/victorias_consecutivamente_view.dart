import 'package:flutter/material.dart';
import '../services/victorias_service.dart';

/// Vista que muestra rachas de victorias consecutivas
class VictoriasConsecutivamenteView extends StatefulWidget {
  const VictoriasConsecutivamenteView({super.key});

  @override
  State<VictoriasConsecutivamenteView> createState() =>
      _VictoriasConsecutivamenteViewState();
}

class _VictoriasConsecutivamenteViewState
    extends State<VictoriasConsecutivamenteView> {
  final VictoriasService _victoriasService = VictoriasService();
  List<Map<String, dynamic>> _rachas = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarRachas();
  }

  Future<void> _cargarRachas() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final rachas = await _victoriasService.obtenerVictoriasConsecutivas();

      // Ordenar por victorias consecutivas (descendente)
      rachas.sort(
        (a, b) => (b['victorias_consecutivas'] as int).compareTo(
          a['victorias_consecutivas'] as int,
        ),
      );

      setState(() {
        _rachas = rachas;
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
          'Victorias - Consecutivamente',
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
                    onPressed: _cargarRachas,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _rachas.length,
              itemBuilder: (context, index) {
                final racha = _rachas[index];
                return _RachaVictoriasCard(posicion: index + 1, racha: racha);
              },
            ),
    );
  }
}

class _RachaVictoriasCard extends StatelessWidget {
  final int posicion;
  final Map<String, dynamic> racha;

  const _RachaVictoriasCard({required this.posicion, required this.racha});

  Color _getColorPorPosicion() {
    if (posicion <= 3) return const Color(0xFFE10600); // F1 Red para top 3
    if (posicion <= 10) return Colors.orange;
    return Colors.grey;
  }

  Color _getColorPorVictorias(int victorias) {
    if (victorias >= 9) return const Color(0xFF4CAF50); // Verde
    if (victorias >= 7) return const Color(0xFF2196F3); // Azul
    if (victorias >= 5) return const Color(0xFFFF9800); // Naranja
    if (victorias >= 4) return const Color(0xFFE91E63); // Rosa
    return Colors.grey;
  }

  // El campo pais y bandera se elimina porque el API no lo provee

  @override
  Widget build(BuildContext context) {
    final nombre = (racha['piloto'] ?? '').toString();
    final victoriasConsecutivas = racha['victorias_consecutivas'] is int
        ? racha['victorias_consecutivas']
        : int.tryParse(racha['victorias_consecutivas']?.toString() ?? '') ?? 0;
    final inicio = (racha['inicio'] ?? '').toString();
    final fin = (racha['fin'] ?? '').toString();

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

            // Información del piloto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'De: $inicio',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'A: $fin',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Badge de victorias consecutivas
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getColorPorVictorias(victoriasConsecutivas),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    '$victoriasConsecutivas',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'seguidas',
                    style: TextStyle(
                      fontSize: 10,
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
