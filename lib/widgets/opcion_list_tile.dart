import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar una opción en una lista con diseño elegante
class OpcionListTile extends StatefulWidget {
  final String titulo;
  final String? subtitulo;
  final VoidCallback? onTap;

  const OpcionListTile({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.onTap,
  });

  @override
  State<OpcionListTile> createState() => _OpcionListTileState();
}

class _OpcionListTileState extends State<OpcionListTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isPressed
                ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                : [const Color(0xFF1E293B), const Color(0xFF334155)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isPressed
                ? const Color(0xFF3B82F6)
                : const Color(0xFF3B82F6).withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isPressed
                  ? const Color(0xFF3B82F6).withValues(alpha: 0.4)
                  : const Color(0xFF3B82F6).withValues(alpha: 0.2),
              blurRadius: _isPressed ? 16 : 10,
              spreadRadius: _isPressed ? 2 : 0,
              offset: Offset(0, _isPressed ? 2 : 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFF3B82F6).withValues(alpha: 0.15),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  // Indicador decorativo con gradiente
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E40AF).withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Contenido
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.titulo,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        if (widget.subtitulo != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitulo!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Icono de flecha con efecto
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
