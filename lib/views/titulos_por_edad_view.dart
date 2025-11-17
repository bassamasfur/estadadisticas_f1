import 'package:flutter/material.dart';
import '../services/wikipedia_f1_service.dart';

/// Vista que muestra campeones ordenados por edad al ganar su primer título
class TitulosPorEdadView extends StatefulWidget {
  const TitulosPorEdadView({super.key});

  @override
  State<TitulosPorEdadView> createState() => _TitulosPorEdadViewState();
}

class _TitulosPorEdadViewState extends State<TitulosPorEdadView> {
  final WikipediaF1Service _service = WikipediaF1Service();
  List<Map<String, dynamic>> _campeones = [];
  bool _cargando = true;
  String? _error;
  bool _ordenInverso = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final datos = await _service.obtenerCampeonesPorEdad();
      setState(() {
        _campeones = datos;
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
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Por Edad',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _ordenInverso ? Icons.arrow_upward : Icons.arrow_downward,
            ),
            onPressed: () {
              setState(() {
                _ordenInverso = !_ordenInverso;
              });
            },
            tooltip: _ordenInverso
                ? 'Más jóvenes primero'
                : 'Más viejos primero',
          ),
        ],
      ),
      backgroundColor: const Color(0xFF0F172A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0F172A)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_cargando) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF60A5FA)),
            ),
            SizedBox(height: 16),
            Text(
              'Cargando campeones por edad...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarDatos,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF60A5FA),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_campeones.isEmpty) {
      return const Center(
        child: Text(
          'No hay datos disponibles',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    final campeonesOrdenados = _ordenInverso
        ? _campeones.reversed.toList()
        : _campeones;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: campeonesOrdenados.length,
      itemBuilder: (context, index) {
        final campeon = campeonesOrdenados[index];
        return _CampeonEdadCard(
          nombre: campeon['nombre'] as String,
          edad: campeon['edad'] as int,
          anio: campeon['año'] as int,
          edadCompleta: campeon['edadCompleta'] as String,
          posicion: index + 1,
        );
      },
    );
  }
}

/// Card para mostrar campeón con edad
class _CampeonEdadCard extends StatelessWidget {
  final String nombre;
  final int edad;
  final int anio;
  final String edadCompleta;
  final int posicion;

  const _CampeonEdadCard({
    required this.nombre,
    required this.edad,
    required this.anio,
    required this.edadCompleta,
    required this.posicion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Posición
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: posicion <= 3
                    ? const Color(0xFF60A5FA)
                    : const Color(0xFF334155),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$posicion',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Edad destacada
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF60A5FA).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  Text(
                    '$edad',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF60A5FA),
                    ),
                  ),
                  Text(
                    'años',
                    style: TextStyle(fontSize: 9, color: Colors.grey[400]),
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
                    nombre,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 11,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Primer título: $anio',
                        style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        size: 11,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          edadCompleta,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[400],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
