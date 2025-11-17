import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/equipo_controller.dart';
import '../models/equipo.dart';

/// Vista que muestra la lista de equipos actuales
class EquiposView extends StatefulWidget {
  const EquiposView({super.key});

  @override
  State<EquiposView> createState() => _EquiposViewState();
}

class _EquiposViewState extends State<EquiposView> {
  @override
  void initState() {
    super.initState();
    // Cargar equipos al iniciar la vista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EquipoController>().cargarEquipos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EquipoController>(
      builder: (context, controller, child) {
        if (controller.cargando && !controller.tieneEquipos) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando equipos actuales...'),
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
                  onPressed: () => controller.cargarEquipos(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (!controller.tieneEquipos) {
          return const Center(child: Text('No hay equipos disponibles'));
        }

        return RefreshIndicator(
          onRefresh: () => controller.cargarEquipos(),
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
            child: ListView.builder(
              itemCount: controller.equipos.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final equipo = controller.equipos[index];
                return _EquipoCard(equipo: equipo);
              },
            ),
          ),
        );
      },
    );
  }
}

/// Tarjeta que muestra la información de un equipo
class _EquipoCard extends StatelessWidget {
  final Equipo equipo;

  const _EquipoCard({required this.equipo});

  Color _obtenerColor() {
    try {
      return Color(int.parse(equipo.colorPrincipal.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: const Color(0xFF1E293B),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _obtenerColor(),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.sports_motorsports, color: Colors.white),
        ),
        title: Text(
          equipo.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(equipo.pais, style: TextStyle(color: Colors.grey[300])),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.emoji_events,
                  size: 16,
                  color: Color(0xFF60A5FA),
                ),
                const SizedBox(width: 4),
                Text(
                  '${equipo.puntos} puntos',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF60A5FA),
                  ),
                ),
              ],
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${equipo.campeonatosGanados}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('Títulos', style: TextStyle(fontSize: 10)),
          ],
        ),
        onTap: () {
          _mostrarDetallesEquipo(context, equipo);
        },
      ),
    );
  }

  void _mostrarDetallesEquipo(BuildContext context, Equipo equipo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _obtenerColor(),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.sports_motorsports,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  equipo.nombre,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _DetalleItem(
                  icono: Icons.flag,
                  titulo: 'País',
                  valor: equipo.pais,
                ),
                _DetalleItem(
                  icono: Icons.calendar_today,
                  titulo: 'Fundación',
                  valor: equipo.anioFundacion.toString(),
                ),
                _DetalleItem(
                  icono: Icons.emoji_events,
                  titulo: 'Campeonatos',
                  valor: equipo.campeonatosGanados.toString(),
                ),
              ],
            ),
          );
        },
      ),
    );
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
          Column(
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
        ],
      ),
    );
  }
}
