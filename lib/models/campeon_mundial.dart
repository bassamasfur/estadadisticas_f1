/// Modelo para un campeón mundial de F1
class CampeonMundial {
  final String temporada;
  final String nombre;
  final String apellido;
  final String nacionalidad;
  final String? fechaNacimiento;
  final int puntos;
  final int victorias;
  final String equipoId;
  final String equipoNombre;

  CampeonMundial({
    required this.temporada,
    required this.nombre,
    required this.apellido,
    required this.nacionalidad,
    this.fechaNacimiento,
    required this.puntos,
    required this.victorias,
    required this.equipoId,
    required this.equipoNombre,
  });

  /// Crea una instancia desde el JSON de Ergast API
  factory CampeonMundial.fromErgastJson(
    Map<String, dynamic> json,
    String season,
  ) {
    final driver = json['Driver'] as Map<String, dynamic>;
    final constructors = json['Constructors'] as List;
    final constructor = constructors.isNotEmpty ? constructors[0] : {};

    return CampeonMundial(
      temporada: season,
      nombre: driver['givenName'] as String,
      apellido: driver['familyName'] as String,
      nacionalidad: driver['nationality'] as String,
      fechaNacimiento: driver['dateOfBirth'] as String?,
      puntos: int.tryParse(json['points'] as String? ?? '0') ?? 0,
      victorias: int.tryParse(json['wins'] as String? ?? '0') ?? 0,
      equipoId: constructor['constructorId'] as String? ?? '',
      equipoNombre: constructor['name'] as String? ?? '',
    );
  }

  String get nombreCompleto => '$nombre $apellido';

  @override
  String toString() {
    return 'CampeonMundial{temporada: $temporada, nombreCompleto: $nombreCompleto}';
  }
}
