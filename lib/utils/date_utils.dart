/// Utilidades para formatear fechas
class DateUtils {
  DateUtils._();

  /// Formatea una fecha en formato legible
  static String formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  /// Calcula la diferencia de días entre dos fechas
  static int diasEntre(DateTime fecha1, DateTime fecha2) {
    return fecha2.difference(fecha1).inDays;
  }

  /// Verifica si una fecha es hoy
  static bool esHoy(DateTime fecha) {
    final ahora = DateTime.now();
    return fecha.year == ahora.year &&
        fecha.month == ahora.month &&
        fecha.day == ahora.day;
  }

  /// Verifica si una fecha es futura
  static bool esFutura(DateTime fecha) {
    return fecha.isAfter(DateTime.now());
  }
}
