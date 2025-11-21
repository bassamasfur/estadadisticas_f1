import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PoleNumeroView extends StatefulWidget {
  const PoleNumeroView({super.key});

  @override
  State<PoleNumeroView> createState() => _PoleNumeroViewState();
}

class _PoleNumeroViewState extends State<PoleNumeroView> {
  bool _loading = true;
  String? _error;
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await http.get(
        Uri.parse('https://f1-api-one.vercel.app/api/poles/pole-numero'),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final dataList = (json['data'] as List<dynamic>);
        setState(() {
          _data = dataList..sort((a, b) => b['poles'].compareTo(a['poles']));
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Error: ${response.statusCode}';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pole Position por número'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF0F172A),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _data[index];
                final piloto = item['nombre'] ?? '';
                final poles = item['poles'] as int? ?? 0;
                final porcentaje = item['porcentaje'] ?? 0.0;
                Color bgColor;
                Color borderColor = Colors.transparent;
                Color numColor;
                String etiqueta = '';
                Color etiquetaColor = Colors.transparent;
                if (index == 0) {
                  bgColor = Color(0xFF14532D);
                  borderColor = Color(0xFFEF4444);
                  numColor = Color(0xFF22C55E);
                  etiqueta = 'MÁXIMO POLE';
                  etiquetaColor = Color(0xFFFB923C);
                } else if (index == 1) {
                  bgColor = Color(0xFF1E293B);
                  numColor = Color(0xFF22C55E);
                  etiqueta = 'LEYENDA';
                  etiquetaColor = Color(0xFFFACC15);
                } else if (index == 2) {
                  bgColor = Color(0xFF1E293B);
                  numColor = Color(0xFF22C55E);
                  etiqueta = 'TOP 3';
                  etiquetaColor = Color(0xFF38BDF8);
                } else {
                  bgColor = Color(0xFF1E293B);
                  numColor = [
                    Color(0xFF22C55E),
                    Color(0xFFF59E42),
                    Color(0xFF3B82F6),
                    Color(0xFF3B82F6),
                  ][index % 4];
                }
                return Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: borderColor,
                      width: index < 3 ? 2 : 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    child: Row(
                      children: [
                        // Número y poles
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: numColor,
                              radius: 16,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: numColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '$poles poles',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        // Info piloto y porcentaje
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                piloto,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Porcentaje: ${porcentaje.toStringAsFixed(2)}%',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              if (etiqueta.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: etiquetaColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    etiqueta,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Icono bandera
                        const SizedBox(width: 10),
                        Icon(Icons.flag, color: Colors.white, size: 28),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
