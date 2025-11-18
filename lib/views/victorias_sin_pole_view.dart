import 'package:flutter/material.dart';
import '../services/victorias_service.dart';

class VictoriasSinPoleView extends StatefulWidget {
  const VictoriasSinPoleView({super.key});

  @override
  State<VictoriasSinPoleView> createState() => _VictoriasSinPoleViewState();
}

class _VictoriasSinPoleViewState extends State<VictoriasSinPoleView> {
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
      final datos = await _service.obtenerVictoriasSinPole();
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
        title: const Text('Victorias sin pole position'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : _pilotos.isEmpty
          ? const Center(child: Text('No hay datos disponibles'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pilotos.length,
              itemBuilder: (context, index) {
                final piloto = _pilotos[index];
                final nombre = piloto['nombre'] ?? '';
                final victoria = piloto['victoria'] ?? '';
                final porcentaje = piloto['porcentaje'] ?? 0.0;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
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
                            nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${porcentaje.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Color(0xFF1E88E5),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF66BB6A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        victoria,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
