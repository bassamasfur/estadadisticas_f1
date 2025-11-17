import 'package:flutter/foundation.dart';
import '../models/estadisticas_f1.dart';

/// Controlador para gestionar el estado de las estadísticas generales
class EstadisticasController extends ChangeNotifier {
  EstadisticasF1 _estadisticas = EstadisticasF1.vacio();
  bool _cargando = false;
  String? _error;

  // Getters
  EstadisticasF1 get estadisticas => _estadisticas;
  bool get cargando => _cargando;
  String? get error => _error;

  /// Carga las estadísticas generales
  Future<void> cargarEstadisticas() async {
    _establecerCargando(true);
    _limpiarError();

    try {
      // Simular una llamada asíncrona a una API o BD
      await Future.delayed(const Duration(milliseconds: 800));

      // Datos de ejemplo - En producción vendrían de una API
      _estadisticas = EstadisticasF1(
        titulos: 7,
        victorias: 105,
        polePositions: 104,
        podiums: 202,
        puntos: 5010,
        carreras: 422,
      );

      notifyListeners();
    } catch (e) {
      _establecerError('Error al cargar estadísticas: $e');
    } finally {
      _establecerCargando(false);
    }
  }

  /// Actualiza las estadísticas
  Future<void> actualizarEstadisticas(EstadisticasF1 nuevasEstadisticas) async {
    _establecerCargando(true);
    _limpiarError();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _estadisticas = nuevasEstadisticas;
      notifyListeners();
    } catch (e) {
      _establecerError('Error al actualizar estadísticas: $e');
    } finally {
      _establecerCargando(false);
    }
  }

  /// Reinicia las estadísticas
  void reiniciarEstadisticas() {
    _estadisticas = EstadisticasF1.vacio();
    _limpiarError();
    notifyListeners();
  }

  void _establecerCargando(bool valor) {
    _cargando = valor;
    notifyListeners();
  }

  void _establecerError(String mensaje) {
    _error = mensaje;
    notifyListeners();
  }

  void _limpiarError() {
    _error = null;
  }
}
