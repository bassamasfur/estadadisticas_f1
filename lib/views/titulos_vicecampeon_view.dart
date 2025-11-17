import 'package:flutter/material.dart';
import '../services/subcampeones_service.dart';

/// Vista que muestra el total de veces que cada piloto fue subcampeón
class TitulosVicecampeonView extends StatefulWidget {
  const TitulosVicecampeonView({super.key});

  @override
  State<TitulosVicecampeonView> createState() => _TitulosVicecampeonViewState();
}

class _TitulosVicecampeonViewState extends State<TitulosVicecampeonView> {
  final SubcampeonesService _subcampeonesService = SubcampeonesService();
  Map<String, Map<String, dynamic>> _subcampeonesData = {};
  bool _cargando = true;
  String? _error;
  bool _ordenInverso = false;

  @override
  void initState() {
    super.initState();
    _cargarSubcampeones();
  }

  Future<void> _cargarSubcampeones() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final datos = await _subcampeonesService
          .obtenerSubcampeonesPorTemporada();

      setState(() {
        _subcampeonesData = datos;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar datos: $e';
        _cargando = false;
      });
    }
  }

  List<Map<String, dynamic>> _obtenerSubcampeonesRanking() {
    // Contar subcampeonatos por piloto
    final Map<String, Map<String, dynamic>> conteo = {};

    _subcampeonesData.forEach((temporada, data) {
      final nombreCompleto = '${data['nombre']} ${data['apellido']}';
      if (!conteo.containsKey(nombreCompleto)) {
        conteo[nombreCompleto] = {
          'nombre': data['nombre'],
          'apellido': data['apellido'],
          'pais': data['pais'],
          'vecesSubcampeon': 0,
          'temporadas': <String>[],
        };
      }
      conteo[nombreCompleto]!['vecesSubcampeon']++;
      (conteo[nombreCompleto]!['temporadas'] as List<String>).add(temporada);
    });

    // Convertir a lista y ordenar por número de subcampeonatos
    final ranking = conteo.values.toList();
    ranking.sort((a, b) {
      final comparacion = (b['vecesSubcampeon'] as int).compareTo(
        a['vecesSubcampeon'] as int,
      );
      if (comparacion != 0) return comparacion;
      return (a['apellido'] as String).compareTo(b['apellido'] as String);
    });

    return ranking;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vice-campeón',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
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
                ? 'Menos veces subcampeón primero'
                : 'Más veces subcampeón primero',
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
        child: _cargando
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF60A5FA),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Cargando subcampeones...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              )
            : _error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(_error!, style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF60A5FA),
                      ),
                      onPressed: _cargarSubcampeones,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              )
            : () {
                final ranking = _obtenerSubcampeonesRanking();
                final rankingFinal = _ordenInverso
                    ? ranking.reversed.toList()
                    : ranking;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: rankingFinal.length,
                  itemBuilder: (context, index) {
                    final subcampeon = rankingFinal[index];
                    return _SubcampeonCard(
                      posicion: index + 1,
                      subcampeon: subcampeon,
                    );
                  },
                );
              }(),
      ),
    );
  }
}

class _SubcampeonCard extends StatelessWidget {
  final int posicion;
  final Map<String, dynamic> subcampeon;

  const _SubcampeonCard({required this.posicion, required this.subcampeon});

  Color _getColorPorVeces(int veces) {
    if (veces >= 5) return const Color(0xFFEF4444); // 5+ veces - Rojo
    if (veces >= 3) return const Color(0xFFF59E0B); // 3-4 veces - Naranja
    if (veces >= 2) return const Color(0xFF3B82F6); // 2 veces - Azul
    return const Color(0xFF6B7280); // 1 vez - Gris
  }

  String _getCodigoPais(String pais) {
    // Extracción dinámica: primeras 3 letras del país en mayúsculas
    if (pais == 'Unknown' || pais.isEmpty) return '�';
    return pais.substring(0, pais.length >= 3 ? 3 : pais.length).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final veces = subcampeon['vecesSubcampeon'] as int;
    final temporadas = subcampeon['temporadas'] as List<String>;
    final color = _getColorPorVeces(veces);
    final esTop3 = posicion <= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
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
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: esTop3
                    ? const Color(0xFF60A5FA)
                    : const Color(0xFF334155),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$posicion',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Badge de veces subcampeón
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    '$veces',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Text(
                    '2°',
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
                    '${subcampeon['nombre']} ${subcampeon['apellido']}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTemporadas(temporadas),
                    style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // País
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getCodigoPais(subcampeon['pais'] as String),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTemporadas(List<String> temporadas) {
    temporadas.sort((a, b) => b.compareTo(a)); // Más reciente primero
    if (temporadas.length <= 6) {
      return temporadas.join(', ');
    }
    return '${temporadas.take(6).join(', ')}...';
  }
}
