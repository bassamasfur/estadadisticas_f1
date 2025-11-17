import 'package:flutter/foundation.dart';
import '../models/piloto.dart';
import '../repositories/piloto_repository.dart';

/// Controlador para gestionar el estado de los pilotos
class PilotoController extends ChangeNotifier {
  final PilotoRepository _repository;

  List<Piloto> _pilotos = [];
  Piloto? _pilotoSeleccionado;
  bool _cargando = false;
  String? _error;

  PilotoController(this._repository);

  // Getters
  List<Piloto> get pilotos => List.unmodifiable(_pilotos);
  Piloto? get pilotoSeleccionado => _pilotoSeleccionado;
  bool get cargando => _cargando;
  String? get error => _error;
  bool get tienePilotos => _pilotos.isNotEmpty;

  /// Carga todos los pilotos del repositorio
  Future<void> cargarPilotos() async {
    _establecerCargando(true);
    _limpiarError();

    try {
      _pilotos = await _repository.obtenerTodos();
      notifyListeners();
    } catch (e) {
      _establecerError('Error al cargar pilotos: $e');
    } finally {
      _establecerCargando(false);
    }
  }

  /// Carga un piloto específico por ID
  Future<void> cargarPiloto(String id) async {
    _establecerCargando(true);
    _limpiarError();

    try {
      _pilotoSeleccionado = await _repository.obtenerPorId(id);
      notifyListeners();
    } catch (e) {
      _establecerError('Error al cargar el piloto: $e');
    } finally {
      _establecerCargando(false);
    }
  }

  /// Obtiene pilotos filtrados por equipo
  Future<void> cargarPilotosPorEquipo(String equipoId) async {
    _establecerCargando(true);
    _limpiarError();

    try {
      _pilotos = await _repository.obtenerPorEquipo(equipoId);
      notifyListeners();
    } catch (e) {
      _establecerError('Error al cargar pilotos del equipo: $e');
    } finally {
      _establecerCargando(false);
    }
  }

  /// Agrega un nuevo piloto
  Future<bool> agregarPiloto(Piloto piloto) async {
    _establecerCargando(true);
    _limpiarError();

    try {
      await _repository.agregar(piloto);
      await cargarPilotos();
      return true;
    } catch (e) {
      _establecerError('Error al agregar el piloto: $e');
      return false;
    } finally {
      _establecerCargando(false);
    }
  }

  /// Actualiza un piloto existente
  Future<bool> actualizarPiloto(Piloto piloto) async {
    _establecerCargando(true);
    _limpiarError();

    try {
      await _repository.actualizar(piloto);
      await cargarPilotos();
      return true;
    } catch (e) {
      _establecerError('Error al actualizar el piloto: $e');
      return false;
    } finally {
      _establecerCargando(false);
    }
  }

  /// Elimina un piloto
  Future<bool> eliminarPiloto(String id) async {
    _establecerCargando(true);
    _limpiarError();

    try {
      await _repository.eliminar(id);
      await cargarPilotos();
      return true;
    } catch (e) {
      _establecerError('Error al eliminar el piloto: $e');
      return false;
    } finally {
      _establecerCargando(false);
    }
  }

  /// Selecciona un piloto
  void seleccionarPiloto(Piloto? piloto) {
    _pilotoSeleccionado = piloto;
    notifyListeners();
  }

  /// Busca pilotos por nombre
  List<Piloto> buscarPilotos(String query) {
    if (query.isEmpty) return _pilotos;

    final queryLower = query.toLowerCase();
    return _pilotos.where((piloto) {
      return piloto.nombre.toLowerCase().contains(queryLower) ||
          piloto.apellido.toLowerCase().contains(queryLower) ||
          piloto.nombreCompleto.toLowerCase().contains(queryLower);
    }).toList();
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
