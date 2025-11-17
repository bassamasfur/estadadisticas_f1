import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/campeones_controller.dart';
import '../models/campeon_mundial.dart';

/// Vista que muestra la cronología de campeones año por año
class TitulosCronologiaView extends StatefulWidget {
  const TitulosCronologiaView({super.key});

  @override
  State<TitulosCronologiaView> createState() => _TitulosCronologiaViewState();
}

class _TitulosCronologiaViewState extends State<TitulosCronologiaView> {
  bool _ordenInverso = false;

  @override
  void initState() {
    super.initState();
    // Cargar campeones al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CampeonesController>().cargarCampeones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cronología de Campeones',
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
                ? 'Más antiguos primero'
                : 'Más recientes primero',
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
                      'Cargando cronología...',
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
                      size: 64,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${controller.error}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        controller.cargarCampeones();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF60A5FA),
                      ),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            if (!controller.tieneCampeones) {
              return const Center(
                child: Text(
                  'No hay datos disponibles',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            // Obtener campeones ordenados por año (más reciente primero)
            final campeones = _ordenInverso
                ? controller.campeones.reversed.toList()
                : controller.campeones;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: campeones.length,
              itemBuilder: (context, index) {
                final campeon = campeones[index];
                return _CampeonCard(campeon: campeon);
              },
            );
          },
        ),
      ),
    );
  }
}

/// Card individual para cada campeón
class _CampeonCard extends StatelessWidget {
  final CampeonMundial campeon;

  const _CampeonCard({required this.campeon});

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
            // Año destacado - más pequeño
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
            // Información del campeón
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre completo - más pequeño
                  Text(
                    '${campeon.nombre} ${campeon.apellido}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Equipo - más pequeño
                  Row(
                    children: [
                      Icon(Icons.groups, size: 13, color: Colors.grey[400]),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          campeon.equipoNombre,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Estadísticas - más compactas
                  Row(
                    children: [
                      _EstadisticaChip(
                        icono: Icons.emoji_events,
                        valor: '${campeon.victorias}',
                        label: 'victorias',
                      ),
                      const SizedBox(width: 6),
                      _EstadisticaChip(
                        icono: Icons.star,
                        valor: '${campeon.puntos}',
                        label: 'pts',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bandera o indicador de nacionalidad - más pequeño
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

  /// Obtiene código de país a partir del nombre
  String _obtenerCodigoPais(String pais) {
    final codigos = {
      'Italy': 'ITA',
      'Argentina': 'ARG',
      'United Kingdom': 'GBR',
      'Australia': 'AUS',
      'United States': 'USA',
      'New Zealand': 'NZL',
      'Austria': 'AUT',
      'Brazil': 'BRA',
      'South Africa': 'ZAF',
      'Finland': 'FIN',
      'France': 'FRA',
      'Germany': 'GER',
      'Canada': 'CAN',
      'Spain': 'ESP',
      'Netherlands': 'NED',
    };
    return codigos[pais] ?? pais.substring(0, 3).toUpperCase();
  }
}

/// Chip pequeño para mostrar estadísticas
class _EstadisticaChip extends StatelessWidget {
  final IconData icono;
  final String valor;
  final String label;

  const _EstadisticaChip({
    required this.icono,
    required this.valor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3F2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 11, color: const Color(0xFFE10600)),
          const SizedBox(width: 3),
          Text(
            '$valor $label',
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
