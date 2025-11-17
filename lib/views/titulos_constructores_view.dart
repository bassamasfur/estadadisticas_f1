import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/campeones_controller.dart';
import '../models/campeon_mundial.dart';

/// Vista que muestra con cuántos constructores diferentes ha ganado cada campeón
class TitulosConstructoresView extends StatefulWidget {
  const TitulosConstructoresView({super.key});

  @override
  State<TitulosConstructoresView> createState() =>
      _TitulosConstructoresViewState();
}

class _TitulosConstructoresViewState extends State<TitulosConstructoresView> {
  bool _ordenInverso = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diferentes Constructores',
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
                ? 'Menos constructores primero'
                : 'Más constructores primero',
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
            if (controller.cargando) {
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

            final campeonesConConstructores = _obtenerCampeonesConConstructores(
              controller.campeones,
            );

            if (campeonesConConstructores.isEmpty) {
              return const Center(
                child: Text(
                  'No hay datos disponibles',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final campeonesFinales = _ordenInverso
                ? campeonesConConstructores.reversed.toList()
                : campeonesConConstructores;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: campeonesFinales.length,
              itemBuilder: (context, index) {
                final item = campeonesFinales[index];
                return _ConstructoresCard(
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

  /// Obtiene los datos de constructores diferentes para cada campeón
  List<_CampeonConstructores> _obtenerCampeonesConConstructores(
    List<CampeonMundial> campeones,
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
    List<_CampeonConstructores> resultado = [];

    for (var entry in campeonMap.entries) {
      final nombreCompleto = entry.key;
      final titulos = entry.value;

      // Obtener constructores únicos
      final constructoresSet = titulos.map((c) => c.equipoNombre).toSet();
      final constructoresList = constructoresSet.toList();

      // Ordenar por año para encontrar el primer título
      titulos.sort((a, b) => a.temporada.compareTo(b.temporada));
      final primerTitulo = titulos.first;

      resultado.add(
        _CampeonConstructores(
          nombre: nombreCompleto,
          pais: primerTitulo.nacionalidad,
          constructores: constructoresList,
          numeroConstructores: constructoresSet.length,
          totalTitulos: titulos.length,
        ),
      );
    }

    // Ordenar por número de constructores (de más a menos)
    resultado.sort((a, b) {
      final comparacion = b.numeroConstructores.compareTo(
        a.numeroConstructores,
      );
      if (comparacion != 0) return comparacion;
      // Si tienen el mismo número de constructores, ordenar por total de títulos
      return b.totalTitulos.compareTo(a.totalTitulos);
    });

    return resultado;
  }
}

/// Modelo interno para constructores por campeón
class _CampeonConstructores {
  final String nombre;
  final String pais;
  final List<String> constructores;
  final int numeroConstructores;
  final int totalTitulos;

  _CampeonConstructores({
    required this.nombre,
    required this.pais,
    required this.constructores,
    required this.numeroConstructores,
    required this.totalTitulos,
  });
}

/// Widget de tarjeta para mostrar constructores de un campeón
class _ConstructoresCard extends StatelessWidget {
  final int posicion;
  final _CampeonConstructores campeonData;

  const _ConstructoresCard({required this.posicion, required this.campeonData});

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

            // Badge de número de constructores
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _obtenerColorConstructores(
                  campeonData.numeroConstructores,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    '${campeonData.numeroConstructores}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    campeonData.numeroConstructores == 1 ? 'equipo' : 'equipos',
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

                  // Equipos
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        size: 12,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          campeonData.constructores.join(', '),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[400],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Total de títulos
                  Row(
                    children: [
                      Icon(Icons.star, size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        '${campeonData.totalTitulos} ${campeonData.totalTitulos == 1 ? 'título' : 'títulos'}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[400]),
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

  Color _obtenerColorConstructores(int numero) {
    // Colores según número de constructores diferentes
    if (numero >= 4) {
      return const Color(0xFF10B981); // Verde - Muy versátil
    } else if (numero == 3) {
      return const Color(0xFF3B82F6); // Azul - Versátil
    } else if (numero == 2) {
      return const Color(0xFFF59E0B); // Naranja - Dual
    } else {
      return const Color(0xFF6B7280); // Gris - Un solo equipo
    }
  }

  String _obtenerCodigoPais(String pais) {
    // Extracción dinámica: primeras 3 letras del país en mayúsculas
    return pais.substring(0, 3).toUpperCase();
  }
}
