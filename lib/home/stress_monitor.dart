import 'package:flutter/material.dart';
import 'package:stress/home/stress_history.dart';
import 'package:stress/resources/tips_resources.dart';
import 'package:stress/settings/account_info.dart';
import 'package:stress/settings/settings.dart';

class StressMonitorScreen extends StatefulWidget {
  final int selectedIndex;
  const StressMonitorScreen({super.key, this.selectedIndex = 0});

  @override
  State<StressMonitorScreen> createState() => _StressMonitorScreenState();
}

class _StressMonitorScreenState extends State<StressMonitorScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StressMonitorScreen(selectedIndex: 0)),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StressHistoryScreen(selectedIndex: 1)),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TipsResourcesScreen(selectedIndex: 2)),
      );
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen(selectedIndex: 3)),
      );
    }
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AccountInfoScreen(selectedIndex: 4)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Valores simulados, puedes reemplazarlos por tus datos reales
    const int stressLevel = 65;
    const int dayStress = 72;
    const int weekStress = 68;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyMedium?.color;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final borderColor = isDark ? colorScheme.primary.withOpacity(0.4) : const Color(0xFFB0B8D1);
    final accentColor = colorScheme.primary;
    final secondaryTextColor = theme.textTheme.bodySmall?.color?.withOpacity(0.7) ?? (isDark ? Colors.white70 : Colors.black54);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Monitor de Estrés',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.sync, color: accentColor, size: 22),
                const SizedBox(height: 2),
                Text(
                  'Conectado',
                  style: TextStyle(color: secondaryTextColor, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$stressLevel',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nivel de estrés actual',
                        style: TextStyle(fontSize: 16, color: secondaryTextColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 36),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Column(
                        children: [
                          Text(
                            'Estrés del día',
                            style: TextStyle(color: colorScheme.onPrimary, fontSize: 15),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$dayStress',
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(width: 1, height: 48, color: Colors.white24),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Column(
                        children: [
                          Text(
                            'Estrés de la semana',
                            style: TextStyle(color: colorScheme.onPrimary, fontSize: 15),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$weekStress',
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
