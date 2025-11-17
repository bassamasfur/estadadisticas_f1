# Estructura MVC - Estadísticas F1

Esta aplicación Flutter sigue una arquitectura MVC (Modelo-Vista-Controlador) con las mejores prácticas de programación.

## 📁 Estructura del Proyecto

```
lib/
├── models/           # Modelos de datos
│   ├── piloto.dart
│   ├── equipo.dart
│   ├── carrera.dart
│   └── resultado.dart
│
├── views/            # Interfaces de usuario
│   ├── home_view.dart
│   ├── pilotos_view.dart
│   ├── equipos_view.dart
│   └── carreras_view.dart
│
├── controllers/      # Lógica de negocio y gestión de estado
│   ├── piloto_controller.dart
│   ├── equipo_controller.dart
│   └── carrera_controller.dart
│
├── repositories/     # Capa de acceso a datos
│   ├── piloto_repository.dart
│   ├── equipo_repository.dart
│   └── carrera_repository.dart
│
├── services/         # Servicios externos (HTTP, etc.)
│   └── http_service.dart
│
├── widgets/          # Componentes reutilizables
│   ├── loading_widget.dart
│   ├── error_widget.dart
│   └── empty_state_widget.dart
│
├── config/           # Configuración de la app
│   ├── app_constants.dart
│   └── app_theme.dart
│
├── utils/            # Utilidades y helpers
│   ├── date_utils.dart
│   └── validators.dart
│
└── main.dart         # Punto de entrada
```

## 🏗️ Arquitectura

### Modelos (Models)
- **Responsabilidad**: Representar las estructuras de datos
- **Características**:
  - Clases inmutables
  - Métodos `fromJson()` y `toJson()` para serialización
  - Método `copyWith()` para crear copias modificadas
  - Sobrecarga de operadores `==` y `hashCode`

### Vistas (Views)
- **Responsabilidad**: Presentar la interfaz de usuario
- **Características**:
  - Widgets sin lógica de negocio
  - Usan `Consumer` de Provider para escuchar cambios
  - Enfocadas solo en la presentación visual

### Controladores (Controllers)
- **Responsabilidad**: Gestionar el estado y la lógica de negocio
- **Características**:
  - Heredan de `ChangeNotifier`
  - Contienen la lógica de la aplicación
  - Notifican cambios a las vistas
  - Interactúan con los repositorios

### Repositorios (Repositories)
- **Responsabilidad**: Abstraer el acceso a datos
- **Características**:
  - Patrón Repository para desacoplar fuente de datos
  - Interfaz abstracta + implementación concreta
  - Facilita testing y cambio de fuente de datos

## 🔧 Tecnologías Utilizadas

- **Flutter**: Framework de UI
- **Provider**: Gestión de estado (patrón Observer)
- **HTTP**: Cliente HTTP para APIs REST
- **Intl**: Internacionalización y formateo de fechas

## 🚀 Cómo Ejecutar

1. Instalar dependencias:
```bash
flutter pub get
```

2. Ejecutar la aplicación:
```bash
flutter run
```

## 📋 Características Principales

- ✅ Separación clara de responsabilidades (MVC)
- ✅ Código reutilizable y mantenible
- ✅ Gestión de estado reactiva con Provider
- ✅ Temas claro y oscuro
- ✅ Navegación por pestañas
- ✅ Manejo de errores centralizado
- ✅ Widgets reutilizables
- ✅ Constantes y configuración centralizadas

## 🎨 Buenas Prácticas Implementadas

1. **Principios SOLID**
   - Responsabilidad única (Single Responsibility)
   - Abierto/Cerrado (Open/Closed)
   - Inversión de dependencias (Dependency Inversion)

2. **Clean Code**
   - Nombres descriptivos
   - Funciones pequeñas y enfocadas
   - Comentarios útiles
   - Código auto-documentado

3. **DRY (Don't Repeat Yourself)**
   - Widgets reutilizables
   - Constantes centralizadas
   - Utilidades compartidas

4. **Separation of Concerns**
   - Lógica separada de la UI
   - Capa de datos abstraída
   - Configuración centralizada

5. **Error Handling**
   - Try-catch en operaciones asíncronas
   - Mensajes de error informativos
   - Estados de carga y error

## 📝 Extensibilidad

Para agregar nuevas funcionalidades:

1. Crear el modelo en `models/`
2. Implementar el repositorio en `repositories/`
3. Crear el controlador en `controllers/`
4. Diseñar la vista en `views/`
5. Registrar providers en `main.dart`

---

**Desarrollado siguiendo las mejores prácticas de Flutter y arquitectura MVC**
