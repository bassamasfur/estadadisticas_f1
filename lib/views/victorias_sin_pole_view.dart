import 'package:flutter/material.dart';
import '../services/victorias_service.dart';

/// Vista que muestra victorias sin haber largado desde pole position
class VictoriasSinPoleView extends StatefulWidget {
  const VictoriasSinPoleView({super.key});

  @override
  State<VictoriasSinPoleView> createState() => _VictoriasSinPoleViewState();
}

class _VictoriasSinPoleViewState extends State<VictoriasSinPoleView> {
  final VictoriasService _service = VictoriasService();
  List<Map<String, dynamic>> _pilotos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final datos = await _service.obtenerVictoriasSinPole();
    if (mounted) {
      setState(() {
        _pilotos = datos;
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Victorias sin pole position'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: _cargando
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Cargando datos históricos...',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    'Esto puede tomar unos momentos',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            )
          : _pilotos.isEmpty
          ? const Center(child: Text('No hay datos disponibles'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pilotos.length,
              itemBuilder: (context, index) {
                final piloto = _pilotos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF1E88E5),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${piloto['nombre']} ${piloto['apellido']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF66BB6A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${piloto['victorias_sin_pole']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        piloto['pais'] as String,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                    children: [
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ejemplos de victorias sin pole:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...((piloto['ejemplos'] as List).map((ejemplo) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF1E88E5),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${ejemplo['carrera']} ${ejemplo['año']} (salió P${ejemplo['posicion_salida']})',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList()),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
