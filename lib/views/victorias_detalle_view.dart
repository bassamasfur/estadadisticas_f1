import 'package:flutter/material.dart';
import '../widgets/opcion_list_tile.dart';
import 'victorias_por_numero_view.dart';
import 'victorias_consecutivamente_view.dart';
import 'victorias_en_un_anio_view.dart';
import 'victorias_por_numero_anios_view.dart';
import 'victorias_anios_consecutivos_view.dart';
import 'victorias_carreras_antes_view.dart';
import 'victorias_sin_pole_view.dart';
import 'victorias_vuelta_rapida_view.dart';

/// Vista de detalles de Victorias con diferentes opciones de visualización
class VictoriasDetalleView extends StatelessWidget {
  const VictoriasDetalleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Victorias',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
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
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            OpcionListTile(
              titulo: 'Por número',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VictoriasPorNumeroView(),
                  ),
                );
              },
            ),
            OpcionListTile(
              titulo: 'Consecutivamente',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VictoriasConsecutivamenteView(),
                  ),
                );
              },
            ),
            OpcionListTile(
              titulo: 'En un año',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VictoriasEnUnAnioView(),
                  ),
                );
              },
            ),
            OpcionListTile(
              titulo: 'Por número de años',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VictoriasPorNumeroAniosView(),
                  ),
                );
              },
            ),
            OpcionListTile(
              titulo: 'Años consecutivos',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const VictoriasAniosConsecutivosView(),
                  ),
                );
              },
            ),
            OpcionListTile(
              titulo: 'Carreras disputadas antes',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VictoriasCarrerasAntesView(),
                  ),
                );
              },
            ),
            OpcionListTile(
              titulo: 'Victoria sin pole position',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VictoriasSinPoleView(),
                  ),
                );
              },
            ),
            OpcionListTile(
              titulo: 'Victoria y vuelta rápida',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VictoriasVueltaRapidaView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
