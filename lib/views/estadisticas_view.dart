import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/estadisticas_controller.dart';
import '../widgets/stat_card.dart';
import 'titulos_detalle_view.dart';
import 'victorias_detalle_view.dart';
import 'pole_position_view.dart';

/// Vista principal que muestra las estadísticas generales de F1
class EstadisticasView extends StatefulWidget {
  const EstadisticasView({super.key});

  @override
  State<EstadisticasView> createState() => _EstadisticasViewState();
}

class _EstadisticasViewState extends State<EstadisticasView> {
  @override
  void initState() {
    super.initState();
    // Cargar estadísticas al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EstadisticasController>().cargarEstadisticas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EstadisticasController>(
      builder: (context, controller, child) {
        if (controller.cargando) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(controller.error!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.cargarEstadisticas(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final stats = controller.estadisticas;

        return RefreshIndicator(
          onRefresh: () => controller.cargarEstadisticas(),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF1E293B),
                  Color(0xFF0F172A),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Encabezado
                  Text(
                    'Estadísticas Generales',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Datos históricos de Fórmula 1',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Grid de estadísticas
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      // Títulos
                      StatCard(
                        icono: Icons.emoji_events,
                        colorIcono: const Color(0xFFFFA726),
                        titulo: 'Títulos',
                        subtitulo: 'Campeonatos mundiales',
                        valor: stats.titulos.toString(),
                        colorValor: const Color(0xFFFFA726),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TitulosDetalleView(),
                            ),
                          );
                        },
                      ),

                      // Victorias
                      StatCard(
                        icono: Icons.flag,
                        colorIcono: const Color(0xFF66BB6A),
                        titulo: 'Victorias',
                        subtitulo: 'Carreras ganadas',
                        valor: stats.victorias.toString(),
                        colorValor: const Color(0xFF66BB6A),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const VictoriasDetalleView(),
                            ),
                          );
                        },
                      ),

                      // Pole Position
                      StatCard(
                        icono: Icons.speed,
                        colorIcono: const Color(0xFF42A5F5),
                        titulo: 'Pole Position',
                        subtitulo: 'Salidas desde la pole',
                        valor: stats.polePositions.toString(),
                        colorValor: const Color(0xFF42A5F5),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PolePositionView(),
                            ),
                          );
                        },
                      ),

                      // Podiums
                      StatCard(
                        icono: Icons.military_tech,
                        colorIcono: const Color(0xFFAB47BC),
                        titulo: 'Podiums',
                        subtitulo: 'Finales en el podio',
                        valor: stats.podiums.toString(),
                        colorValor: const Color(0xFFAB47BC),
                      ),

                      // Puntos
                      StatCard(
                        icono: Icons.trending_up,
                        colorIcono: const Color(0xFFEF5350),
                        titulo: 'Puntos',
                        subtitulo: 'Puntos totales',
                        valor: stats.puntos.toString(),
                        colorValor: const Color(0xFFEF5350),
                      ),

                      // Carreras
                      StatCard(
                        icono: Icons.sports_motorsports,
                        colorIcono: const Color(0xFF26A69A),
                        titulo: 'Carreras',
                        subtitulo: 'Carreras disputadas',
                        valor: stats.carreras.toString(),
                        colorValor: const Color(0xFF26A69A),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
