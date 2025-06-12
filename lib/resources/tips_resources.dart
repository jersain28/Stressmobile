import 'package:flutter/material.dart';
import 'package:stress/home/stress_history.dart';
import 'package:stress/home/stress_monitor.dart';
import 'package:stress/settings/account_info.dart';
import 'package:stress/settings/settings.dart';

class TipsResourcesScreen extends StatefulWidget {
  final int selectedIndex;
  const TipsResourcesScreen({super.key, this.selectedIndex = 2});

  @override
  State<TipsResourcesScreen> createState() => TipsResourcesScreenState();
}

class TipsResourcesScreenState extends State<TipsResourcesScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StressMonitorScreen(selectedIndex: 0),
        ),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StressHistoryScreen(selectedIndex: 1),
        ),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TipsResourcesScreen(selectedIndex: 2),
        ),
      );
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SettingsScreen(selectedIndex: 3),
        ),
      );
    }
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AccountInfoScreen(selectedIndex: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tips = [
      {
        'icon': Icons.air,
        'title': 'Ejercicios de Respiración',
        'desc':
            'Aprende técnicas de respiración profunda para reducir el estrés y la ansiedad. Estas prácticas simples pueden ayudarte a encontrar calma en momentos difíciles.',
      },
      {
        'icon': Icons.self_improvement,
        'title': 'Meditación Guiada',
        'desc':
            'Descubre el poder de la meditación con nuestras sesiones guiadas. Perfectas para principiantes y practicantes experimentados que buscan momentos de paz.',
      },
      {
        'icon': Icons.fitness_center,
        'title': 'Técnicas de Relajación Muscular',
        'desc':
            'Explora métodos efectivos para relajar tu cuerpo y mente. Aprende a liberar la tensión física y mental con ejercicios progresivos.',
      },
      {
        'icon': Icons.spa,
        'title': 'Mindfulness Diario',
        'desc':
            'Incorpora la atención plena en tu rutina diaria. Consejos prácticos para vivir el presente y reducir la ansiedad sobre el futuro.',
      },
      {
        'icon': Icons.health_and_safety,
        'title': 'Rutinas de Autocuidado',
        'desc':
            'Descubre hábitos saludables y prácticas de autocuidado que puedes implementar en tu vida diaria para mejorar tu bienestar general.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Consejos y Recursos',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: ListView.separated(
          itemCount: tips.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final tip = tips[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    tip['icon'] as IconData,
                    color: Colors.black54,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip['title'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          tip['desc'] as String,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
           items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart),
            label: 'Monitor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Consejos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Cuenta',
          ),
        ],
        backgroundColor: Color(0xFFF6F6F6),
      ),
    );
  }
}
