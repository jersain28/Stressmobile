import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stress/home/stress_monitor.dart';
import 'package:stress/resources/tips_resources.dart';
import 'package:stress/settings/account_info.dart';
import 'package:stress/settings/settings.dart';

class StressHistoryScreen extends StatefulWidget {
  final int selectedIndex;
  const StressHistoryScreen({super.key, this.selectedIndex = 1});

  @override
  State<StressHistoryScreen> createState() => StressHistoryScreenState();
}

class StressHistoryScreenState extends State<StressHistoryScreen> {
  int _tabIndex = 0;
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

  // --- Agrupa y filtra según el tab ---
  List<QueryDocumentSnapshot> _filtrarMediciones(List<QueryDocumentSnapshot> docs) {
    final now = DateTime.now();
    if (_tabIndex == 0) {
      // Día
      final inicioDia = DateTime(now.year, now.month, now.day);
      return docs.where((doc) {
        final fecha = (doc['fecha'] as Timestamp).toDate();
        return fecha.isAfter(inicioDia);
      }).toList();
    } else if (_tabIndex == 1) {
      // Semana
      final inicioSemana = now.subtract(Duration(days: now.weekday - 1));
      return docs.where((doc) {
        final fecha = (doc['fecha'] as Timestamp).toDate();
        return fecha.isAfter(DateTime(inicioSemana.year, inicioSemana.month, inicioSemana.day));
      }).toList();
    } else {
      // Mes
      final inicioMes = DateTime(now.year, now.month, 1);
      return docs.where((doc) {
        final fecha = (doc['fecha'] as Timestamp).toDate();
        return fecha.isAfter(inicioMes);
      }).toList();
    }
  }

  // --- Convierte a FlSpot para la gráfica ---
  List<FlSpot> _buildSpots(List<QueryDocumentSnapshot> docs) {
    if (docs.isEmpty) return [];
    docs.sort((a, b) => (a['fecha'] as Timestamp).compareTo(b['fecha'] as Timestamp));
    return docs.asMap().entries.map((entry) {
      final i = entry.key;
      final valor = entry.value['valor'] as int;
      return FlSpot(i.toDouble(), valor.toDouble());
    }).toList();
  }

  // --- Calcula promedio, máximo, mínimo ---
  Map<String, int> _calcularStats(List<QueryDocumentSnapshot> docs) {
    if (docs.isEmpty) return {'promedio': 0, 'max': 0, 'min': 0};
    final valores = docs.map((e) => e['valor'] as int).toList();
    final promedio = valores.reduce((a, b) => a + b) ~/ valores.length;
    final max = valores.reduce((a, b) => a > b ? a : b);
    final min = valores.reduce((a, b) => a < b ? a : b);
    return {'promedio': promedio, 'max': max, 'min': min};
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Historial de Estrés',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTab(context, 'Día', 0),
                _buildTab(context, 'Semana', 1),
                _buildTab(context, 'Mes', 2),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('mediciones_estres')
                    .orderBy('fecha')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = _filtrarMediciones(snapshot.data!.docs);
                  final spots = _buildSpots(docs);
                  final stats = _calcularStats(docs);

                  return Column(
                    children: [
                      // Gráfica
                      SizedBox(
                        height: 180,
                        child: LineChart(
                          LineChartData(
                            minX: 0,
                            maxX: spots.isNotEmpty ? spots.length - 1 : 1,
                            minY: 0,
                            maxY: 100,
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                color: accentColor,
                                barWidth: 3,
                                dotData: FlDotData(show: true),
                              ),
                            ],
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: borderColor.withOpacity(0.5)),
                            ),
                            gridData: FlGridData(show: false),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Promedio, Máximo, Mínimo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatCard(context, Icons.bar_chart, '${stats['promedio']}', 'Promedio', accentColor),
                          _buildStatCard(context, Icons.trending_up, '${stats['max']}', 'Máximo', Colors.red),
                          _buildStatCard(context, Icons.trending_down, '${stats['min']}', 'Mínimo', Colors.green),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Desglose por horas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (docs.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No hay mediciones registradas.', style: TextStyle(fontSize: 16)),
                        )
                      else
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              final ahora = DateTime.now();
                              final hace24h = ahora.subtract(const Duration(hours: 24));
                              final docsUltimas24h = docs.where((doc) {
                                final fecha = (doc['fecha'] as Timestamp).toDate();
                                return fecha.isAfter(hace24h);
                              }).toList();

                              if (docsUltimas24h.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text('No hay mediciones en las últimas 24 horas.', style: TextStyle(fontSize: 16)),
                                );
                              }

                              return ListView.builder(
                                itemCount: docsUltimas24h.length,
                                itemBuilder: (context, index) {
                                  final doc = docsUltimas24h[index];
                                  final fecha = (doc['fecha'] as Timestamp).toDate();
                                  final valor = doc['valor'];
                                  return _HourDetail(
                                    hour: '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}',
                                    description: 'Medición',
                                    value: '$valor%',
                                  );
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  );
                },
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

  Widget _buildTab(BuildContext context, String label, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final selected = _tabIndex == index;
    final selectedColor = isDark ? colorScheme.primary.withOpacity(0.15) : colorScheme.primary.withOpacity(0.08);
    final selectedBorderColor = colorScheme.primary;
    final textColor = theme.textTheme.bodyMedium?.color;
    final secondaryTextColor = theme.textTheme.bodySmall?.color?.withOpacity(0.7) ?? (isDark ? Colors.white70 : Colors.black54);

    return GestureDetector(
      onTap: () {
        setState(() {
          _tabIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? selectedBorderColor : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? colorScheme.primary : secondaryTextColor,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyMedium?.color;
    final secondaryTextColor = theme.textTheme.bodySmall?.color?.withOpacity(0.7);

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 13, color: secondaryTextColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _HourDetail extends StatelessWidget {
  final String hour;
  final String description;
  final String value;

  const _HourDetail({
    required this.hour,
    required this.description,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color;
    final secondaryTextColor = theme.textTheme.bodySmall?.color?.withOpacity(0.7);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              hour,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: TextStyle(color: secondaryTextColor, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor),
          ),
        ],
      ),
    );
  }
}
