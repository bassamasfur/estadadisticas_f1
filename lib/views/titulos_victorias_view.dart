import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/campeones_controller.dart';
import '../models/campeon_mundial.dart';

/// Vista que muestra las victorias de cada campeón en su año de título
class TitulosVictoriasView extends StatefulWidget {
  const TitulosVictoriasView({super.key});

  @override
  State<TitulosVictoriasView> createState() => _TitulosVictoriasViewState();
}

class _TitulosVictoriasViewState extends State<TitulosVictoriasView> {
  bool _ordenInverso = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Victorias por Título',
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
                ? 'Menos victorias primero'
                : 'Más victorias primero',
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
                      'Cargando victorias...',
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

            // Ordenar por número de victorias (de mayor a menor)
            final campeonesOrdenados = List<CampeonMundial>.from(
              controller.campeones,
            )..sort((a, b) => b.victorias.compareTo(a.victorias));

            if (campeonesOrdenados.isEmpty) {
              return const Center(
                child: Text(
                  'No hay datos disponibles',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final campeonesFinales = _ordenInverso
                ? campeonesOrdenados.reversed.toList()
                : campeonesOrdenados;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: campeonesFinales.length,
              itemBuilder: (context, index) {
                final campeon = campeonesFinales[index];
                return _VictoriaCampeonCard(
                  campeon: campeon,
                  posicion: index + 1,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Widget de tarjeta para mostrar victorias de un campeón
class _VictoriaCampeonCard extends StatelessWidget {
  final CampeonMundial campeon;
  final int posicion;

  const _VictoriaCampeonCard({required this.campeon, required this.posicion});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.2 * 255).toInt()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Año
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF60A5FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  campeon.temporada,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Badge de victorias
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _obtenerColorVictorias(campeon.victorias),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    '${campeon.victorias}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    campeon.victorias == 1 ? 'victoria' : 'victorias',
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
                    '${campeon.nombre} ${campeon.apellido}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Equipo
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
                          campeon.equipoNombre,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Puntos
                  Row(
                    children: [
                      Icon(Icons.star, size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        '${campeon.puntos} puntos',
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
                _obtenerCodigoPais(campeon.nacionalidad),
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

  Color _obtenerColorVictorias(int victorias) {
    // Colores según número de victorias
    if (victorias >= 10) {
      return const Color(0xFF10B981); // Verde - Dominio absoluto
    } else if (victorias >= 7) {
      return const Color(0xFF3B82F6); // Azul - Muy bueno
    } else if (victorias >= 5) {
      return const Color(0xFFF59E0B); // Naranja - Bueno
    } else if (victorias >= 3) {
      return const Color(0xFFEF4444); // Rojo - Moderado
    } else {
      return const Color(0xFF6B7280); // Gris - Pocas victorias
    }
  }

  String _obtenerCodigoPais(String pais) {
    // Obtener las primeras 3 letras del país en mayúsculas
    if (pais.length >= 3) {
      return pais.substring(0, 3).toUpperCase();
    }
    return pais.toUpperCase();
  }
}
