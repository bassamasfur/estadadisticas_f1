/// Modelo de datos para estadísticas generales de F1
class EstadisticasF1 {
  final int titulos;
  final int victorias;
  final int polePositions;
  final int podiums;
  final int puntos;
  final int carreras;

  EstadisticasF1({
    required this.titulos,
    required this.victorias,
    required this.polePositions,
    required this.podiums,
    required this.puntos,
    required this.carreras,
  });

  /// Crea una instancia de EstadisticasF1 desde un JSON
  factory EstadisticasF1.fromJson(Map<String, dynamic> json) {
    return EstadisticasF1(
      titulos: json['titulos'] as int,
      victorias: json['victorias'] as int,
      polePositions: json['polePositions'] as int,
      podiums: json['podiums'] as int,
      puntos: json['puntos'] as int,
      carreras: json['carreras'] as int,
    );
  }

  /// Convierte la instancia de EstadisticasF1 a JSON
  Map<String, dynamic> toJson() {
    return {
      'titulos': titulos,
      'victorias': victorias,
      'polePositions': polePositions,
      'podiums': podiums,
      'puntos': puntos,
      'carreras': carreras,
    };
  }

  /// Crea una copia con los campos especificados modificados
  EstadisticasF1 copyWith({
    int? titulos,
    int? victorias,
    int? polePositions,
    int? podiums,
    int? puntos,
    int? carreras,
  }) {
    return EstadisticasF1(
      titulos: titulos ?? this.titulos,
      victorias: victorias ?? this.victorias,
      polePositions: polePositions ?? this.polePositions,
      podiums: podiums ?? this.podiums,
      puntos: puntos ?? this.puntos,
      carreras: carreras ?? this.carreras,
    );
  }

  /// Retorna estadísticas vacías (iniciales)
  factory EstadisticasF1.vacio() {
    return EstadisticasF1(
      titulos: 0,
      victorias: 0,
      polePositions: 0,
      podiums: 0,
      puntos: 0,
      carreras: 0,
    );
  }

  @override
  String toString() {
    return 'EstadisticasF1{titulos: $titulos, victorias: $victorias, podiums: $podiums}';
  }
}
