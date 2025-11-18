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
        title: const Text(
          'Victorias sin pole position',
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
              child: Text(
                'Error: $_error',
                style: TextStyle(color: Colors.white),
              ),
            )
          : _pilotos.isEmpty
          ? const Center(
              child: Text(
                'No hay datos disponibles',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pilotos.length,
              itemBuilder: (context, index) {
                final piloto = _pilotos[index];
                final nombre = piloto['nombre'] ?? '';
                final victoria = piloto['victoria'] ?? '';
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  color: const Color(0xFF23283A),
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
                    title: Text(
                      nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
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
