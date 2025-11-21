import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PoleAniosConsecutivosView extends StatefulWidget {
  const PoleAniosConsecutivosView({super.key});

  @override
  State<PoleAniosConsecutivosView> createState() =>
      _PoleAniosConsecutivosViewState();
}

class _PoleAniosConsecutivosViewState extends State<PoleAniosConsecutivosView> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _data = [];

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
        Uri.parse(
          'https://f1-l1f0twqsl-bassans-projects.vercel.app/api/poles/poles-annee-consecutive',
        ),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<Map<String, dynamic>> dataList =
            List<Map<String, dynamic>>.from(json['data']);
        dataList.sort((a, b) {
          final tA = a['temporadas'] is int
              ? a['temporadas']
              : int.tryParse(a['temporadas'].toString()) ?? 0;
          final tB = b['temporadas'] is int
              ? b['temporadas']
              : int.tryParse(b['temporadas'].toString()) ?? 0;
          return tB.compareTo(tA);
        });
        setState(() {
          _data = dataList;
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
        centerTitle: true,
        title: const Text(
          'Pole Position años consecutivos',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
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
                final piloto = item['nombre']?.toString() ?? '';
                final temporadas = item['temporadas']?.toString() ?? '';
                final inicio = item['inicio']?.toString() ?? '';
                final fin = item['fin']?.toString() ?? '';
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.transparent, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
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
                        CircleAvatar(
                          backgroundColor: const Color(0xFF22C55E),
                          radius: 16,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
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
                                'Temporadas: $temporadas',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Inicio: $inicio',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Fin: $fin',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.flag, color: Colors.white, size: 28),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
