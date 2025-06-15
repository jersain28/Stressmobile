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
            // Gráfica
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: borderColor.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          final labelStyle = TextStyle(
                            fontSize: 12,
                            color: secondaryTextColor,
                          );
                          switch (value.toInt()) {
                            case 8:
                              return Text('8:00', style: labelStyle);
                            case 10:
                              return Text('10:00', style: labelStyle);
                            case 12:
                              return Text('12:00', style: labelStyle);
                            case 14:
                              return Text('14:00', style: labelStyle);
                            case 16:
                              return Text('16:00', style: labelStyle);
                            case 18:
                              return Text('18:00', style: labelStyle);
                            case 20:
                              return Text('20:00', style: labelStyle);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: borderColor.withOpacity(0.5)),
                  ),
                  minX: 8,
                  maxX: 20,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(8, 40),
                        FlSpot(10, 70),
                        FlSpot(12, 85), // máximo
                        FlSpot(14, 55),
                        FlSpot(16, 35), // mínimo
                        FlSpot(18, 60),
                        FlSpot(20, 50),
                      ],
                      isCurved: true,
                      color: accentColor,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          if (spot.x == 12) {
                            // máximo
                            return FlDotCirclePainter(
                              radius: 6,
                              color: Colors.red,
                              strokeWidth: 2,
                              strokeColor: cardColor,
                            );
                          }
                          if (spot.x == 16) {
                            // mínimo
                            return FlDotCirclePainter(
                              radius: 6,
                              color: Colors.green,
                              strokeWidth: 2,
                              strokeColor: cardColor,
                            );
                          }
                          return FlDotCirclePainter(
                            radius: 4,
                            color: accentColor,
                            strokeWidth: 1,
                            strokeColor: cardColor,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Promedio, Máximo, Mínimo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(context, Icons.bar_chart, '56', 'Promedio', accentColor),
                _buildStatCard(context, Icons.trending_up, '85', 'Máximo', Colors.red),
                _buildStatCard(context, Icons.trending_down, '35', 'Mínimo', Colors.green),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Desglose por horas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: const [
                  _HourDetail(
                    hour: '12:00',
                    description: 'Nivel más alto de estrés',
                    value: '85%',
                  ),
                  _HourDetail(
                    hour: '14:00',
                    description: 'Después del almuerzo',
                    value: '55%',
                  ),
                  _HourDetail(
                    hour: '16:00',
                    description: 'Nivel más bajo registrado',
                    value: '35%',
                  ),
                  _HourDetail(
                    hour: '18:00',
                    description: 'Final de la jornada',
                    value: '60%',
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
