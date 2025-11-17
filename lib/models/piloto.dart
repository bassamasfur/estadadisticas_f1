/// Modelo de datos para un piloto de Fórmula 1
class Piloto {
  final String id;
  final String nombre;
  final String apellido;
  final String numero;
  final String nacionalidad;
  final String fechaNacimiento;
  final String? urlImagen;
  final String equipoId;
  final int puntos;

  Piloto({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.numero,
    required this.nacionalidad,
    required this.fechaNacimiento,
    this.urlImagen,
    required this.equipoId,
    this.puntos = 0,
  });

  /// Crea una instancia de Piloto desde un JSON
  factory Piloto.fromJson(Map<String, dynamic> json) {
    return Piloto(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      numero: json['numero'] as String,
      nacionalidad: json['nacionalidad'] as String,
      fechaNacimiento: json['fechaNacimiento'] as String,
      urlImagen: json['urlImagen'] as String?,
      equipoId: json['equipoId'] as String,
      puntos: json['puntos'] as int? ?? 0,
    );
  }

  /// Convierte la instancia de Piloto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'numero': numero,
      'nacionalidad': nacionalidad,
      'fechaNacimiento': fechaNacimiento,
      'urlImagen': urlImagen,
      'equipoId': equipoId,
      'puntos': puntos,
    };
  }

  /// Devuelve el nombre completo del piloto
  String get nombreCompleto => '$nombre $apellido';

  /// Crea una copia del piloto con los campos especificados modificados
  Piloto copyWith({
    String? id,
    String? nombre,
    String? apellido,
    String? numero,
    String? nacionalidad,
    String? fechaNacimiento,
    String? urlImagen,
    String? equipoId,
  }) {
    return Piloto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      numero: numero ?? this.numero,
      nacionalidad: nacionalidad ?? this.nacionalidad,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      urlImagen: urlImagen ?? this.urlImagen,
      equipoId: equipoId ?? this.equipoId,
    );
  }

  @override
  String toString() {
    return 'Piloto{id: $id, nombreCompleto: $nombreCompleto, numero: $numero}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Piloto && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
