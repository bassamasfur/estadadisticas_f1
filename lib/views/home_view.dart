import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/piloto_controller.dart';
import '../controllers/equipo_controller.dart';
import '../controllers/carrera_controller.dart';
import 'estadisticas_view.dart';
import 'pilotos_view.dart';
import 'equipos_view.dart';
import 'carreras_view.dart';

/// Vista principal de la aplicación con navegación por pestañas
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _indiceActual = 0;

  final List<Widget> _vistas = const [
    EstadisticasView(),
    PilotosView(),
    EquiposView(),
    CarrerasView(),
  ];

  @override
  void initState() {
    super.initState();
    // Cargar datos iniciales
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PilotoController>().cargarPilotos();
      context.read<EquipoController>().cargarEquipos();
      context.read<CarreraController>().cargarCarreras();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          'Estadísticas F1',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: _vistas[_indiceActual],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: const Color(0xFF334155),
            indicatorColor: const Color(0xFF3B82F6).withValues(alpha: 0.4),
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _indiceActual,
          onDestinationSelected: (int index) {
            setState(() {
              _indiceActual = index;
            });
          },
          backgroundColor: const Color(0xFF334155),
          indicatorColor: const Color(0xFF3B82F6).withValues(alpha: 0.4),
          surfaceTintColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.dashboard, color: Color(0xFF60A5FA)),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Colors.white),
              selectedIcon: Icon(Icons.person, color: Color(0xFF60A5FA)),
              label: 'Pilotos',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.groups_outlined,
                color: Color.fromARGB(255, 241, 235, 235),
              ),
              selectedIcon: Icon(Icons.groups, color: Color(0xFF60A5FA)),
              label: 'Equipos',
            ),
            NavigationDestination(
              icon: Icon(Icons.flag_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.flag, color: Color(0xFF60A5FA)),
              label: 'Carreras',
            ),
          ],
        ),
      ),
    );
  }
}
