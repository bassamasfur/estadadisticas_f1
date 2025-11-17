import 'package:flutter/foundation.dart';
import '../models/campeon_mundial.dart';
import '../services/wikipedia_f1_service.dart';

/// Controlador para gestionar los campeones mundiales de F1
class CampeonesController extends ChangeNotifier {
  final WikipediaF1Service _wikipediaService;

  List<CampeonMundial> _campeones = [];
  bool _cargando = false;
  String? _error;

  CampeonesController(this._wikipediaService);

  // Getters
  List<CampeonMundial> get campeones => List.unmodifiable(_campeones);
  bool get cargando => _cargando;
  String? get error => _error;
  bool get tieneCampeones => _campeones.isNotEmpty;

  /// Carga todos los campeones mundiales desde Wikipedia
  Future<void> cargarCampeones() async {
    debugPrint('🎯 CampeonesController: Iniciando carga de campeones...');
    _establecerCargando(true);
    _limpiarError();

    try {
      _campeones = await _wikipediaService.obtenerTodosCampeones();
      // Ordenar por año descendente (más reciente primero)
      _campeones.sort((a, b) => b.temporada.compareTo(a.temporada));
      debugPrint(
        '✅ CampeonesController: ${_campeones.length} campeones cargados',
      );
      notifyListeners();
    } catch (e) {
      _establecerError('Error al cargar campeones: $e');
    } finally {
      _establecerCargando(false);
    }
  }

  /// Obtiene campeones agrupados por piloto con conteo de títulos
  Map<String, int> obtenerTitulosPorPiloto() {
    final titulos = <String, int>{};
    for (var campeon in _campeones) {
      final nombre = campeon.nombreCompleto;
      titulos[nombre] = (titulos[nombre] ?? 0) + 1;
    }
    return titulos;
  }

  /// Obtiene la lista de campeones ordenados por número de títulos
  List<MapEntry<String, int>> obtenerRankingCampeones() {
    final titulos = obtenerTitulosPorPiloto();
    final ranking = titulos.entries.toList();
    ranking.sort((a, b) => b.value.compareTo(a.value));
    return ranking;
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
