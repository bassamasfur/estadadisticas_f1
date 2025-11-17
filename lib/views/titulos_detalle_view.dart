import 'package:flutter/material.dart';
import '../widgets/opcion_list_tile.dart';
import 'titulos_por_numero_view.dart';
import 'titulos_cronologia_view.dart';
import 'titulos_por_edad_view.dart';
import 'titulos_consecutivamente_view.dart';
import 'titulos_temporadas_antes_view.dart';
import 'titulos_victorias_view.dart';
import 'titulos_constructores_view.dart';
import 'titulos_vicecampeon_view.dart';

/// Vista de detalles de Títulos con diferentes opciones de visualización
class TitulosDetalleView extends StatelessWidget {
  const TitulosDetalleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Títulos',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
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
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          children: [
            OpcionListTile(
              titulo: 'Por número',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TitulosPorNumeroView(),
                  ),
                );
              },
            ),
            OpcionListTile(
              titulo: 'Cronología',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TitulosCronologiaView(),
                  ),
                );
              },
            ),
            OpcionListTile(
              titulo: 'Por edad',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TitulosPorEdadView(),
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
                    builder: (context) => const TitulosConsecutivamenteView(),
                  ),
                );
              },
            ),
            OpcionListTile(
              titulo: 'Temporada disputados antes',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TitulosTemporadasAntesView(),
                  ),
                );
              },
            ),
            OpcionListTile(
              titulo: 'Victorias',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TitulosVictoriasView(),
                  ),
                );
              },
            ),
            OpcionListTile(
              titulo: 'Diferentes Constructores',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TitulosConstructoresView(),
                  ),
                );
              },
            ),
            OpcionListTile(
              titulo: 'Vice-campeón',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TitulosVicecampeonView(),
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
