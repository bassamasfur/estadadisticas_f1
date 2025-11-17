import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/campeones_controller.dart';

/// Vista que muestra la lista de campeones por número
class TitulosPorNumeroView extends StatefulWidget {
  const TitulosPorNumeroView({super.key});

  @override
  State<TitulosPorNumeroView> createState() => _TitulosPorNumeroViewState();
}

class _TitulosPorNumeroViewState extends State<TitulosPorNumeroView> {
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
          'Títulos por Número',
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
            tooltip: _ordenInverso ? 'Orden ascendente' : 'Orden descendente',
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
                    CircularProgressIndicator(color: Color(0xFF60A5FA)),
                    SizedBox(height: 16),
                    Text(
                      'Cargando campeones...',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Esto puede tomar unos segundos',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            if (controller.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
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
                        controller.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => controller.cargarCampeones(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF60A5FA),
                        ),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
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

            // Obtener ranking de campeones (ordenado por títulos)
            final ranking = controller.obtenerRankingCampeones();

            // Invertir orden si está activo
            final rankingOrdenado = _ordenInverso
                ? ranking.reversed.toList()
                : ranking;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: rankingOrdenado.length,
              itemBuilder: (context, index) {
                final entry = rankingOrdenado[index];
                final nombre = entry.key;
                final titulos = entry.value;

                // Obtener el primer campeón con ese nombre para más detalles
                final campeon = controller.campeones.firstWhere(
                  (c) => c.nombreCompleto == nombre,
                );

                return _CampeonCard(
                  nombre: nombre,
                  titulos: titulos,
                  nacionalidad: campeon.nacionalidad,
                  posicion: _ordenInverso
                      ? rankingOrdenado.length - index
                      : index + 1,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CampeonCard extends StatelessWidget {
  final String nombre;
  final int titulos;
  final String nacionalidad;
  final int posicion;

  const _CampeonCard({
    required this.nombre,
    required this.titulos,
    required this.nacionalidad,
    required this.posicion,
  });

  Color _getColorPorPosicion() {
    switch (posicion) {
      case 1:
        return const Color(0xFFFFD700); // Oro
      case 2:
        return const Color(0xFFC0C0C0); // Plata
      case 3:
        return const Color(0xFFCD7F32); // Bronce
      default:
        return const Color(0xFF6B7280); // Gris
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: posicion <= 3 ? 3 : 1,
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: posicion <= 3
            ? BorderSide(color: _getColorPorPosicion(), width: 1)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _getColorPorPosicion().withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$posicion',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _getColorPorPosicion(),
              ),
            ),
          ),
        ),
        title: Text(
          nombre,
          style: TextStyle(
            fontSize: 14,
            fontWeight: posicion <= 3 ? FontWeight.bold : FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          nacionalidad,
          style: TextStyle(fontSize: 11, color: Colors.grey[400]),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE10600),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                '$titulos',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
