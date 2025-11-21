import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'controllers/piloto_controller.dart';
import 'controllers/equipo_controller.dart';
import 'controllers/carrera_controller.dart';
import 'controllers/estadisticas_controller.dart';
import 'controllers/campeones_controller.dart';
import 'repositories/piloto_repository.dart';
import 'repositories/equipo_repository.dart';
import 'repositories/carrera_repository.dart';
import 'services/wikipedia_f1_service.dart';
import 'views/splash_view.dart';
import 'views/pole_numero_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repositorios
        Provider<PilotoRepository>(create: (_) => PilotoRepositoryImpl()),
        Provider<EquipoRepository>(create: (_) => EquipoRepositoryImpl()),
        Provider<CarreraRepository>(create: (_) => CarreraRepositoryImpl()),

        // Servicios - Wikipedia como fuente de datos
        Provider<WikipediaF1Service>(create: (_) => WikipediaF1Service()),

        // Controladores
        ChangeNotifierProvider<EstadisticasController>(
          create: (_) => EstadisticasController(),
        ),
        ChangeNotifierProvider<CampeonesController>(
          create: (context) =>
              CampeonesController(context.read<WikipediaF1Service>()),
        ),
        ChangeNotifierProvider<PilotoController>(
          create: (context) =>
              PilotoController(context.read<PilotoRepository>()),
        ),
        ChangeNotifierProvider<EquipoController>(
          create: (context) =>
              EquipoController(context.read<EquipoRepository>()),
        ),
        ChangeNotifierProvider<CarreraController>(
          create: (context) =>
              CarreraController(context.read<CarreraRepository>()),
        ),
      ],
      child: MaterialApp(
        title: '',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.temaClaro,
        darkTheme: AppTheme.temaOscuro,
        themeMode: ThemeMode.system,
        home: const SplashView(),
        routes: {'/pole-numero': (context) => const PoleNumeroView()},
      ),
    );
  }
}
