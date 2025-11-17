import 'package:flutter/material.dart';

/// Vista que muestra victorias por Gran Premio
class VictoriasPorGranPremioView extends StatelessWidget {
  const VictoriasPorGranPremioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Victorias - Por Gran Premio'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.flag, size: 64, color: Color(0xFF66BB6A)),
              SizedBox(height: 16),
              Text(
                'Próximamente',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Victorias en cada Gran Premio',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
