import 'package:flutter/material.dart';
import '../services/victorias_service.dart';

/// Vista que muestra años consecutivos con victorias
class VictoriasAniosConsecutivosView extends StatefulWidget {
  const VictoriasAniosConsecutivosView({super.key});

  @override
  State<VictoriasAniosConsecutivosView> createState() =>
      _VictoriasAniosConsecutivosViewState();
}

class _VictoriasAniosConsecutivosViewState
    extends State<VictoriasAniosConsecutivosView> {
  final VictoriasService _service = VictoriasService();
  List<Map<String, dynamic>> _pilotos = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      setState(() {
        _cargando = true;
        _error = null;
      });

      final datos = await _service.obtenerAniosConsecutivosConVictorias();
      // Ordenar de mayor a menor por años consecutivos
      datos.sort((a, b) {
        final intA = a['anios'] is int
            ? a['anios']
            : int.tryParse(a['anios']?.toString() ?? '') ?? 0;
        final intB = b['anios'] is int
            ? b['anios']
            : int.tryParse(b['anios']?.toString() ?? '') ?? 0;
        return intB.compareTo(intA);
      });
      setState(() {
        _pilotos = datos;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Años consecutivos',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF181C24),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF181C24),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: $_error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _cargarDatos,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pilotos.length,
              itemBuilder: (context, index) {
                final piloto = _pilotos[index];
                final posicion = index + 1;
                final aniosConsecutivos = piloto['anios'] is int
                    ? piloto['anios']
                    : int.tryParse(piloto['anios']?.toString() ?? '') ?? 0;
                final nombre = (piloto['nombre'] ?? '').toString();
                final inicio = piloto['inicio']?.toString() ?? '';
                final fin = piloto['fin']?.toString() ?? '';
                final periodo = (inicio.isNotEmpty && fin.isNotEmpty)
                    ? '$inicio - $fin'
                    : '';

                // Color según posición
                Color backgroundColor = const Color(0xFF23283A);
                Color? badgeColor;
                if (posicion == 1) {
                  backgroundColor = const Color(0xFF2C3146);
                  badgeColor = const Color(0xFFFBC02D);
                } else if (posicion == 2) {
                  backgroundColor = const Color(0xFF23283A);
                  badgeColor = const Color(0xFF757575);
                } else if (posicion == 3) {
                  backgroundColor = const Color(0xFF23283A);
                  badgeColor = const Color(0xFFFF6F00);
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.05 * 255).toInt()),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Número de posición
                        CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              badgeColor ?? const Color(0xFF2196F3),
                          child: Text(
                            '$posicion',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Información del piloto
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                nombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (periodo.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF42A5F5,
                                    ).withAlpha((0.2 * 255).toInt()),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    periodo,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF90CAF9),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Badge de años
                        Container(
                          constraints: const BoxConstraints(minWidth: 70),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF66BB6A,
                            ).withAlpha((0.1 * 255).toInt()),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$aniosConsecutivos',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF66BB6A),
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                aniosConsecutivos == 1 ? 'año' : 'años',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFB0BEC5),
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
