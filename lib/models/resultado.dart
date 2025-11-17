/// Modelo de datos para el resultado de un piloto en una carrera
class Resultado {
  final String id;
  final String carreraId;
  final String pilotoId;
  final int posicion;
  final int? posicionSalida;
  final int puntos;
  final String? tiempoCarrera;
  final bool vueltaRapida;
  final bool abandono;
  final String? razonAbandono;

  Resultado({
    required this.id,
    required this.carreraId,
    required this.pilotoId,
    required this.posicion,
    this.posicionSalida,
    required this.puntos,
    this.tiempoCarrera,
    this.vueltaRapida = false,
    this.abandono = false,
    this.razonAbandono,
  });

  /// Crea una instancia de Resultado desde un JSON
  factory Resultado.fromJson(Map<String, dynamic> json) {
    return Resultado(
      id: json['id'] as String,
      carreraId: json['carreraId'] as String,
      pilotoId: json['pilotoId'] as String,
      posicion: json['posicion'] as int,
      posicionSalida: json['posicionSalida'] as int?,
      puntos: json['puntos'] as int,
      tiempoCarrera: json['tiempoCarrera'] as String?,
      vueltaRapida: json['vueltaRapida'] as bool? ?? false,
      abandono: json['abandono'] as bool? ?? false,
      razonAbandono: json['razonAbandono'] as String?,
    );
  }

  /// Convierte la instancia de Resultado a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carreraId': carreraId,
      'pilotoId': pilotoId,
      'posicion': posicion,
      'posicionSalida': posicionSalida,
      'puntos': puntos,
      'tiempoCarrera': tiempoCarrera,
      'vueltaRapida': vueltaRapida,
      'abandono': abandono,
      'razonAbandono': razonAbandono,
    };
  }

  /// Indica si el piloto terminó la carrera
  bool get termino => !abandono;

  /// Indica si el piloto ganó posiciones respecto a la salida
  bool get ganoPosiciones {
    if (posicionSalida == null) return false;
    return posicion < posicionSalida!;
  }

  /// Número de posiciones ganadas o perdidas
  int? get cambiosPosiciones {
    if (posicionSalida == null) return null;
    return posicionSalida! - posicion;
  }

  /// Crea una copia del resultado con los campos especificados modificados
  Resultado copyWith({
    String? id,
    String? carreraId,
    String? pilotoId,
    int? posicion,
    int? posicionSalida,
    int? puntos,
    String? tiempoCarrera,
    bool? vueltaRapida,
    bool? abandono,
    String? razonAbandono,
  }) {
    return Resultado(
      id: id ?? this.id,
      carreraId: carreraId ?? this.carreraId,
      pilotoId: pilotoId ?? this.pilotoId,
      posicion: posicion ?? this.posicion,
      posicionSalida: posicionSalida ?? this.posicionSalida,
      puntos: puntos ?? this.puntos,
      tiempoCarrera: tiempoCarrera ?? this.tiempoCarrera,
      vueltaRapida: vueltaRapida ?? this.vueltaRapida,
      abandono: abandono ?? this.abandono,
      razonAbandono: razonAbandono ?? this.razonAbandono,
    );
  }

  @override
  String toString() {
    return 'Resultado{id: $id, posicion: $posicion, puntos: $puntos}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Resultado && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
