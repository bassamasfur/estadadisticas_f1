import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/carrera_controller.dart';
import '../models/carrera.dart';

/// Vista que muestra la lista de carreras actuales
class CarrerasView extends StatefulWidget {
  const CarrerasView({super.key});

  @override
  State<CarrerasView> createState() => _CarrerasViewState();
}

class _CarrerasViewState extends State<CarrerasView> {
  @override
  void initState() {
    super.initState();
    // Cargar carreras al iniciar la vista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarreraController>().cargarCarreras();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarreraController>(
      builder: (context, controller, child) {
        if (controller.cargando && !controller.tieneCarreras) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando calendario de carreras...'),
              ],
            ),
          );
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
                  onPressed: () => controller.cargarCarreras(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (!controller.tieneCarreras) {
          return const Center(child: Text('No hay carreras disponibles'));
        }

        final proximaCarrera = controller.obtenerProximaCarrera();

        return RefreshIndicator(
          onRefresh: () => controller.cargarCarreras(),
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
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                if (proximaCarrera != null) ...[
                  _ProximaCarreraCard(carrera: proximaCarrera),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Todas las carreras',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                ...controller.carreras.map(
                  (carrera) => _CarreraCard(
                    carrera: carrera,
                    esProxima: carrera.id == proximaCarrera?.id,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Tarjeta destacada para la próxima carrera
class _ProximaCarreraCard extends StatelessWidget {
  final Carrera carrera;

  const _ProximaCarreraCard({required this.carrera});

  @override
  Widget build(BuildContext context) {
    final formato = DateFormat('dd/MM/yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      elevation: 4,
      color: const Color(0xFF1E293B),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.upcoming, color: Color(0xFF60A5FA)),
                const SizedBox(width: 8),
                const Text(
                  'PRÓXIMA CARRERA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF60A5FA),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              carrera.nombre,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[300]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${carrera.circuito}, ${carrera.pais}',
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[300]),
                const SizedBox(width: 4),
                Text(
                  formato.format(carrera.fecha),
                  style: TextStyle(color: Colors.grey[300]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta que muestra la información de una carrera
class _CarreraCard extends StatelessWidget {
  final Carrera carrera;
  final bool esProxima;

  const _CarreraCard({required this.carrera, this.esProxima = false});

  @override
  Widget build(BuildContext context) {
    final formato = DateFormat('dd/MM/yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: const Color(0xFF1E293B),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: carrera.yaRealizada
              ? Colors.grey[700]
              : const Color(0xFF60A5FA),
          child: Icon(
            carrera.yaRealizada ? Icons.check : Icons.flag,
            color: Colors.white,
          ),
        ),
        title: Text(
          carrera.nombre,
          style: TextStyle(
            fontWeight: esProxima ? FontWeight.bold : FontWeight.normal,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(carrera.pais, style: TextStyle(color: Colors.grey[300])),
            Text(
              formato.format(carrera.fecha),
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            if (carrera.ganador != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 14,
                    color: Color(0xFFFBBF24),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${carrera.ganador}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFBBF24),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: () {
          _mostrarDetallesCarrera(context, carrera);
        },
      ),
    );
  }

  void _mostrarDetallesCarrera(BuildContext context, Carrera carrera) {
    final formato = DateFormat('dd/MM/yyyy');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: ListView(
              controller: scrollController,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  carrera.nombre,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Imagen del circuito con diseño elegante
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1a1a1a),
                        const Color(0xFF2d2d2d),
                        const Color(0xFFE10600).withValues(alpha: 0.3),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE10600).withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Imagen del circuito
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          _getCircuitImageUrl(carrera.circuito),
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                child: child,
                              );
                            }
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                        : null,
                                    color: const Color(0xFFE10600),
                                    strokeWidth: 3,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Cargando circuito...',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.map,
                                      size: 48,
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Mapa no disponible',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Overlay decorativo superior con gradiente
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.4),
                                Colors.transparent,
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      // Badge decorativo "Circuito"
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFE10600).withValues(alpha: 0.9),
                                const Color(0xFFE10600).withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFE10600,
                                ).withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.route,
                                size: 14,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'CIRCUITO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _DetalleItem(
                  icono: Icons.location_on,
                  titulo: 'Circuito',
                  valor: carrera.circuito,
                ),
                _DetalleItem(
                  icono: Icons.flag,
                  titulo: 'País',
                  valor: carrera.pais,
                ),
                _DetalleItem(
                  icono: Icons.calendar_today,
                  titulo: 'Fecha',
                  valor: formato.format(carrera.fecha),
                ),
                _DetalleItem(
                  icono: Icons.loop,
                  titulo: 'Número de vueltas',
                  valor: carrera.numeroVueltas.toString(),
                ),
                _DetalleItem(
                  icono: Icons.straighten,
                  titulo: 'Longitud del circuito',
                  valor: '${carrera.longitudCircuito.toStringAsFixed(3)} km',
                ),
                _DetalleItem(
                  icono: Icons.map,
                  titulo: 'Distancia total',
                  valor: '${carrera.distanciaTotal.toStringAsFixed(2)} km',
                ),
                if (carrera.ganador != null) ...[
                  const SizedBox(height: 8),
                  _DetalleItem(
                    icono: Icons.emoji_events,
                    titulo: 'Ganador',
                    valor: '${carrera.ganador} (${carrera.equipoGanador})',
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _getCircuitImageUrl(String circuitName) {
    debugPrint('🗺️ Buscando mapa para: $circuitName');

    // Usar URLs de imágenes PNG más confiables
    final circuits = {
      'Albert Park Grand Prix Circuit':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Australia_Circuit.png.transform/9col/image.png',
      'Bahrain International Circuit':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Bahrain_Circuit.png.transform/9col/image.png',
      'Jeddah Corniche Circuit':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Saudi_Arabia_Circuit.png.transform/9col/image.png',
      'Shanghai International Circuit':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/China_Circuit.png.transform/9col/image.png',
      'Miami International Autodrome':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Miami_Circuit.png.transform/9col/image.png',
      'Autodromo Enzo e Dino Ferrari':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Emilia_Romagna_Circuit.png.transform/9col/image.png',
      'Circuit de Monaco':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Monaco_Circuit.png.transform/9col/image.png',
      'Circuit de Barcelona-Catalunya':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Spain_Circuit.png.transform/9col/image.png',
      'Circuit Gilles Villeneuve':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Canada_Circuit.png.transform/9col/image.png',
      'Red Bull Ring':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Austria_Circuit.png.transform/9col/image.png',
      'Silverstone Circuit':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Great_Britain_Circuit.png.transform/9col/image.png',
      'Hungaroring':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Hungary_Circuit.png.transform/9col/image.png',
      'Circuit de Spa-Francorchamps':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Belgium_Circuit.png.transform/9col/image.png',
      'Circuit Zandvoort':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Netherlands_Circuit.png.transform/9col/image.png',
      'Autodromo Nazionale di Monza':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Italy_Circuit.png.transform/9col/image.png',
      'Baku City Circuit':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Azerbaijan_Circuit.png.transform/9col/image.png',
      'Marina Bay Street Circuit':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Singapore_Circuit.png.transform/9col/image.png',
      'Circuit of the Americas':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/USA_Circuit.png.transform/9col/image.png',
      'Autódromo Hermanos Rodríguez':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Mexico_Circuit.png.transform/9col/image.png',
      'Autódromo José Carlos Pace':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Brazil_Circuit.png.transform/9col/image.png',
      'Las Vegas Strip Street Circuit':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Las_Vegas_Circuit.png.transform/9col/image.png',
      'Losail International Circuit':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Qatar_Circuit.png.transform/9col/image.png',
      'Yas Marina Circuit':
          'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Abu_Dhabi_Circuit.png.transform/9col/image.png',
    };

    final url =
        circuits[circuitName] ??
        'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Great_Britain_Circuit.png.transform/9col/image.png';

    debugPrint('📍 URL del mapa: $url');
    return url;
  }
}

class _DetalleItem extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String valor;

  const _DetalleItem({
    required this.icono,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icono, color: const Color(0xFF60A5FA)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
