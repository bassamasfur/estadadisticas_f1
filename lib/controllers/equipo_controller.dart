import 'package:flutter/foundation.dart';
import '../models/equipo.dart';
import '../repositories/equipo_repository.dart';

/// Controlador para gestionar el estado de los equipos
class EquipoController extends ChangeNotifier {
  final EquipoRepository _repository;

  List<Equipo> _equipos = [];
  Equipo? _equipoSeleccionado;
  bool _cargando = false;
  String? _error;

  EquipoController(this._repository);

  // Getters
  List<Equipo> get equipos => List.unmodifiable(_equipos);
  Equipo? get equipoSeleccionado => _equipoSeleccionado;
  bool get cargando => _cargando;
  String? get error => _error;
  bool get tieneEquipos => _equipos.isNotEmpty;

  /// Carga todos los equipos del repositorio
  Future<void> cargarEquipos() async {
    _establecerCargando(true);
    _limpiarError();

    try {
      _equipos = await _repository.obtenerTodos();
      notifyListeners();
    } catch (e) {
      _establecerError('Error al cargar equipos: $e');
    } finally {
      _establecerCargando(false);
    }
  }

  /// Carga un equipo específico por ID
  Future<void> cargarEquipo(String id) async {
    _establecerCargando(true);
    _limpiarError();

    try {
      _equipoSeleccionado = await _repository.obtenerPorId(id);
      notifyListeners();
    } catch (e) {
      _establecerError('Error al cargar el equipo: $e');
    } finally {
      _establecerCargando(false);
    }
  }

  /// Agrega un nuevo equipo
  Future<bool> agregarEquipo(Equipo equipo) async {
    _establecerCargando(true);
    _limpiarError();

    try {
      await _repository.agregar(equipo);
      await cargarEquipos();
      return true;
    } catch (e) {
      _establecerError('Error al agregar el equipo: $e');
      return false;
    } finally {
      _establecerCargando(false);
    }
  }

  /// Actualiza un equipo existente
  Future<bool> actualizarEquipo(Equipo equipo) async {
    _establecerCargando(true);
    _limpiarError();

    try {
      await _repository.actualizar(equipo);
      await cargarEquipos();
      return true;
    } catch (e) {
      _establecerError('Error al actualizar el equipo: $e');
      return false;
    } finally {
      _establecerCargando(false);
    }
  }

  /// Elimina un equipo
  Future<bool> eliminarEquipo(String id) async {
    _establecerCargando(true);
    _limpiarError();

    try {
      await _repository.eliminar(id);
      await cargarEquipos();
      return true;
    } catch (e) {
      _establecerError('Error al eliminar el equipo: $e');
      return false;
    } finally {
      _establecerCargando(false);
    }
  }

  /// Selecciona un equipo
  void seleccionarEquipo(Equipo? equipo) {
    _equipoSeleccionado = equipo;
    notifyListeners();
  }

  /// Busca equipos por nombre
  List<Equipo> buscarEquipos(String query) {
    if (query.isEmpty) return _equipos;

    final queryLower = query.toLowerCase();
    return _equipos.where((equipo) {
      return equipo.nombre.toLowerCase().contains(queryLower) ||
          equipo.pais.toLowerCase().contains(queryLower);
    }).toList();
  }

  /// Obtiene equipos ordenados por campeonatos ganados
  List<Equipo> obtenerEquiposPorCampeonatos() {
    final lista = List<Equipo>.from(_equipos);
    lista.sort((a, b) => b.campeonatosGanados.compareTo(a.campeonatosGanados));
    return lista;
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
