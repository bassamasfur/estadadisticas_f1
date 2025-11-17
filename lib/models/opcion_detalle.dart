import 'package:flutter/foundation.dart';

/// Modelo para una opción de menú de detalles
class OpcionDetalle {
  final String titulo;
  final String? subtitulo;
  final VoidCallback? onTap;

  OpcionDetalle({required this.titulo, this.subtitulo, this.onTap});
}
