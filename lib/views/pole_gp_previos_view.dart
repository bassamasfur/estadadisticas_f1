import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PoleGpPreviosView extends StatefulWidget {
  const PoleGpPreviosView({super.key});

  @override
  State<PoleGpPreviosView> createState() => _PoleGpPreviosViewState();
}

class _PoleGpPreviosViewState extends State<PoleGpPreviosView> {
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
          'https://f1-60ew7wpse-bassans-projects.vercel.app/api/poles/gp-poles-antes',
        ),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<Map<String, dynamic>> dataList =
            List<Map<String, dynamic>>.from(json['data']);
        // Sort by 'carreras' descending
        dataList.sort((a, b) {
          final aCarreras = int.tryParse(a['carreras']?.toString() ?? '') ?? 0;
          final bCarreras = int.tryParse(b['carreras']?.toString() ?? '') ?? 0;
          return bCarreras.compareTo(aCarreras);
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
          'Grandes Premios previos',
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
                final nombre = item['nombre']?.toString() ?? '';
                final carreras = item['carreras']?.toString() ?? '';
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
                                nombre,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Carreras previas: $carreras',
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
