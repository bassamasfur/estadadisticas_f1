/// Modelo de datos para un equipo de Fórmula 1
class Equipo {
  final String id;
  final String nombre;
  final String pais;
  final String colorPrincipal;
  final String? logoUrl;
  final int anioFundacion;
  final int campeonatosGanados;
  final int puntos;

  Equipo({
    required this.id,
    required this.nombre,
    required this.pais,
    required this.colorPrincipal,
    this.logoUrl,
    required this.anioFundacion,
    this.campeonatosGanados = 0,
    this.puntos = 0,
  });

  /// Crea una instancia de Equipo desde un JSON
  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      pais: json['pais'] as String,
      colorPrincipal: json['colorPrincipal'] as String,
      logoUrl: json['logoUrl'] as String?,
      anioFundacion: json['anioFundacion'] as int,
      campeonatosGanados: json['campeonatosGanados'] as int? ?? 0,
      puntos: json['puntos'] as int? ?? 0,
    );
  }

  /// Convierte la instancia de Equipo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'pais': pais,
      'colorPrincipal': colorPrincipal,
      'logoUrl': logoUrl,
      'anioFundacion': anioFundacion,
      'campeonatosGanados': campeonatosGanados,
      'puntos': puntos,
    };
  }

  /// Crea una copia del equipo con los campos especificados modificados
  Equipo copyWith({
    String? id,
    String? nombre,
    String? pais,
    String? colorPrincipal,
    String? logoUrl,
    int? anioFundacion,
    int? campeonatosGanados,
  }) {
    return Equipo(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      pais: pais ?? this.pais,
      colorPrincipal: colorPrincipal ?? this.colorPrincipal,
      logoUrl: logoUrl ?? this.logoUrl,
      anioFundacion: anioFundacion ?? this.anioFundacion,
      campeonatosGanados: campeonatosGanados ?? this.campeonatosGanados,
    );
  }

  @override
  String toString() {
    return 'Equipo{id: $id, nombre: $nombre, pais: $pais}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Equipo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
