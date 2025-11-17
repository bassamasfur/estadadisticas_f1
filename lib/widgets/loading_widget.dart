import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar un indicador de carga
class LoadingWidget extends StatelessWidget {
  final String? mensaje;

  const LoadingWidget({super.key, this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (mensaje != null) ...[
            const SizedBox(height: 16),
            Text(mensaje!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
