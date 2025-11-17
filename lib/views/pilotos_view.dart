import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/piloto_controller.dart';
import '../models/piloto.dart';

/// Vista que muestra la lista de pilotos actuales
class PilotosView extends StatefulWidget {
  const PilotosView({super.key});

  @override
  State<PilotosView> createState() => _PilotosViewState();
}

class _PilotosViewState extends State<PilotosView> {
  @override
  void initState() {
    super.initState();
    // Cargar pilotos al iniciar la vista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PilotoController>().cargarPilotos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PilotoController>(
      builder: (context, controller, child) {
        if (controller.cargando && !controller.tienePilotos) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando pilotos actuales...'),
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
                  onPressed: () => controller.cargarPilotos(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (!controller.tienePilotos) {
          return const Center(child: Text('No hay pilotos disponibles'));
        }

        return RefreshIndicator(
          onRefresh: () => controller.cargarPilotos(),
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
              itemCount: controller.pilotos.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final piloto = controller.pilotos[index];
                return _PilotoCard(piloto: piloto);
              },
            ),
          ),
        );
      },
    );
  }
}

/// Tarjeta que muestra la información de un piloto
class _PilotoCard extends StatelessWidget {
  final Piloto piloto;

  const _PilotoCard({required this.piloto});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: const Color(0xFF1E293B),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF3B82F6),
          child: Text(
            piloto.numero,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          piloto.nombreCompleto,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              piloto.nacionalidad,
              style: TextStyle(color: Colors.grey[300]),
            ),
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
                  '${piloto.puntos} puntos',
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
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navegar a detalles del piloto
          _mostrarDetallesPiloto(context, piloto);
        },
      ),
    );
  }

  void _mostrarDetallesPiloto(BuildContext context, Piloto piloto) {
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
                Text(
                  piloto.nombreCompleto,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _DetalleItem(
                  icono: Icons.numbers,
                  titulo: 'Número',
                  valor: piloto.numero,
                ),
                _DetalleItem(
                  icono: Icons.flag,
                  titulo: 'Nacionalidad',
                  valor: piloto.nacionalidad,
                ),
                _DetalleItem(
                  icono: Icons.cake,
                  titulo: 'Fecha de Nacimiento',
                  valor: piloto.fechaNacimiento,
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
