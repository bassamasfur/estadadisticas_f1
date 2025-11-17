import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar mensaje cuando no hay datos
class EmptyStateWidget extends StatelessWidget {
  final String mensaje;
  final IconData? icono;
  final VoidCallback? onAccion;
  final String? textoAccion;

  const EmptyStateWidget({
    super.key,
    required this.mensaje,
    this.icono,
    this.onAccion,
    this.textoAccion,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icono ?? Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            if (onAccion != null && textoAccion != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onAccion, child: Text(textoAccion!)),
            ],
          ],
        ),
      ),
    );
  }
}
