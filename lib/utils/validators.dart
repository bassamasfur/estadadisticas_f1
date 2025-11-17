/// Utilidades para validación de datos
class Validators {
  Validators._();

  /// Valida que un string no esté vacío
  static bool esTextoValido(String? texto) {
    return texto != null && texto.trim().isNotEmpty;
  }

  /// Valida un número positivo
  static bool esNumeroPositivo(num? numero) {
    return numero != null && numero > 0;
  }

  /// Valida un email
  static bool esEmailValido(String? email) {
    if (email == null || email.isEmpty) return false;
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  /// Valida una URL
  static bool esUrlValida(String? url) {
    if (url == null || url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Valida un rango de números
  static bool estaEnRango(num valor, num min, num max) {
    return valor >= min && valor <= max;
  }
}
