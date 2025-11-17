/// Constantes de la aplicación
class AppConstants {
  // Prevenir instanciación
  AppConstants._();

  // URLs de API (ejemplo)
  static const String baseUrl = 'https://api.formula1.com';
  static const String apiVersion = 'v1';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Límites
  static const int maxResultadosPorPagina = 20;
  static const int maxIntentos = 3;

  // Valores por defecto
  static const String idiomaDefecto = 'es';
  static const String monedaDefecto = 'EUR';

  // Rutas de navegación
  static const String rutaHome = '/';
  static const String rutaPilotos = '/pilotos';
  static const String rutaEquipos = '/equipos';
  static const String rutaCarreras = '/carreras';
  static const String rutaEstadisticas = '/estadisticas';

  // Claves de almacenamiento local
  static const String keyTemaOscuro = 'tema_oscuro';
  static const String keyIdiomaApp = 'idioma_app';
  static const String keyUltimaActualizacion = 'ultima_actualizacion';

  // Mensajes de error
  static const String errorConexion =
      'Error de conexión. Verifica tu internet.';
  static const String errorServidor = 'Error del servidor. Intenta más tarde.';
  static const String errorDatosNoEncontrados = 'No se encontraron datos.';
  static const String errorGenerico = 'Ha ocurrido un error inesperado.';
}
