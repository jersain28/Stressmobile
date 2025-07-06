import 'package:cloud_firestore/cloud_firestore.dart';
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

  String obtenerNivelEstres(int valor) {
    if (valor >= 1 && valor <= 29) {
      return 'BAJO';
    } else if (valor >= 30 && valor <= 59) {
      return 'NORMAL';
    } else if (valor >= 60 && valor <= 79) {
      return 'MODERADO';
    } else if (valor >= 80 && valor <= 99) {
      return 'ALTO';
    } else {
      return 'DESCONOCIDO';
    }
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('mediciones_estres')
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          // Última medición
          final ultimaMedicion = docs.isNotEmpty ? docs.first : null;
          int stressLevel = ultimaMedicion?['valor'] ?? 0;
          String nivelActual = obtenerNivelEstres(stressLevel);

          // Mediciones del día
          final now = DateTime.now();
          final inicioDia = DateTime(now.year, now.month, now.day);
          final medicionesDia = docs.where((doc) {
            final fecha = (doc['fecha'] as Timestamp).toDate();
            return fecha.isAfter(inicioDia);
          }).toList();

          double dayStress = medicionesDia.isNotEmpty
              ? medicionesDia.map((e) => e['valor'] as int).reduce((a, b) => a + b) / medicionesDia.length
              : 0;

          // Mediciones de la semana
          final inicioSemana = now.subtract(Duration(days: now.weekday - 1));
          final medicionesSemana = docs.where((doc) {
            final fecha = (doc['fecha'] as Timestamp).toDate();
            return fecha.isAfter(DateTime(inicioSemana.year, inicioSemana.month, inicioSemana.day));
          }).toList();

          double weekStress = medicionesSemana.isNotEmpty
              ? medicionesSemana.map((e) => e['valor'] as int).reduce((a, b) => a + b) / medicionesSemana.length
              : 0;

          // --- Aquí va tu UI, igual que antes ---
          return Padding(
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
                            'Nivel de estrés actual: $nivelActual',
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
                                dayStress.toStringAsFixed(1),
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
                                weekStress.toStringAsFixed(1),
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
          );
        },
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
