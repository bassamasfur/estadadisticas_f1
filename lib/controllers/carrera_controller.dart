import 'package:flutter/foundation.dart';
import '../models/carrera.dart';
import '../repositories/carrera_repository.dart';

/// Controlador para gestionar el estado de las carreras
class CarreraController extends ChangeNotifier {
  final CarreraRepository _repository;

  List<Carrera> _carreras = [];
  Carrera? _carreraSeleccionada;
  bool _cargando = false;
  String? _error;

  CarreraController(this._repository);

  // Getters
  List<Carrera> get carreras => List.unmodifiable(_carreras);
  Carrera? get carreraSeleccionada => _carreraSeleccionada;
  bool get cargando => _cargando;
  String? get error => _error;
  bool get tieneCarreras => _carreras.isNotEmpty;

  /// Carga todas las carreras del repositorio
  Future<void> cargarCarreras() async {
    _establecerCargando(true);
    _limpiarError();

    try {
      _carreras = await _repository.obtenerTodas();
      _ordenarCarrerasPorFecha();
      notifyListeners();
    } catch (e) {
      _establecerError('Error al cargar carreras: $e');
    } finally {
      _establecerCargando(false);
    }
  }

  /// Carga una carrera específica por ID
  Future<void> cargarCarrera(String id) async {
    _establecerCargando(true);
    _limpiarError();

    try {
      _carreraSeleccionada = await _repository.obtenerPorId(id);
      notifyListeners();
    } catch (e) {
      _establecerError('Error al cargar la carrera: $e');
    } finally {
      _establecerCargando(false);
    }
  }

  /// Obtiene carreras de un año específico
  Future<void> cargarCarrerasPorAnio(int anio) async {
    _establecerCargando(true);
    _limpiarError();

    try {
      _carreras = await _repository.obtenerPorAnio(anio);
      _ordenarCarrerasPorFecha();
      notifyListeners();
    } catch (e) {
      _establecerError('Error al cargar carreras del año: $e');
    } finally {
      _establecerCargando(false);
    }
  }

  /// Agrega una nueva carrera
  Future<bool> agregarCarrera(Carrera carrera) async {
    _establecerCargando(true);
    _limpiarError();

    try {
      await _repository.agregar(carrera);
      await cargarCarreras();
      return true;
    } catch (e) {
      _establecerError('Error al agregar la carrera: $e');
      return false;
    } finally {
      _establecerCargando(false);
    }
  }

  /// Actualiza una carrera existente
  Future<bool> actualizarCarrera(Carrera carrera) async {
    _establecerCargando(true);
    _limpiarError();

    try {
      await _repository.actualizar(carrera);
      await cargarCarreras();
      return true;
    } catch (e) {
      _establecerError('Error al actualizar la carrera: $e');
      return false;
    } finally {
      _establecerCargando(false);
    }
  }

  /// Elimina una carrera
  Future<bool> eliminarCarrera(String id) async {
    _establecerCargando(true);
    _limpiarError();

    try {
      await _repository.eliminar(id);
      await cargarCarreras();
      return true;
    } catch (e) {
      _establecerError('Error al eliminar la carrera: $e');
      return false;
    } finally {
      _establecerCargando(false);
    }
  }

  /// Selecciona una carrera
  void seleccionarCarrera(Carrera? carrera) {
    _carreraSeleccionada = carrera;
    notifyListeners();
  }

  /// Obtiene las carreras futuras (no realizadas)
  List<Carrera> obtenerCarrerasFuturas() {
    return _carreras.where((carrera) => !carrera.yaRealizada).toList();
  }

  /// Obtiene las carreras pasadas (ya realizadas)
  List<Carrera> obtenerCarrerasPasadas() {
    return _carreras.where((carrera) => carrera.yaRealizada).toList();
  }

  /// Obtiene la próxima carrera
  Carrera? obtenerProximaCarrera() {
    final futuras = obtenerCarrerasFuturas();
    return futuras.isNotEmpty ? futuras.first : null;
  }

  /// Busca carreras por nombre o país
  List<Carrera> buscarCarreras(String query) {
    if (query.isEmpty) return _carreras;

    final queryLower = query.toLowerCase();
    return _carreras.where((carrera) {
      return carrera.nombre.toLowerCase().contains(queryLower) ||
          carrera.circuito.toLowerCase().contains(queryLower) ||
          carrera.pais.toLowerCase().contains(queryLower);
    }).toList();
  }

  void _ordenarCarrerasPorFecha() {
    _carreras.sort((a, b) => a.fecha.compareTo(b.fecha));
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
