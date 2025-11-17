import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar mensajes de error
class ErrorWidget extends StatelessWidget {
  final String mensaje;
  final VoidCallback? onReintentar;

  const ErrorWidget({super.key, required this.mensaje, this.onReintentar});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onReintentar != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onReintentar,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
