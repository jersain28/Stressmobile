import 'package:flutter/material.dart';
import 'package:stress/home/stress_history.dart';
import 'package:stress/home/stress_monitor.dart';
import 'package:stress/resources/tips_resources.dart';
import 'package:stress/settings/account_info.dart';

class SettingsScreen extends StatefulWidget {
  final int selectedIndex;
  const SettingsScreen({super.key, this.selectedIndex = 3});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  int _selectedColor = 0; // 0: azul, 1: rojo, 2: verde
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Configuración',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF6F6F6),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Smartwatch
          const Text(
            'Smartwatch',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: const Icon(Icons.watch, color: Colors.black54),
              title: const Text('Smartwatch conectado:'),
              subtitle: Row(
                children: const [
                  Icon(Icons.circle, color: Colors.green, size: 12),
                  SizedBox(width: 4),
                  Text('Conectado', style: TextStyle(fontSize: 13)),
                ],
              ),
              trailing: TextButton(
                onPressed: () {
                  // Acción para desconectar
                },
                child: const Text(
                  'Desconectar',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Notificaciones
          const Text(
            'Notificaciones',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications, color: Colors.black54),
              title: const Text('Activar notificaciones'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          // Personalización
          const Text(
            'Personalización',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: const Icon(Icons.color_lens, color: Colors.black54),
              title: const Text('Colores del tema'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _colorCircle(0, Colors.blue),
                  const SizedBox(width: 8),
                  _colorCircle(1, Colors.red),
                  const SizedBox(width: 8),
                  _colorCircle(2, Colors.green),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Cuenta
          const Text(
            'Cuenta',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: const Icon(Icons.person_outline, color: Colors.black54),
              title: const Text('Información de la cuenta'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AccountInfoScreen(selectedIndex: 4),
                  ),
                );
              },
            ),
          ),
        ],
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
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Cuenta',
          ),
        ],
        backgroundColor: Color(0xFFF6F6F6),
      ),
    );
  }

  Widget _colorCircle(int index, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = index;
        });
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == index ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
