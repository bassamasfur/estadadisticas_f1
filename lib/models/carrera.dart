/// Modelo de datos para una carrera de Fórmula 1
class Carrera {
  final String id;
  final String nombre;
  final String circuito;
  final String pais;
  final DateTime fecha;
  final int numeroVueltas;
  final double longitudCircuito;
  final String? imagenCircuito;
  final String? ganador;
  final String? equipoGanador;

  Carrera({
    required this.id,
    required this.nombre,
    required this.circuito,
    required this.pais,
    required this.fecha,
    required this.numeroVueltas,
    required this.longitudCircuito,
    this.imagenCircuito,
    this.ganador,
    this.equipoGanador,
  });

  /// Crea una instancia de Carrera desde un JSON
  factory Carrera.fromJson(Map<String, dynamic> json) {
    return Carrera(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      circuito: json['circuito'] as String,
      pais: json['pais'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      numeroVueltas: json['numeroVueltas'] as int,
      longitudCircuito: (json['longitudCircuito'] as num).toDouble(),
      imagenCircuito: json['imagenCircuito'] as String?,
      ganador: json['ganador'] as String?,
      equipoGanador: json['equipoGanador'] as String?,
    );
  }

  /// Convierte la instancia de Carrera a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'circuito': circuito,
      'pais': pais,
      'fecha': fecha.toIso8601String(),
      'numeroVueltas': numeroVueltas,
      'longitudCircuito': longitudCircuito,
      'imagenCircuito': imagenCircuito,
      'ganador': ganador,
      'equipoGanador': equipoGanador,
    };
  }

  /// Indica si la carrera ya se realizó
  bool get yaRealizada => fecha.isBefore(DateTime.now());

  /// Distancia total de la carrera en kilómetros
  double get distanciaTotal => longitudCircuito * numeroVueltas;

  /// Crea una copia de la carrera con los campos especificados modificados
  Carrera copyWith({
    String? id,
    String? nombre,
    String? circuito,
    String? pais,
    DateTime? fecha,
    int? numeroVueltas,
    double? longitudCircuito,
    String? imagenCircuito,
  }) {
    return Carrera(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      circuito: circuito ?? this.circuito,
      pais: pais ?? this.pais,
      fecha: fecha ?? this.fecha,
      numeroVueltas: numeroVueltas ?? this.numeroVueltas,
      longitudCircuito: longitudCircuito ?? this.longitudCircuito,
      imagenCircuito: imagenCircuito ?? this.imagenCircuito,
    );
  }

  @override
  String toString() {
    return 'Carrera{id: $id, nombre: $nombre, fecha: ${fecha.toIso8601String()}}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Carrera && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
