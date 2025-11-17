import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/campeones_controller.dart';
import '../models/campeon_mundial.dart';

/// Vista que muestra los campeones con sus rachas de títulos consecutivos
class TitulosConsecutivamenteView extends StatefulWidget {
  const TitulosConsecutivamenteView({super.key});

  @override
  State<TitulosConsecutivamenteView> createState() =>
      _TitulosConsecutivamenteViewState();
}

class _TitulosConsecutivamenteViewState
    extends State<TitulosConsecutivamenteView> {
  bool _ordenInverso = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Títulos Consecutivos',
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
                ? 'Menos rachas primero'
                : 'Más rachas primero',
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
                      'Cargando campeones...',
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

            final campeonesConRachas = _obtenerCampeonesConRachas(
              controller.campeones,
            );

            if (campeonesConRachas.isEmpty) {
              return const Center(
                child: Text(
                  'No hay datos disponibles',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final rachasOrdenadas = _ordenInverso
                ? campeonesConRachas.reversed.toList()
                : campeonesConRachas;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: rachasOrdenadas.length,
              itemBuilder: (context, index) {
                final item = rachasOrdenadas[index];
                return _RachaCampeonCard(posicion: index + 1, racha: item);
              },
            );
          },
        ),
      ),
    );
  }

  /// Agrupa campeones y detecta rachas consecutivas
  List<_RachaCampeon> _obtenerCampeonesConRachas(
    List<CampeonMundial> campeones,
  ) {
    if (campeones.isEmpty) return [];

    // Ordenar por año
    final campeonesOrdenados = List<CampeonMundial>.from(campeones)
      ..sort((a, b) => a.temporada.compareTo(b.temporada));

    // Agrupar por piloto
    final Map<String, List<CampeonMundial>> campeonMap = {};
    for (var campeon in campeonesOrdenados) {
      final key = '${campeon.nombre} ${campeon.apellido}';
      campeonMap.putIfAbsent(key, () => []);
      campeonMap[key]!.add(campeon);
    }

    // Detectar rachas consecutivas para cada piloto
    List<_RachaCampeon> rachas = [];

    for (var entry in campeonMap.entries) {
      final pilotoNombre = entry.key;
      final titulos = entry.value;

      if (titulos.length == 1) {
        // Solo un título, no es racha pero lo mostramos
        rachas.add(
          _RachaCampeon(
            nombre: pilotoNombre,
            pais: titulos[0].nacionalidad,
            equipos: {titulos[0].equipoNombre},
            rachaConsecutiva: 1,
            anos: [titulos[0].temporada],
          ),
        );
      } else {
        // Detectar rachas consecutivas
        List<List<CampeonMundial>> rachitas = [];
        List<CampeonMundial> rachaActual = [titulos[0]];

        for (int i = 1; i < titulos.length; i++) {
          if (int.parse(titulos[i].temporada) ==
              int.parse(titulos[i - 1].temporada) + 1) {
            // Consecutivo
            rachaActual.add(titulos[i]);
          } else {
            // Se rompió la racha
            rachitas.add(rachaActual);
            rachaActual = [titulos[i]];
          }
        }
        rachitas.add(rachaActual);

        // Tomar la racha más larga
        rachitas.sort((a, b) => b.length.compareTo(a.length));
        final rachaMaxima = rachitas[0];

        final equiposRacha = rachaMaxima.map((c) => c.equipoNombre).toSet();
        final anosRacha = rachaMaxima.map((c) => c.temporada).toList();

        rachas.add(
          _RachaCampeon(
            nombre: pilotoNombre,
            pais: rachaMaxima[0].nacionalidad,
            equipos: equiposRacha,
            rachaConsecutiva: rachaMaxima.length,
            anos: anosRacha,
          ),
        );
      }
    }

    // Ordenar por racha más larga primero
    rachas.sort((a, b) => b.rachaConsecutiva.compareTo(a.rachaConsecutiva));

    return rachas;
  }
}

/// Modelo interno para representar una racha de campeonatos
class _RachaCampeon {
  final String nombre;
  final String pais;
  final Set<String> equipos;
  final int rachaConsecutiva;
  final List<String> anos;

  _RachaCampeon({
    required this.nombre,
    required this.pais,
    required this.equipos,
    required this.rachaConsecutiva,
    required this.anos,
  });
}

/// Widget de tarjeta para mostrar una racha de campeonatos
class _RachaCampeonCard extends StatelessWidget {
  final int posicion;
  final _RachaCampeon racha;

  const _RachaCampeonCard({required this.posicion, required this.racha});

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

            // Badge de racha consecutiva
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF60A5FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    '${racha.rachaConsecutiva}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    racha.rachaConsecutiva > 1 ? 'seguidos' : 'título',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
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
                    racha.nombre,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Años de la racha
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        racha.rachaConsecutiva > 1
                            ? '${racha.anos.first} - ${racha.anos.last}'
                            : racha.anos.first,
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                    ],
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
                          racha.equipos.join(', '),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[400],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
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
                _obtenerCodigoPais(racha.pais),
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

  String _obtenerCodigoPais(String pais) {
    final Map<String, String> codigos = {
      'Argentina': 'ARG',
      'Reino Unido': 'GBR',
      'Alemania': 'GER',
      'Brasil': 'BRA',
      'Austria': 'AUT',
      'Australia': 'AUS',
      'Italia': 'ITA',
      'Francia': 'FRA',
      'Finlandia': 'FIN',
      'España': 'ESP',
      'Países Bajos': 'NED',
      'Canadá': 'CAN',
      'Nueva Zelanda': 'NZL',
      'Estados Unidos': 'USA',
      'Sudáfrica': 'RSA',
      'Bélgica': 'BEL',
    };
    return codigos[pais] ?? pais.substring(0, 3).toUpperCase();
  }
}
