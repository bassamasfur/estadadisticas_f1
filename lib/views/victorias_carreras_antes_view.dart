// Página: Carreras antes de primera victoria
import 'package:flutter/material.dart';
import '../services/victorias_service.dart';

class VictoriasCarrerasAntesView extends StatefulWidget {
  const VictoriasCarrerasAntesView({super.key});

  @override
  State<VictoriasCarrerasAntesView> createState() =>
      _VictoriasCarrerasAntesViewState();
}

class _VictoriasCarrerasAntesViewState
    extends State<VictoriasCarrerasAntesView> {
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
      final datos = await _service.obtenerCarrerasAntesDeVictoria();
      datos.sort((a, b) {
        final intA = a['carreras'] is int
            ? a['carreras']
            : int.tryParse(a['carreras']?.toString() ?? '') ?? 0;
        final intB = b['carreras'] is int
            ? b['carreras']
            : int.tryParse(b['carreras']?.toString() ?? '') ?? 0;
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
        title: const Text('Carreras antes de victoria'),
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
                final carreras = piloto['carreras'] is int
                    ? piloto['carreras']
                    : int.tryParse(piloto['carreras']?.toString() ?? '') ?? 0;
                final nombre = (piloto['nombre'] ?? '').toString();

                // Color según posición
                Color backgroundColor = const Color(0xFF23283A);
                Color? badgeColor;
                if (posicion == 1) {
                  backgroundColor = const Color(0xFF2C3146);
                  badgeColor = const Color(0xFFE57373);
                } else if (posicion == 2) {
                  backgroundColor = const Color(0xFF23283A);
                  badgeColor = const Color(0xFFFFB74D);
                } else if (posicion == 3) {
                  backgroundColor = const Color(0xFF23283A);
                  badgeColor = const Color(0xFFFFF176);
                } else if (carreras == 0) {
                  backgroundColor = const Color(0xFF23283A);
                  badgeColor = const Color(0xFF66BB6A);
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
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
                            ],
                          ),
                        ),
                        // Badge de carreras
                        Container(
                          width: 70,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: carreras == 0
                                ? const Color(0xFF66BB6A).withOpacity(0.1)
                                : const Color(0xFFEF5350).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                carreras == 0 ? '1ª' : '$carreras',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: carreras == 0
                                      ? const Color(0xFF66BB6A)
                                      : const Color(0xFFEF5350),
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                carreras == 0 ? 'carrera' : 'carreras',
                                style: const TextStyle(
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
