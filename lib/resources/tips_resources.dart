import 'package:flutter/material.dart';
import 'package:stress/home/stress_history.dart';
import 'package:stress/home/stress_monitor.dart';
import 'package:stress/settings/account_info.dart';
import 'package:stress/settings/settings.dart';

import 'tip_detail_screen.dart'; // Importa la pantalla de detalle

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = theme.cardColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final iconColor = theme.iconTheme.color ?? (isDark ? Colors.white70 : Colors.black54);
    final titleColor = theme.textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black);
    final descColor = theme.textTheme.bodyMedium?.color?.withOpacity(0.8) ?? (isDark ? Colors.white70 : Colors.black87);

    final tips = [
      {
        'icon': Icons.air,
        'title': 'Ejercicios de Respiración',
        'desc': 'Aprende técnicas de respiración profunda para reducir el estrés y la ansiedad.',
        'details': '1. Siéntate en un lugar cómodo.\n'
            '2. Inhala profundamente por la nariz contando hasta 4.\n'
            '3. Mantén el aire en tus pulmones contando hasta 4.\n'
            '4. Exhala lentamente por la boca contando hasta 4.\n'
            '5. Repite este ciclo 5 veces.\n\n'
            'Este ejercicio ayuda a calmar el sistema nervioso y reducir la ansiedad rápidamente.',
      },
      {
        'icon': Icons.self_improvement,
        'title': 'Meditación Guiada',
        'desc': 'Descubre el poder de la meditación con nuestras sesiones guiadas.',
        'details': 'Busca un audio de meditación guiada o usa una app.\n'
            'Encuentra un lugar tranquilo, cierra los ojos y sigue las instrucciones del audio.\n'
            'La meditación diaria puede mejorar tu concentración y bienestar emocional.',
      },
      {
        'icon': Icons.fitness_center,
        'title': 'Técnicas de Relajación Muscular',
        'desc': 'Explora métodos efectivos para relajar tu cuerpo y mente.',
        'details': 'Tensa y relaja cada grupo muscular de tu cuerpo, comenzando por los pies y subiendo hasta la cabeza.\n'
            'Este método ayuda a liberar la tensión física acumulada por el estrés.',
      },
      {
        'icon': Icons.spa,
        'title': 'Mindfulness Diario',
        'desc': 'Incorpora la atención plena en tu rutina diaria.',
        'details': 'Presta atención a tu respiración, a los sonidos y sensaciones a tu alrededor.\n'
            'Haz una pausa consciente varias veces al día para observar tus pensamientos sin juzgarlos.',
      },
      {
        'icon': Icons.health_and_safety,
        'title': 'Rutinas de Autocuidado',
        'desc': 'Descubre hábitos saludables y prácticas de autocuidado.',
        'details': 'Dedica tiempo a actividades que disfrutes, como leer, caminar o escuchar música.\n'
            'El autocuidado regular mejora tu estado de ánimo y tu salud general.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Consejos y Recursos',
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: ListView.separated(
          itemCount: tips.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final tip = tips[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TipDetailScreen(
                      icon: tip['icon'] as IconData,
                      title: tip['title'] as String,
                      desc: tip['desc'] as String,
                      details: tip['details'] as String, // Pasa el detalle
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    if (!isDark)
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
                      color: iconColor,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tip['title'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: titleColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tip['desc'] as String,
                            style: TextStyle(
                              color: descColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
        backgroundColor: backgroundColor,
      ),
    );
  }
}
