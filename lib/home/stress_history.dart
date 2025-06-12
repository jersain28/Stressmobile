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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Historial de Estrés',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
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
                _buildTab('Día', 0),
                _buildTab('Semana', 1),
                _buildTab('Mes', 2),
              ],
            ),
            const SizedBox(height: 12),
            // Gráfica
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
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
                          switch (value.toInt()) {
                            case 8:
                              return const Text('8:00', style: TextStyle(fontSize: 12));
                            case 10:
                              return const Text('10:00', style: TextStyle(fontSize: 12));
                            case 12:
                              return const Text('12:00', style: TextStyle(fontSize: 12));
                            case 14:
                              return const Text('14:00', style: TextStyle(fontSize: 12));
                            case 16:
                              return const Text('16:00', style: TextStyle(fontSize: 12));
                            case 18:
                              return const Text('18:00', style: TextStyle(fontSize: 12));
                            case 20:
                              return const Text('20:00', style: TextStyle(fontSize: 12));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black12),
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
                      color: Color(0xFFB0B8D1),
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
                              strokeColor: Colors.white,
                            );
                          }
                          if (spot.x == 16) {
                            // mínimo
                            return FlDotCirclePainter(
                              radius: 6,
                              color: Colors.green,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          }
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Color(0xFFB0B8D1),
                            strokeWidth: 1,
                            strokeColor: Colors.white,
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
                _buildStatCard(Icons.bar_chart, '56', 'Promedio', Colors.blue),
                _buildStatCard(Icons.trending_up, '85', 'Máximo', Colors.red),
                _buildStatCard(
                  Icons.trending_down,
                  '35',
                  'Mínimo',
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'Desglose por horas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final bool selected = _tabIndex == index;
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
          color: selected ? const Color(0xFFEFF1F7) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? const Color(0xFFB0B8D1) : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.black54,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF1F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              hour,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
