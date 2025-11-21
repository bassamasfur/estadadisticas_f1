import 'package:flutter/material.dart';
// import removidos porque solo se usan en rutas

class PolePositionView extends StatelessWidget {
  const PolePositionView({super.key});

  final List<String> _secciones = const [
    'Por número',
    'Consecutivamente',
    'Consecutivamente desde inicio',
    'En un año',
    'Por número de años',
    'Años consecutivos',
    'Grandes Premios previos',
    'Por Gran Premio diferente',
    'Pole position y victoria',
    'Pole position sin victoria',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pole Position',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF0F172A),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _secciones.length,
        itemBuilder: (context, index) {
          final nombre = _secciones[index];
          return GestureDetector(
            onTap: () {
              if (index == 0) {
                Navigator.pushNamed(context, '/pole-numero');
              } else if (index == 1) {
                Navigator.pushNamed(context, '/pole-consecutivo');
              } else if (index == 2) {
                Navigator.pushNamed(context, '/pole-consecutivo-debut');
              } else if (index == 3) {
                Navigator.pushNamed(context, '/pole-en-anio');
              } else if (index == 4) {
                Navigator.pushNamed(context, '/pole-numero-anios');
              }
              // Aquí puedes agregar navegación para otras opciones
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.08 * 255).toInt()),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
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
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        nombre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
