import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/campeones_controller.dart';
import '../models/campeon_mundial.dart';
import '../services/wikipedia_f1_service.dart';

/// Vista que muestra las temporadas que cada campeón disputó antes de ganar su primer título
class TitulosTemporadasAntesView extends StatefulWidget {
  const TitulosTemporadasAntesView({super.key});

  @override
  State<TitulosTemporadasAntesView> createState() =>
      _TitulosTemporadasAntesViewState();
}

class _TitulosTemporadasAntesViewState
    extends State<TitulosTemporadasAntesView> {
  final WikipediaF1Service _service = WikipediaF1Service();
  Map<String, int> _temporadasAntes = {};
  bool _cargandoTemporadas = true;
  bool _ordenInverso = false;

  @override
  void initState() {
    super.initState();
    _cargarTemporadasAntes();
  }

  Future<void> _cargarTemporadasAntes() async {
    final temporadas = await _service.obtenerTemporadasAntes();
    setState(() {
      _temporadasAntes = temporadas;
      _cargandoTemporadas = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Temporadas Antes del Título',
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
                ? 'Más temporadas primero'
                : 'Menos temporadas primero',
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
        child: Consumer<CampeonesController>(
          builder: (context, controller, child) {
            if (controller.cargando || _cargandoTemporadas) {
              return const Center(
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
                      'Cargando datos...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            if (controller.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.error!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }

            final campeonesConTemporadas = _obtenerCampeonesConTemporadas(
              controller.campeones,
              _temporadasAntes,
            );

            if (campeonesConTemporadas.isEmpty) {
              return const Center(
                child: Text(
                  'No hay datos disponibles',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final campeonesOrdenados = _ordenInverso
                ? campeonesConTemporadas.reversed.toList()
                : campeonesConTemporadas;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: campeonesOrdenados.length,
              itemBuilder: (context, index) {
                final item = campeonesOrdenados[index];
                return _TemporadasAntesCard(
                  posicion: index + 1,
                  campeonData: item,
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Obtiene los datos de temporadas antes del primer título para cada campeón
  List<_CampeonTemporadas> _obtenerCampeonesConTemporadas(
    List<CampeonMundial> campeones,
    Map<String, int> temporadasAntes,
  ) {
    if (campeones.isEmpty) return [];

    // Agrupar por piloto
    final Map<String, List<CampeonMundial>> campeonMap = {};
    for (var campeon in campeones) {
      final key = '${campeon.nombre} ${campeon.apellido}';
      campeonMap.putIfAbsent(key, () => []);
      campeonMap[key]!.add(campeon);
    }

    // Crear lista con datos
    List<_CampeonTemporadas> resultado = [];

    for (var entry in campeonMap.entries) {
      final nombreCompleto = entry.key;
      final titulos = entry.value;

      // Ordenar por año para encontrar el primer título
      titulos.sort((a, b) => a.temporada.compareTo(b.temporada));
      final primerTitulo = titulos.first;

      // Buscar cuántas temporadas antes (desde la API)
      final temporadas = temporadasAntes[nombreCompleto] ?? 0;

      resultado.add(
        _CampeonTemporadas(
          nombre: nombreCompleto,
          pais: primerTitulo.nacionalidad,
          equipo: primerTitulo.equipoNombre,
          primerTitulo: primerTitulo.temporada,
          temporadasAntes: temporadas,
          totalTitulos: titulos.length,
        ),
      );
    }

    // Ordenar por temporadas antes (de menos a más)
    resultado.sort((a, b) => a.temporadasAntes.compareTo(b.temporadasAntes));

    return resultado;
  }
}

/// Modelo interno para temporadas antes del título
class _CampeonTemporadas {
  final String nombre;
  final String pais;
  final String equipo;
  final String primerTitulo;
  final int temporadasAntes;
  final int totalTitulos;

  _CampeonTemporadas({
    required this.nombre,
    required this.pais,
    required this.equipo,
    required this.primerTitulo,
    required this.temporadasAntes,
    required this.totalTitulos,
  });
}

/// Widget de tarjeta para mostrar temporadas antes del título
class _TemporadasAntesCard extends StatelessWidget {
  final int posicion;
  final _CampeonTemporadas campeonData;

  const _TemporadasAntesCard({
    required this.posicion,
    required this.campeonData,
  });

  @override
  Widget build(BuildContext context) {
    final esTop3 = posicion <= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
              width: 36,
              height: 36,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Badge de temporadas
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _obtenerColorTemporadas(campeonData.temporadasAntes),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    '${campeonData.temporadasAntes}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    campeonData.temporadasAntes == 1
                        ? 'temporada'
                        : 'temporadas',
                    style: const TextStyle(color: Colors.white, fontSize: 9),
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
                  // Nombre del piloto
                  Text(
                    campeonData.nombre,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Primer título
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        size: 12,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Primer título: ${campeonData.primerTitulo}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Equipo y total de títulos
                  Row(
                    children: [
                      Icon(Icons.star, size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${campeonData.equipo} • ${campeonData.totalTitulos} ${campeonData.totalTitulos == 1 ? 'título' : 'títulos'}',
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

            // País
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _obtenerCodigoPais(campeonData.pais),
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

  Color _obtenerColorTemporadas(int temporadas) {
    // Verde para éxito inmediato (0-2), amarillo medio (3-5), rojo para muchas temporadas (6+)
    if (temporadas <= 2) {
      return const Color(0xFF10B981); // Verde
    } else if (temporadas <= 5) {
      return const Color(0xFFF59E0B); // Amarillo/Naranja
    } else {
      return const Color(0xFFE10600); // Rojo F1
    }
  }

  String _obtenerCodigoPais(String pais) {
    final Map<String, String> codigos = {
      'Argentina': 'ARG',
      'Reino Unido': 'GBR',
      'Alemania': 'GER',
      'Brasil': 'BRA',
      'Austria': 'AUT',
      'Australia': 'AUS',
      'Italia': 'ITA',
      'Francia': 'FRA',
      'Finlandia': 'FIN',
      'España': 'ESP',
      'Países Bajos': 'NED',
      'Canadá': 'CAN',
      'Nueva Zelanda': 'NZL',
      'Estados Unidos': 'USA',
      'Sudáfrica': 'RSA',
      'Bélgica': 'BEL',
      'British': 'GBR',
      'German': 'GER',
      'Brazilian': 'BRA',
      'Austrian': 'AUT',
      'Australian': 'AUS',
      'Italian': 'ITA',
      'French': 'FRA',
      'Finnish': 'FIN',
      'Spanish': 'ESP',
      'Dutch': 'NED',
      'Canadian': 'CAN',
      'American': 'USA',
    };
    return codigos[pais] ?? pais.substring(0, 3).toUpperCase();
  }
}
