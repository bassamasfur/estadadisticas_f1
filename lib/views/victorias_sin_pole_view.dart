import 'package:flutter/material.dart';

class VictoriasSinPoleView extends StatelessWidget {
  const VictoriasSinPoleView({Key? key}) : super(key: key);

  final List<Map<String, String>> pilotos = const [
    {
      'nombre': 'Fernando',
      'apellido': 'Alonso',
      'pais': 'España',
      'victoria': 'Hungría 2003',
    },
    {
      'nombre': 'Jenson',
      'apellido': 'Button',
      'pais': 'Reino Unido',
      'victoria': 'Hungría 2006',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Victorias sin pole position'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: pilotos.isEmpty
          ? const Center(child: Text('No hay datos disponibles'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pilotos.length,
              itemBuilder: (context, index) {
                final piloto = pilotos[index];
                final nombre = piloto['nombre'] ?? '';
                final apellido = piloto['apellido'] ?? '';
                final pais = piloto['pais'] ?? '';
                final victoria = piloto['victoria'] ?? '';
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
                    title: Text(
                      '$nombre${apellido.isNotEmpty ? ' $apellido' : ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      pais,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
