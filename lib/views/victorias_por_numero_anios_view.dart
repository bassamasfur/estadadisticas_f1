import 'package:flutter/material.dart';
import '../services/victorias_service.dart';

class VictoriasPorNumeroAniosView extends StatefulWidget {
  const VictoriasPorNumeroAniosView({super.key});

  @override
  State<VictoriasPorNumeroAniosView> createState() =>
      _VictoriasPorNumeroAniosViewState();
}

class _VictoriasPorNumeroAniosViewState
    extends State<VictoriasPorNumeroAniosView> {
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
      final datos = await _service.obtenerPilotosPorAniosConVictorias();
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
          'Victorias - Años con victorias',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF0F172A),
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
                final anios = piloto['anios'] as int;

                // Color oscuro y badge según posición
                Color backgroundColor = const Color(0xFF1E293B);
                Color? badgeColor;
                if (posicion == 1) {
                  badgeColor = const Color(0xFFE10600);
                } else if (posicion == 2) {
                  badgeColor = const Color(0xFF60A5FA);
                } else if (posicion == 3) {
                  badgeColor = const Color(0xFFFBBF24);
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: posicion <= 3
                        ? Border.all(color: badgeColor!, width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.15 * 255).toInt()),
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
                          child: Text(
                            piloto['nombre'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Badge de años
                        Container(
                          constraints: const BoxConstraints(minWidth: 60),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF4CAF50,
                            ).withAlpha((0.15 * 255).toInt()),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$anios',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                anios == 1 ? 'año' : 'años',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[300],
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
